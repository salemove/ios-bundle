import Foundation
import SalemoveSDK

enum ChatType {
    case unidentified
    case sync
    case async
}

class EngagementNavigationController: UINavigationController {
}

class EngagementStatusViewController: UIViewController {
    class func initStoryboardInstance() -> EngagementStatusViewController? {
        if let controller = UIStoryboard.engagement.instantiateViewController(
            withIdentifier: "EngagementStatusViewController"
            ) as? EngagementStatusViewController {
            return controller
        } else {
            return nil
        }
    }

    var engagementNavigationController: EngagementNavigationController?
    var engagementViewController: EngagementViewController?
    var mediaViewController: MediaViewController?

    @IBOutlet weak var audioButton: UIButton!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var localScreenButton: UIButton!
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

        checkActiveEngagement()
    }

    // MARK: Initialisation

    fileprivate func setUpInitialViews() {
        mediaView.isHidden = true
        localScreenButton.isHidden = true
    }

    fileprivate func setUpChildControllers() {
        engagementNavigationController = childInstance(class: EngagementNavigationController.self)
        engagementViewController = engagementNavigationController?.childInstance(class: EngagementViewController.self)
        mediaViewController = childInstance(class: MediaViewController.self)
    }

    // MARK: Public Methods
    @IBAction func requestAudio(_ sender: Any) {
        guard let offer = try? MediaUpgradeOffer(type: MediaType.audio, direction: MediaDirection.twoWay) else {
            print("Failed to create media upgrade offer")
            return
        }
        Salemove.sharedInstance.requestMediaUpgrade(offer: offer) { [unowned self] success, _ in
            if success {
                self.audioButton.setTitleColor(UIColor.green, for: .normal)
            }
        }
    }

    @IBAction func requestVideo(_ sender: Any) {
        guard let offer = try? MediaUpgradeOffer(type: MediaType.video, direction: MediaDirection.twoWay) else {
            print("Failed to create media upgrade offer")
            return
        }
        Salemove.sharedInstance.requestMediaUpgrade(offer: offer) { [unowned self] success, _ in
            if success {
                self.videoButton.setTitleColor(UIColor.green, for: .normal)
            }
        }
    }

    @IBAction func toggleAudio(_ sender: Any) {
        self.mediaViewController?.toggleAudio()
    }

    @IBAction func toggleVideo(_ sender: Any) {
        self.mediaViewController?.toggleVideo()
    }

    @IBAction func cancelScreenRecording(_ sender: Any) {
        visitorScreenSharing?.localScreen?.stopSharing()
        localScreenButton.isHidden = true
        visitorScreenSharing = nil
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

    fileprivate func checkActiveEngagement() {
        engagementViewController?.chatType = chatType
    }

    fileprivate func cleanUp() {
        mediaViewController?.cleanUp()
        cleanUpBlock?()
    }
}

extension EngagementStatusViewController: Interactable {
    var onScreenSharingOffer: ScreenshareOfferBlock {
        return { answer in
            answer(true)
        }
    }

    var onMediaUpgradeOffer: MediaUgradeOfferBlock {
        return { _, answer in
            answer(true, nil)
        }
    }

    var onEngagementRequest: RequestOfferBlock {
        return { answer in

            let completion: SuccessBlock = { success, error in
                if let reason = error?.reason {
                    print(reason)
                }
            }

            let context = Configuration.sharedInstance.visitorContext
            answer(context, true, completion)
        }
    }

    var onOperatorTypingStatusUpdate: OperatorTypingStatusUpdate {
        return { [unowned self] status in
             self.engagementViewController?.updateOperatorTypingStatus(status: status)
        }
    }

    var onVisitorScreenSharingStateChange: VisitorScreenSharingStateChange {
        return { [unowned self] state, error in
            if let error = error {
                self.showError(message: error.reason)
            } else {
                DispatchQueue.main.async {
                    self.visitorScreenSharing = state
                    self.localScreenButton.setTitleColor(UIColor.red, for: .normal)
                    self.localScreenButton.isHidden = false
                }
            }
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
            DispatchQueue.main.async {
                self.engagementViewController?.update(with: messages)
            }
        }
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

    func handleOperators(operators: [Operator]) {
        // Remove any spinners or activity indicators and proceed with the flow of selecting an Operator

        let controller = UIAlertController(title: "Operators", message: "Please select", preferredStyle: .actionSheet)

        for availableOperator in operators {
            let action = UIAlertAction(title: availableOperator.name, style: .default) { _ in

                let context = Configuration.sharedInstance.visitorContext

                // Select an operator and pass it to the client library
                Salemove.sharedInstance.requestEngagementWith(selectedOperator: availableOperator,
                                                              visitorContext: context) { [unowned self] engagementRequest, error in
                    self.engagementRequest = engagementRequest
                    // Handle the error as you wish
                    if let reason = error?.reason {
                        self.showError(message: reason)
                    } else if let timeout = self.engagementRequest?.timeout {
                        print("Processing engagement request within \(timeout) seconds")
                    }
                }
            }
            controller.addAction(action)
        }

        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [unowned self] _ in
            self.cleanUpBlock?()
        }))

        engagementViewController?.present(controller, animated: true, completion: nil)
    }
}

