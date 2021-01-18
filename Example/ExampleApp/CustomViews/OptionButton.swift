import UIKit

class OptionButton: UIButton {
    var title: String = ""
    var optionValue: String = ""
    var messageId: String = ""

    convenience init(
        _ title: String,
        optionValue: String,
        messageId: String
    ) {
        self.init()
        self.title = title
        self.optionValue = optionValue
        self.messageId = messageId
        self.setTitle(title, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.showsTouchWhenHighlighted = true
        self.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        self.layer.cornerRadius = 4
    }
}
