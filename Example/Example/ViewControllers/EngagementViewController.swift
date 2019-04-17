import Foundation
import SalemoveSDK
import Result

enum ChatType {
    case unidentified
    case sync
    case async
}

class EngagementNavigationController: UINavigationController {
}

class EngagementStatusViewController: UIViewController {
    class func initStoryboardInstance() -> EngagementStatusViewController {
        return UIStoryboard.engagement.instantiateViewController(withIdentifier: "EngagementStatusViewController")
            as! EngagementStatusViewController
    }

    var engagementNavigationController: EngagementNavigationController?
    var engagementViewController: EngagementViewController?
    var mediaViewController: MediaViewController?

    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var mediaView: UIView!

    var queueTicket: QueueTicket?
    var engagementRequest: EngagementRequest?
    var chatType: ChatType = .unidentified
    var visitorScreenSharing: VisitorScreenSharingState?

    var cleanUpBlock: (() -> Void)?

    // MARK: System
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpChildControllers()
        setUpInitialViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        engagementViewController?.chatType = chatType
    }

    // MARK: Initialisation

    fileprivate func setUpInitialViews() {
        mediaView.isHidden = true
    }

    fileprivate func setUpChildControllers() {
        engagementNavigationController = childInstance(class: EngagementNavigationController.self)
        engagementViewController = engagementNavigationController?.childInstance(class: EngagementViewController.self)
        mediaViewController = childInstance(class: MediaViewController.self)
    }

    // MARK: Public Methods
    @IBAction func requestAudio(_ sender: Any) {
        let offer = MediaUpgradeOffer(type: MediaType.audio, direction: MediaDirection.twoWay)
        Salemove.sharedInstance.requestMediaUpgrade(offer: offer) { [unowned self] success, _ in
            if success {
                self.audioButton.setTitleColor(UIColor.green, for: .normal)
            }
        }
    }

    @IBAction func requestVideo(_ sender: Any) {
        let offer = MediaUpgradeOffer(type: MediaType.video, direction: MediaDirection.twoWay)
        Salemove.sharedInstance.requestMediaUpgrade(offer: offer) { [unowned self] success, _ in
            if success {
                self.videoButton.setTitleColor(UIColor.green, for: .normal)
            }
        }
    }

    @IBAction func cancelEngagement() {
        if let ticket = queueTicket {
            cancelQueueing(ticket)
        } else if let request = engagementRequest {
            cancelEngagementRequest(request)
        } else {
            endEngagement()
        }
    }

    func cancelQueueing(_ ticket: QueueTicket) {
        Salemove.sharedInstance.cancel(queueTicket: ticket) { [unowned self] _, _ in
            self.queueTicket = nil
            self.cleanUp()
        }
    }

    func cancelEngagementRequest(_ request: EngagementRequest) {
        Salemove.sharedInstance.cancel(engagementRequest: request) { [unowned self] _, _ in
            self.engagementRequest = nil
            self.cleanUp()
        }
    }

    func endEngagement() {
        Salemove.sharedInstance.endEngagement { [unowned self] _, _ in
            self.cleanUp()
        }
    }

    // MARK: Private Methods

    fileprivate func cleanUp() {
        mediaViewController?.cleanUp()
        cleanUpBlock?()
    }
}

extension EngagementStatusViewController {
}

extension EngagementStatusViewController: Interactable {
    var onOperatorTypingStatusUpdate: OperatorTypingStatusUpdate {
        return { _ in }
    }

    var onVisitorScreenSharingStateChange: VisitorScreenSharingStateChange {
        return { [unowned self] state, error in
            if let error = error {
                self.showError(message: error.reason)
            } else {
                DispatchQueue.main.async {
                    self.visitorScreenSharing = state
                }
            }
        }
    }

    var onEngagementRequest: RequestOfferBlock {
        return { answer in
            let success: SuccessBlock = { _, _ in }

            let context = VisitorContext(type: .page, url: "www.glia.com")
            answer(context, true, success)
        }
    }

    var onScreenSharingOffer: ScreenshareOfferBlock {
        return { [unowned self] answer in
            self.showRequestingView(request: "Possibility to share screen", answer: answer)
        }
    }

    var onMediaUpgradeOffer: MediaUgradeOfferBlock {
        return { [unowned self] _, answer in
            self.showRequestingView(request: "Posibility to enable media", answer: answer)
        }
    }

    var onAudioStreamAdded: AudioStreamAddedBlock {
        return { [unowned self] stream, error in
            if let stream = stream {
                DispatchQueue.main.async {
                    self.mediaView.isHidden = false
                    self.mediaViewController?.handleAudioStream(stream: stream)
                }
            } else if let error = error {
                self.showError(message: error.reason)
            }
        }
    }