extension Selector {
    static let textFieldDidChange =
        #selector(EngagementViewController.textFieldDidChange(_:))
}

class EngagementViewController: UIViewController {
    class var storyboardInstance: EngagementViewController? {
        if let controller = UIStoryboard.engagement.instantiateViewController(
            withIdentifier: "EngagementViewController"
            ) as? EngagementViewController {
            return controller
        } else {
            return nil
        }
    }

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    lazy fileprivate var messages: [Message] = [Message]()

    @IBOutlet weak var endButton: UIButton!
    var chatType: ChatType = .unidentified
    var engagedOperator: Operator?

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

        statusLabel.text = ""
    }

    fileprivate func setupInitialData() {

    }

    // MARK: Public Methods

    func update(with message: Message) {
        Salemove.sharedInstance.requestEngagedOperator { [weak self] engagedOperator, _ in
            self?.engagedOperator = engagedOperator?.first
        }

        // Update the message that is coming from the client library and show them to to the user
        let isDuplicate = !messages.filter({ $0.id == message.id }).isEmpty

        if !isDuplicate {
            messages.append(message)
        }
        tableView.reloadData()
    }

    func update(with messages: [Message]) {
        // Update the messages that are coming from the client library and show them to to the user
        self.messages = messages
        tableView.reloadData()
    }

    func updateOperatorTypingStatus(status: OperatorTypingStatus) {
        if status.isTyping {
            statusLabel.text = "Operator Typing"
        } else {
            statusLabel.text = ""
        }
    }

    @IBAction func composeMessage(_ sender: Any) {
        let inputController = UIAlertController(title: "Message", message: "Please specify", preferredStyle: .alert)
        inputController.addTextField { [unowned self] textfield in
            textfield.clearButtonMode = .whileEditing
            textfield.borderStyle = .roundedRect
            textfield.addTarget(self, action: .textFieldDidChange, for: UIControl.Event.editingChanged)
            textfield.delegate = self
        }

        let confirm = UIAlertAction(title: "Send", style: .default) { _ in
            if let message = inputController.textFields?.first?.text, !message.isEmpty {
                let completion: MessageBlock = { [unowned self] _, error in
                    if let error = error {
                        self.showError(message: error.reason)
                    }
                }
                if self.chatType == .async {
                    Salemove.sharedInstance.send(message: message, queueID: Configuration.sharedInstance.selectedQueueID, completion: completion)
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

extension EngagementViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let message = textField.text else {
            return
        }

        let completion: SuccessBlock = { [unowned self] _, error in
            if let error = error {
                self.showError(message: error.reason)
            }
        }

        if chatType != .async {
            Salemove.sharedInstance.sendMessagePreview(message: message, completion: completion)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let completion: SuccessBlock = { [unowned self] _, error in
            if let error = error {
                self.showError(message: error.reason)
            }
        }

        if chatType != .async {
            Salemove.sharedInstance.sendMessagePreview(message: "", completion: completion)
        }
    }
}

extension EngagementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EngagementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = EngagementTableViewCell.identifier
        let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        guard let cell = dequeuedCell as? EngagementTableViewCell else { return UITableViewCell() }

        let message = messages[indexPath.row]
        cell.senderLabel.text = messageSender(using: message)
        cell.contentLabel.text = message.content

        if message.sender == .operator,
            let stringUrl = self.engagedOperator?.picture?.url,
            let url = URL(string: stringUrl) {
            cell.pictureImageView.setImage(using: url)
        } else {
            cell.pictureImageView.image = nil
        }

        return cell
    }

    private func messageSender(using message: Message) -> String {
        var sender = String(describing: message.sender)

        if message.sender == .operator, let operatorName = self.engagedOperator?.name {
            sender = operatorName
        } else if message.sender == .visitor {
            sender = "Me"
        }

        return sender.capitalized
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
