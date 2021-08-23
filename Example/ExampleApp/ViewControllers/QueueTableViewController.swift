import UIKit
import SalemoveSDK

class QueueTableViewController: UITableViewController {
    private let QUEUE_VIEW_CELL_ID = "QueueTableViewCell"
    private var queues = [Queue]()
    private var statusViewController: EngagementStatusViewController?
    private var queueUpdatesCallbackId: String?

    private var selectedQueueId: String? {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow else { return nil }

        let queue = queues[selectedIndexPath.row]

        return queue.id
    }

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

        return queueView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let queue = queues[indexPath.row]
        let mediaTypes = queue.state.media

        if shouldShowActionSheet(for: mediaTypes) {
            showEngagementTypeActionSheet(queue: queue)
        } else {
            requestEngagement(inQueue: queue.id)
        }
    }

    private func shouldShowActionSheet(for mediaTypes: [MediaType]) -> Bool {
        return mediaTypes.contains(.audio) || mediaTypes.contains(.video)
    }

    private func showEngagementTypeActionSheet(queue: Queue) {
        let onTextSelected = { [weak self] in
            self?.requestEngagement(inQueue: queue.id)
        }

        let onAudioSelected = { [weak self] in
            self?.requestEngagement(inQueue: queue.id, mediaType: .audio)
        }

        let onOneWayVideoSelected = { [weak self] in
            let options = EngagementOptions(mediaDirection: .oneWay)
            self?.requestEngagement(inQueue: queue.id, mediaType: .video, options: options)
        }

        let onTwoWayVideoSelected = { [weak self] in
            self?.requestEngagement(inQueue: queue.id, mediaType: .video)
        }

        let factory = MediaTypeActionSheetFactory(
            mediaTypes: queue.state.media,
            onTextSelected: onTextSelected,
            onAudioSelected: onAudioSelected,
            onOneWayVideoSelected: onOneWayVideoSelected,
            onTwoWayVideoSelected: onTwoWayVideoSelected
        )

        let actionSheet = factory.actionSheet()
        present(actionSheet, animated: true, completion: nil)
    }

    private func requestEngagement(
        inQueue: String,
        mediaType: MediaType = .text,
        options: EngagementOptions? = nil
    ) {
        let context = Configuration.sharedInstance.visitorContext
        Salemove.sharedInstance.queueForEngagement(
            queueID: inQueue,
            visitorContext: context,
            shouldCloseAllQueues: true,
            mediaType: mediaType,
            options: options,
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
        guard let engagementController = EngagementStatusViewController.initStoryboardInstance() else {
            debugPrint("could not initialise storyboard for EngagementStatusViewController")
            return
        }
        engagementController.chatType = .sync
        engagementController.queueTicket = queueTicket

        if let selectedQueueId = selectedQueueId {
            Configuration.sharedInstance.selectedQueueID = selectedQueueId
        }

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
