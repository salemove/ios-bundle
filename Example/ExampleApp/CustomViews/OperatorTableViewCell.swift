import UIKit

class OperatorTableViewCell: UITableViewCell {
    @IBOutlet weak var imageOperator: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelAvailableMedia: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageOperator.contentMode = .scaleAspectFill
        imageOperator.layer.cornerRadius = 4
    }
}
