import UIKit

final class EngagementTableViewCell: UITableViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        pictureImageView.layer.cornerRadius = 4
        pictureImageView.backgroundColor = .lightGray
        contentLabel.textColor = .darkGray
    }
}
