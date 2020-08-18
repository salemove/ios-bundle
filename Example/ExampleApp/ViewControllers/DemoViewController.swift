import UIKit
import SalemoveSDK

class DemoViewController: UIViewController {
    @IBOutlet weak var engagementButton: UIButton!
    @IBOutlet weak var configurationButton: UIButton!

    private var statusViewController: EngagementStatusViewController?

    // MARK: System

    override func viewDidLoad() {
        super.viewDidLoad()

        Salemove.sharedInstance.pushHandler = {
            push in

            // Do any additional refresh/updates when a user interacts with the notification
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            requestVisitorCode()
        }
    }

    private func requestVisitorCode() {
        Salemove.sharedInstance.requestVisitorCode { code, error in
            if let visitorCodeError = error {
                self.showError(message: visitorCodeError.reason)
            } else if let code = code {
                self.handleVisitorCode(code: code)
            }
        }
    }

    // MARK: Initialisation

    @IBAction func queueMessage(_ sender: Any) {
        guard let interactor = EngagementStatusViewController.initStoryboardInstance() else {
            debugPrint("could not initialise storyboard for EngagementStatusViewController")
            return
        }
        interactor.chatType = .async
        Salemove.sharedInstance.configure(interactor: interactor)

        statusViewController = interactor
        statusViewController?.cleanUpBlock = { [unowned self] in
            self.statusViewController?.dismiss(animated: true, completion: nil)
            self.statusViewController = nil
        }

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

    @IBAction func beginEngagement(_ sender: Any) {
        guard let operators = OperatorsViewController.storyboardInstance else {
            debugPrint("could not retrieve storyboard for OperatorsViewController")
            return
        }

        let navigationController = UINavigationController(rootViewController: operators)
        present(navigationController, animated: true, completion: nil)
    }

    @IBAction func beginConfiguration(_ sender: Any) {
        let configuration = ConfigurationViewController.storyboardInstance
        present(configuration, animated: true, completion: nil)
    }

    @IBAction func showVisitorCode() {
        requestVisitorCode()
    }
}

extension DemoViewController {
    fileprivate func handleVisitorCode(code: String) {
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

        present(interactor, animated: true) {
            let controller = UIAlertController(title: "Your CoBrowsing Code", message: code, preferredStyle: .alert)

            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            controller.addAction(ok)
            interactor.present(controller, animated: true, completion: nil)
        }
    }

    fileprivate func handleQueues(queues: [Queue], queueMessage: String? = nil, chatType: ChatType = .sync) {
        guard let interactor = EngagementStatusViewController.initStoryboardInstance() else {
            debugPrint("could not initialise storyboard for EngagementStatusViewController")
            return
        }
        interactor.chatType = chatType
        Salemove.sharedInstance.configure(interactor: interactor)

        statusViewController = interactor
        statusViewController?.cleanUpBlock = { [unowned self] in
            self.statusViewController?.dismiss(animated: true, completion: nil)
            self.statusViewController = nil
        }

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

    fileprivate func handleMessage(queueMessage: String) {
        Salemove.sharedInstance.listQueues { [unowned self] queues, error in
            if let queueError = error {
                self.showError(message: queueError.reason)
            } else if let queues = queues {
                self.handleQueues(queues: queues, queueMessage: queueMessage, chatType: .async)
            }
        }
    }
}