    var onVideoStreamAdded: VideoStreamAddedBlock {
        return { [unowned self] stream, error in
            if let stream = stream {
                DispatchQueue.main.async {
                    self.mediaView.isHidden = false
                    self.mediaViewController?.handleVideoStream(stream: stream)
                }
            } else if let error = error {
                self.showError(message: error.reason)
            }
        }
    }

    var onMessagesUpdated: MessagesUpdateBlock {
        return { [unowned self] messages in
            self.engagementViewController?.update(with: messages)
        }
    }

    func showRequestingView(request: String, answer: (Bool) -> Void) {
        // Show some UI Dialog asking for permission
        answer(true)
    }

    func start() {
        // Remove any spinners or activity indicators and proceed with the flow


        queueTicket = nil
        engagementRequest = nil
    }

    func end() {
        // Remove any active sessions and do a cleanup and maybe dismiss the controller
        endEngagement()
    }

    func fail(error: SalemoveError) {
        // Handle the failing Engagement request and maybe log the reason or show it to the user
        showError(message: error.reason)
    }

    func receive(message: Message) {
        engagementViewController?.update(with: message)
    }

    func selectQueue(queueID: String) {
        engagementViewController?.queueID = queueID
    }

    func handleOperators(operators: [Operator]) {
        // Remove any spinners or activity indicators and proceed with the flow of selecting an Operator

        let controller = UIAlertController(title: "Operators", message: "Please select", preferredStyle: .actionSheet)

        for availableOperator in operators {
            let action = UIAlertAction(title: availableOperator.name, style: .default) { _ in
                let context = VisitorContext(type: .page, url: "www.glia.com")

                // Select an operator and pass it to the client library
                Salemove.sharedInstance.requestEngagementWith(selectedOperator: availableOperator, visitorContext: context) { [unowned self] engagementRequest, error in
                    self.engagementRequest = engagementRequest
                    // Handle the error as you wish
                    if let reason = error?.reason {
                        self.showError(message: reason)
                    }
                }
            }
            controller.addAction(action)
        }

        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self]
            _ in
            self.cleanUpBlock?()
        }))

        engagementViewController?.present(controller, animated: true, completion: nil)
    }
}

class EngagementViewController: UIViewController {
    class var storyboardInstance: EngagementViewController {
        return UIStoryboard.engagement.instantiateViewController(withIdentifier: "EngagementViewController") as! EngagementViewController
    }

    @IBOutlet weak var tableView: UITableView!
    lazy fileprivate var messages: [String] = [String]()

    @IBOutlet weak var endButton: UIButton!
    var chatType: ChatType = .unidentified
    var queueID: String?

    // MARK: System

    override func viewDidLoad() {
        super.viewDidLoad()

        setupInitialViews()
        setupInitialData()
    }

    // MARK: Initialisation

    fileprivate func setupInitialViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .clear

        view.backgroundColor = UIColor.lightGray
    }

    fileprivate func setupInitialData() {
        Salemove.sharedInstance.pushHandler = { [unowned self]
            push in

            // Do any additional refresh/updates when a user interacts with the notification
            self.tableView.reloadData()
        }
    }

    // MARK: Public Methods

    func update(with message: Message) {
        // Update the message that is coming from the client library and show them to to the user
        messages.append(message.content + " from " + String(describing: message.sender))
        tableView.reloadData()
    }

    func update(with messages: [Message]) {
        // Update the messages that are coming from the client library and show them to to the user
        let parsedMessages = messages.map({ $0.content + " from " + String(describing: $0.sender) })
        self.messages = parsedMessages
        tableView.reloadData()
    }

    @IBAction func composeMessage(_ sender: Any) {
        let inputController = UIAlertController(title: "Message", message: "Please specify", preferredStyle: .alert)
        inputController.addTextField { textfield in
            textfield.clearButtonMode = .whileEditing
            textfield.borderStyle = .roundedRect
        }

        let confirm = UIAlertAction(title: "Send", style: .default) { [unowned self] _ in
            if let message = inputController.textFields?.first?.text, !message.isEmpty {
                let completion: MessageBlock = { [unowned self] _, error in
                    if let error = error {
                        self.showError(message: error.reason)
                    }
                }
                if let queueID = self.queueID, self.chatType == .async  {
                    Salemove.sharedInstance.send(message: message, queueID: queueID, completion: completion)
                } else if self.chatType == .sync {
                    Salemove.sharedInstance.send(message: message, completion: completion)
                }
            }
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        inputController.addAction(confirm)
        inputController.addAction(cancel)

        present(inputController, animated: true, completion: nil)
    }
}

extension EngagementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension EngagementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = message
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}
