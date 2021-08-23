import UIKit
import SalemoveSDK

class OperatorsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noActiveOperatorsLabel: UILabel!

    var engagementRequest: EngagementRequest?
    private var statusViewController: EngagementStatusViewController?
    var operators: [Operator] = [] {
        didSet {
            configureNoActiveOperatorsLabel()
            tableView.refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }

    class var storyboardInstance: OperatorsViewController? {
        if let controller = UIStoryboard.operators.instantiateViewController(
            withIdentifier: "OperatorsViewController"
            ) as? OperatorsViewController {
            return controller
        } else {
            return nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Operators"

        configureTableView()
        configureCloseButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadOperators()
    }
}

extension OperatorsViewController {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadOperators), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func configureCloseButton() {
        let closeButton = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(closeScreen)
        )

        navigationItem.rightBarButtonItem = closeButton
    }

    @objc private func closeScreen() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func loadOperators() {
        prepareInterfaceForLoading()
        Salemove.sharedInstance.requestOperators { [weak self] operators, error in
            self?.showOperators(operators, error: error)
        }
    }

    private func prepareInterfaceForLoading() {
        noActiveOperatorsLabel.isHidden = true
        tableView.refreshControl?.beginRefreshing()
    }

    private func showOperators(_ operators: [Operator]?, error: SalemoveError?) {
        if let operatorError = error {
            self.showError(message: operatorError.reason)
            self.operators = []
        } else if let operators = operators {
            self.operators = operators
        }
    }

    private func configureNoActiveOperatorsLabel() {
        noActiveOperatorsLabel.text = "No active operators"
        noActiveOperatorsLabel.isHidden = !operators.isEmpty
    }

    private func mediaValues(_ medias: [MediaType]) -> String {
        medias.map { mediaValue($0) }.joined(separator: ", ")
    }

    private func mediaValue(_ media: MediaType) -> String {
        media.rawValue.capitalized
    }
}

extension OperatorsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operators.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentOperator = operators[indexPath.row]

        guard let availableMedia = currentOperator.availableMedia else { return UITableViewCell() }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "operatorTableViewCell", for: indexPath) as? OperatorTableViewCell else {
            debugPrint("could not create OperatorCell")
            return UITableViewCell()
        }

        cell.labelName.text = currentOperator.name
        cell.labelAvailableMedia.text = mediaValues(availableMedia)
        cell.labelAvailableMedia.isHidden = cell.labelAvailableMedia.text?.isEmpty ?? true

        if let picture = currentOperator.picture,
           let stringUrl = picture.url,
           let url = URL(string: stringUrl) {
            cell.imageOperator.kf.setImage(with: url)
        } else {
            cell.imageOperator.image = nil
            cell.imageOperator.backgroundColor = .lightGray
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedOperator = operators[indexPath.row]

        guard let mediaTypes = selectedOperator.availableMedia else { return }

        if shouldShowActionSheet(for: mediaTypes) {
            showEngagementTypeActionSheet(selectedOperator: selectedOperator)
        } else {
            beginEngagement(selectedOperator: selectedOperator)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension OperatorsViewController {
    private func shouldShowActionSheet(for mediaTypes: [MediaType]) -> Bool {
        return mediaTypes.contains(.audio) || mediaTypes.contains(.video)
    }

    private func showEngagementTypeActionSheet(selectedOperator: Operator) {
        guard let mediaTypes = selectedOperator.availableMedia else { return }

        let onTextSelected = { [weak self] in
            self?.beginEngagement(selectedOperator: selectedOperator)
        }

        let onAudioSelected = { [weak self] in
            self?.beginEngagement(selectedOperator: selectedOperator, mediaType: .audio)
        }

        let onOneWayVideoSelected = { [weak self] in
            let options = EngagementOptions(mediaDirection: .oneWay)
            self?.beginEngagement(
                selectedOperator: selectedOperator,
                mediaType: .video,
                options: options
            )
        }

        let onTwoWayVideoSelected = { [weak self] in
            self?.beginEngagement(
                selectedOperator: selectedOperator,
                mediaType: .video
            )
        }

        let factory = MediaTypeActionSheetFactory(
            mediaTypes: mediaTypes,
            onTextSelected: onTextSelected,
            onAudioSelected: onAudioSelected,
            onOneWayVideoSelected: onOneWayVideoSelected,
            onTwoWayVideoSelected: onTwoWayVideoSelected
        )

        let actionSheet = factory.actionSheet()
        present(actionSheet, animated: true, completion: nil)
    }

    private func beginEngagement(
        selectedOperator: Operator,
        mediaType: MediaType = .text,
        options: EngagementOptions? = nil
    ) {
        let context = Configuration.sharedInstance.visitorContext

        Salemove.sharedInstance.requestEngagementWith(
            selectedOperator: selectedOperator,
            visitorContext: context,
            mediaType: mediaType,
            options: options
        ) { [unowned self] engagementRequest, error in
            if let reason = error?.reason {
                self.showError(message: reason)
                return
            }

            self.engagementRequest = engagementRequest
            if let controller = self.statusViewController {
                controller.engagementRequest = engagementRequest
            }

            if let timeout = self.engagementRequest?.timeout {
                print("Processing engagement request within \(timeout) seconds")
            }

            handleOperators(operators: [selectedOperator])
        }
    }

    private func handleOperators(operators: [Operator]) {
        guard let interactor = EngagementStatusViewController.initStoryboardInstance() else {
            debugPrint("could not initialise storyboard for EngagementStatusViewController")
            return
        }
        interactor.chatType = .sync
        Salemove.sharedInstance.configure(interactor: interactor)

        statusViewController = interactor
        statusViewController?.cleanUpBlock = { [unowned self] in
            self.statusViewController?.dismiss(animated: true, completion: nil)
            self.statusViewController = nil
        }

        self.present(interactor, animated: true)
    }
}
