import UIKit

class QueueTableViewCell: UITableViewCell {
    @IBOutlet weak var nameView: UILabel!
    @IBOutlet weak var mediaView: UILabel!
    @IBOutlet weak var statusView: UILabel!

    var queueId: String?
    weak var delegate: ClickCallback?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        if let queueId = queueId, let delegate = delegate, selected {
            delegate.queueViewCellClicked(clickedItemId: queueId)
        }
    }

    @objc func presentWebBrowser(sender: UIButton) {
        if let queueId = queueId, let delegate = delegate {
            delegate.queueViewCellClicked(clickedItemId: queueId)
        }
    }
}

protocol ClickCallback: AnyObject {
    func queueViewCellClicked(clickedItemId: String)
}
