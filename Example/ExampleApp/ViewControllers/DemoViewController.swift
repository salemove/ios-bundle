import UIKit
import SalemoveSDK

class DemoViewController: UIViewController {
    @IBOutlet weak var configurationButton: UIButton!

    private var statusViewController: EngagementStatusViewController?

    // MARK: System

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeSDK()
        Salemove.sharedInstance.pushNotifications.handler = { [weak self] push in
            self?.handlePushNotification(push)
        }
    }

    private func initializeSDK() {
        do {
            try Configuration.sharedInstance.initialize()
        } catch {
            showInitializationError()
        }
    }

    private func showInitializationError() {
        let alert = UIAlertController(
            title: "Error",
            message: "The SDK failed to initialize. Please make sure you have input correct values in Configuration.plist.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            requestVisitorCode()
        }
    }
}

extension DemoViewController {
    private func configureInteractor(withChatType chatType: ChatType) {
        var factory = InteractorFactory()
        factory.cleanUpBlock = { [weak self] in
            self?.statusViewController?.dismiss(animated: true, completion: nil)
            self?.statusViewController = nil
        }

        guard let interactor = factory.interactor(withChatType: chatType) else { return }

        Salemove.sharedInstance.configure(interactor: interactor)
        statusViewController = interactor
    }

    @IBAction func beginConfiguration(_ sender: Any) {
        guard let configuration = ConfigurationViewController.storyboardInstance else { return }

        present(configuration, animated: true, completion: nil)
    }

    @IBAction func beginOperators(_ sender: Any) {
        guard let operators = OperatorsViewController.storyboardInstance else {
            debugPrint("could not retrieve storyboard for OperatorsViewController")
            return
        }

        let navigationController = UINavigationController(rootViewController: operators)
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - Queues

extension DemoViewController {
    @IBAction func queueMessage(_ sender: Any) {
        configureInteractor(withChatType: .async)

        let inputController = UIAlertController(title: "Message", message: "Please specify", preferredStyle: .alert)
        inputController.addTextField { textfield in
            textfield.clearButtonMode = .whileEditing
            textfield.borderStyle = .roundedRect
        }

        let confirm = UIAlertAction(title: "Send", style: .default) { [unowned self] _ in
            if let message = inputController.textFields?.first?.text, !message.isEmpty {
                self.handleMessage(queueMessage: message)
            }
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        inputController.addAction(confirm)
        inputController.addAction(cancel)

        present(inputController, animated: true, completion: nil)
    }

    fileprivate func handleMessage(queueMessage: String) {
        Salemove.sharedInstance.listQueues { [unowned self] queues, error in
            if let queueError = error {
                self.showError(message: queueError.reason)
            } else if let queues = queues {
                self.handleQueues(queues: queues, queueMessage: queueMessage, chatType: .async)
            }
        }
    }

    fileprivate func handleQueues(queues: [Queue], queueMessage: String? = nil, chatType: ChatType = .sync) {
        configureInteractor(withChatType: chatType)

        selectQueue(queues: queues) { queue in
            Configuration.sharedInstance.selectedQueueID = queue.id

            if let queueMessage = queueMessage {
                Salemove.sharedInstance.send(message: queueMessage, queueID: queue.id) { [unowned self] _, error in
                    if let error = error {
                        self.showError(message: error.reason)
                    } else {
                        guard let controller = self.statusViewController else {
                            return
                        }

                        self.present(controller, animated: true)
                    }
                }
            } else {
                let context = Configuration.sharedInstance.visitorContext
                Salemove.sharedInstance.queueForEngagement(queueID: queue.id,
                                                           visitorContext: context) { [unowned self] queueTicket, error in
                    if let queueError = error {
                        self.showError(message: queueError.reason)
                    } else if let ticket = queueTicket {
                        guard let controller = self.statusViewController else {
                            return
                        }

                        controller.queueTicket = ticket
                        self.present(controller, animated: true)
                    }
                }
            }
        }
    }

    fileprivate func selectQueue(queues: [Queue], completion: @escaping (Queue) -> Void) {
        let controller = UIAlertController(title: "Queues", message: "Please select", preferredStyle: .actionSheet)

        for queue in queues {
            let action = UIAlertAction(title: queue.name, style: .default) { _ in
                completion(queue)
            }
            controller.addAction(action)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        controller.addAction(cancel)
        present(controller, animated: true, completion: nil)
    }
}

// MARK: - Visitor code

extension DemoViewController {
    @IBAction func showVisitorCode(_ sender: Any) {
        requestVisitorCode()
    }

    private func requestVisitorCode() {
        Salemove.sharedInstance.requestVisitorCode { [weak self] code, error in
            if let visitorCodeError = error {
                self?.showError(message: visitorCodeError.reason)
            } else if let code = code {
                self?.showVisitorCodeAlert(using: code)
            }
        }
    }

    fileprivate func showVisitorCodeAlert(using code: String) {
        configureInteractor(withChatType: .async)

        guard let statusViewController = statusViewController else { return }

        present(statusViewController, animated: true) {
            let controller = UIAlertController(title: "Your CoBrowsing Code", message: code, preferredStyle: .alert)

            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            controller.addAction(ok)
            statusViewController.present(controller, animated: true, completion: nil)
        }
    }
}

// MARK: - Push Notifications

extension DemoViewController {
    private func handlePushNotification(_ push: Push) {
        switch push.type {
        case .chatMessage:
            openEngagementFromPushNotification(using: push.actionIdentifier)
        default: return
        }
    }

    private func openEngagementFromPushNotification(using actionIdentifier: String) {
        Salemove.sharedInstance.waitForActiveEngagement { [weak self] _, error in
            // Engagement screen should be created here only when opening a push notification
            // while the app has been force closed, and thus there is no interactor handling events,
            // but the previous engagement hasn't been closed from the operator side. Otherwise,
            // we should do nothing about it.
            guard Salemove.sharedInstance.currentInteractor == nil, error == nil else { return }

            self?.presentEngagementScreen()
        }
    }

    private func presentEngagementScreen() {
        configureInteractor(withChatType: .sync)

        guard let statusViewController = statusViewController else { return }

        self.present(statusViewController, animated: true)
    }
}

// MARK: - Visitor Info
extension DemoViewController {
    @IBAction func visitorInfoButtonTouchUpInside(_ sender: Any) {
        present(
            VisitorInfoViewController(),
            animated: true
        )
    }
}

