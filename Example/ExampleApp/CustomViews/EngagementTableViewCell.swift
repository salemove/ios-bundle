import UIKit
import SalemoveSDK

final class EngagementTableViewCell: UITableViewCell {
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet private weak var attachmentContainerStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()

        pictureImageView.layer.cornerRadius = 4
        pictureImageView.backgroundColor = .lightGray
        contentLabel.textColor = .darkGray
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        attachmentContainerStackView.subviews.forEach { $0.removeFromSuperview() }
    }

    func addAttachmentSelectedOption(_ selectedOption: String) {
        attachmentContainerStackView.alignment = .leading

        let label = UILabel()
        label.text = selectedOption
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray

        attachmentContainerStackView.addArrangedSubview(label)
    }

    func addAttachmentOptionButtons(options: [SingleChoiceOption], for messageId: String) {
        attachmentContainerStackView.alignment = .leading
        guard let attachmentContainerStackView = attachmentContainerStackView else { return }
        for option in options {
            guard let optionValue = option.value, let optionText = option.text else { return }
            let button = OptionButton(
                optionText,
                optionValue: optionValue,
                messageId: messageId
            )

            button.addTarget(
                self,
                action: #selector(self.optionPressed(sender:)),
                for: .touchUpInside
            )

            attachmentContainerStackView.addArrangedSubview(button)
        }
    }

    @objc func optionPressed(sender: OptionButton!) {
        NotificationCenter.default.post(
            name: NSNotification.Name(rawValue: "optionSelected"),
            object: sender,
            userInfo: [
                "optionValue": sender.optionValue,
                "messageId": sender.messageId
            ]
        )
    }

    func addAttachmentImageView(_ imageView: UIImageView) {
        guard let attachmentContainerStackView = attachmentContainerStackView else { return }

        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(color: UIColor.gray)
        imageView.clipsToBounds = true
        attachmentContainerStackView.addArrangedSubview(imageView)

        let leftMarginConstraint = NSLayoutConstraint(
            item: attachmentContainerStackView,
            attribute: .leftMargin,
            relatedBy: .equal,
            toItem: imageView,
            attribute: .leftMargin,
            multiplier: 1,
            constant: 0
        )

        let rightMarginConstraint = NSLayoutConstraint(
            item: attachmentContainerStackView,
            attribute: .rightMargin,
            relatedBy: .equal,
            toItem: imageView,
            attribute: .rightMargin,
            multiplier: 1,
            constant: 0
        )

        attachmentContainerStackView.addConstraints([leftMarginConstraint, rightMarginConstraint])

        let heightConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .height,
            multiplier: 1,
            constant: 300
        )

        imageView.addConstraint(heightConstraint)
    }
}
