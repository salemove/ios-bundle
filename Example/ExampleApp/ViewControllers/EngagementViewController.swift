import Foundation
import SalemoveSDK
import MobileCoreServices
import Kingfisher

enum ChatType {
    case unidentified
    case sync
    case async
}

class EngagementNavigationController: UINavigationController {
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
    var attachment: Attachment?

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
        } else if let index = messages.firstIndex(where: { $0.id == message.id })?.advanced(by: 0) {
            messages[index] = message
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
                    Salemove.sharedInstance.send(message: message, attachment: self.attachment, completion: completion)
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
        let cell = tableView.dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath
        ) as? EngagementTableViewCell

        let message = messages[indexPath.row]
        cell?.senderLabel.text = messageSender(using: message)
        cell?.contentLabel.text = message.content

        if message.sender == .operator,
            let stringUrl = self.engagedOperator?.picture?.url,
            let url = URL(string: stringUrl) {
            cell?.pictureImageView.kf.setImage(with: url)
        } else {
            cell?.pictureImageView.image = nil
        }

        if let imageLink = message.attachment?.imageUrl {
            cell?.addAttachmentImage(imageLink)
        }

        if let options = message.attachment?.options {
            cell?.addAttachmentOptionButtons(options: options, for: message.id)
        } else if let selectedOption = message.attachment?.selectedOption {
            cell?.addAttachmentSelectedOption(selectedOption)
        } else {
            downloadFilesIfNeeded(in: message.attachment, using: cell, indexPath: indexPath)
        }

        return cell ?? UITableViewCell()
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

extension EngagementViewController {
    private func downloadFilesIfNeeded(in attachment: Attachment?, using cell: EngagementTableViewCell?, indexPath: IndexPath) {
        guard attachment?.type == .files, let files = attachment?.files else { return }

        for file in files {
            guard let path = file.url?.absoluteString else { return }

            Cache.image(using: path) { [weak self] image in
                if let image = image {
                    let imageView = UIImageView()
                    cell?.addAttachmentImageView(imageView)
                    imageView.image = image
                } else {
                    self?.fetchFile(using: file, cell: cell)
                }
            }
        }
    }

    private func fetchFile(using file: EngagementFile, cell: EngagementTableViewCell?) {

        Salemove.sharedInstance
            .fetchFile(engagementFile: file, progress: nil) { data, error in
                guard error == nil, let data = data, let mimeType = file.contentType else {
                    print("Error download file with url '\(file.url?.absoluteString ?? "Undefined")'.")
                    return
                }

                if mimeType.contains("image") {
                    guard let image = UIImage(data: data.data) else { return }

                    if let key = file.url?.absoluteString {
                        Cache.save(image, original: data.data, usingKey: key)
                    }
                    DispatchQueue.main.async { [weak self] in
                        let imageView = UIImageView()
                        cell?.addAttachmentImageView(imageView)
                        imageView.image = image
                        self?.tableView.reloadSections(IndexSet([0]), with: .none)
                    }
                }
            }
    }
}
