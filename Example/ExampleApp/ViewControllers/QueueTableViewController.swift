import UIKit
import SalemoveSDK

class QueueTableViewController: UITableViewController, ClickCallback {
    private let QUEUE_VIEW_CELL_ID = "QueueTableViewCell"
    private var queues = [Queue]()
    private var statusViewController: EngagementStatusViewController?
    private var queueUpdatesCallbackId: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        Salemove.sharedInstance.listQueues { [unowned self] queues, error in
            if let queueError = error {
                self.showError(message: queueError.reason)
            } else if let queues = queues {
                self.update(all: queues)
                self.subscribeForQueueUpdates(queues)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.subscribeForQueueUpdates(queues)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.unsubscribeFromUpdates()
    }

    private func subscribeForQueueUpdates(_ queues: [Queue]) {
        let queueIds = queues.map { $0.id }
        queueUpdatesCallbackId = Salemove.sharedInstance.subscribeForUpdates(
            forQueue: queueIds,
            onError: showError(salemoveError:),
            onUpdate: update(newQueue:)
        )
    }

    private func unsubscribeFromUpdates() {
        guard let callbackId = queueUpdatesCallbackId else {
            return
        }
        Salemove.sharedInstance.unsubscribeFromUpdates(queueCallbackId: callbackId,
                                                       onError: showError(salemoveError:))
    }

    private func update(newQueue: Queue) {
        if let itemIndex = queues.firstIndex(where: { newQueue.id == $0.id }) {
            queues[itemIndex] = newQueue
        } else {
            queues.append(newQueue)
        }
        self.tableView.reloadData()
    }

    private func update(all newQueues: [Queue]) {
        self.queues = newQueues
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return queues.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableView = tableView.dequeueReusableCell(withIdentifier: QUEUE_VIEW_CELL_ID, for: indexPath)
        guard let queueView = reusableView as? QueueTableViewCell else {
            fatalError("The dequeued cell is of incalid type.")
        }

        let queueData = queues[indexPath.row]
        queueView.nameView.text = queueData.name
        queueView.statusView.text = queueData.state.status.rawValue.uppercased()
        queueView.mediaView.text = queueData.state.media.map { $0.rawValue }.joined(separator: ", ")
        queueView.queueId = queueData.id
        queueView.delegate = self

        return queueView
    }

    func queueViewCellClicked(clickedItemId: String) {
        requestEngagement(inQueue: clickedItemId)
    }

    private func requestEngagement(inQueue: String) {
        let context = Configuration.sharedInstance.visitorContext
        Salemove.sharedInstance.queueForEngagement(
            queueID: inQueue,
            visitorContext: context,
            completion: handleQueueRequestResult(queueTicket:requestError:))
    }

    private func handleQueueRequestResult(queueTicket: QueueTicket?, requestError: SalemoveError?) {
        if let error = requestError {
            self.showError(message: error.reason)
        } else if let ticket = queueTicket {
            startEngagementStroryboard(with: ticket)
        }
    }

    private func startEngagementStroryboard(with queueTicket: QueueTicket) {
        let engagementController = EngagementStatusViewController.initStoryboardInstance()
        engagementController.chatType = .async
        engagementController.queueTicket = queueTicket
        Salemove.sharedInstance.configure(interactor: engagementController)
        statusViewController = engagementController

        engagementController.cleanUpBlock = { [unowned self] in
            self.statusViewController?.dismiss(animated: true, completion: nil)
            self.statusViewController = nil
        }

        self.present(engagementController, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
