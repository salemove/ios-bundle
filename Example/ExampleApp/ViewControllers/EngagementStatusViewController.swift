import UIKit
import SalemoveSDK
import MobileCoreServices
import Kingfisher

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
    private var imagePickerController = UIImagePickerController()

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

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.onOptionSelected),
            name: NSNotification.Name(rawValue: "optionSelected"),
            object: nil
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkActiveEngagement()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if self.isBeingDismissed {
            cancelEngagement()
        }
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

    @objc func onOptionSelected(_ notification: NSNotification) {
        if let optionValue = notification.userInfo?["optionValue"] as? String {
            sendSingleChoiceOptionResponse(option: optionValue)
        }
    }

    func sendSingleChoiceOptionResponse(option: String) {
        let completion: (Result<Message, Error>) -> Void = { [unowned self] result in
            switch result {
            case let .success(message):
                self.engagementViewController?.update(with: message)
            case let .failure(error):
                if let error = error as? SalemoveError {
                    self.showError(message: error.reason)
                } else {
                    self.showError(message: "\(error)")
                }
            }
        }

        Salemove.sharedInstance.send(
            selectedOptionValue: option,
            completion: completion
        )
    }

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

    @IBAction func attachImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = false
            imagePickerController.mediaTypes = [kUTTypeImage].map { $0 as String }

            present(imagePickerController, animated: true, completion: nil)
        } else {
            showError(message: "Error getting the photo library")
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

extension EngagementStatusViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        print(info)
        imagePickerController.dismiss(animated: true, completion: nil)

        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String
        if mediaType == kUTTypeImage as String, let image = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let progress: EngagementFileProgressBlock = { progress in
                print("Upload file progress: \(progress.fractionCompleted)")
            }

            let completion: EngagementFileCompletionBlock = { [weak self] file, _ in
                guard let self = self else { return }

                guard let file = file else {
                    self.showError(message: "Error uploading the file.")
                    return
                }

                let engagementFile = EngagementFile(id: file.id)
                self.engagementViewController?.attachment = Attachment(file: engagementFile)
                self.showFileUploadSuccessfulAlert()
            }

            Salemove.sharedInstance.uploadFileToEngagement(EngagementFile(url: image), progress: progress, completion: completion)
        }
    }

    private func showFileUploadSuccessfulAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "File uploaded successfully. To send the file, please compose a message.",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

            let completion: SuccessBlock = { _, error in
                if let reason = error?.reason {
                    print(reason)
                }
            }

            let context = Configuration.sharedInstance.visitorContext
            answer(context, true, completion)
        }
    }

    var onEngagementTransfer: EngagementTransferBlock {
        return { _ in
            print("Transfer completed")
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
