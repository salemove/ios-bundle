import SalemoveSDK
import UIKit

class VisitorInfoView: View {
    var onUpdateButtonTap: (() -> Void)? {
        didSet {
            updateVisitorInfo.addTarget(
                self,
                action: #selector(updateButtonTap),
                for: .touchUpInside
            )
        }
    }

    let visitorInformationLabel = UILabel().make {
        $0.text = "Visitor Information"
        $0.textAlignment = .center
        $0.font = .boldSystemFont(ofSize: 17)
    }
    let nameLabel = UILabel().make {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = ""
    }
    let emailLabel = UILabel().make {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let phoneLabel = UILabel().make {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let noteLabel = UILabel().make {
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    let customAttributesLabel = UILabel().make {
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    let updateVisitorInfo = UIButton(type: .system).make {
        $0.setTitle("Update Info", for: .normal)
    }
    lazy var contentStackView = UIStackView.make(.vertical, spacing: 12, alignment: .center)(
        visitorInformationLabel,
        UIStackView.make(.horizontal, spacing: 8)(nameLabel, emailLabel),
        phoneLabel,
        noteLabel,
        customAttributesLabel,
        updateVisitorInfo
    )
    let errorLabel = UILabel().make {
        $0.textColor = .red
        $0.font = .boldSystemFont(ofSize: 15)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    let scrollView = UIScrollView()

    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        addSubview(errorLabel)
    }

    override func defineLayout() {
        super.defineLayout()

        var constraints = [NSLayoutConstraint]()
        defer { constraints.activate() }
        constraints += scrollView.layoutIn(safeAreaLayoutGuide)
        constraints += contentStackView.layoutInScrollView(
            edges: [.top, .horizontal],
            insets: .init(top: 32, left: 16, bottom: 0, right: 16)
        )
        constraints += errorLabel.layoutInCenter(contentStackView)

        contentStackView.setCustomSpacing(
            16,
            after: visitorInformationLabel
        )
    }

    func handleVisitorInfo(result: Result<Salemove.VisitorInfo, Error>) {
        switch result {
        case .failure(let error):
            errorLabel.text = "\(error)"
        case .success(let visitorInfo):
            update(visitorInfo: visitorInfo)
        }
    }

    func update(visitorInfo: Salemove.VisitorInfo) {
        nameLabel.text = "name: \(visitorInfo.name ?? "<empty name>")"

        emailLabel.text = "email: \(visitorInfo.email ?? "<empty email>")"
        emailLabel.textColor = visitorInfo.email == nil ? .lightGray : .black

        phoneLabel.text = "phone: \(visitorInfo.phone ?? "<empty phone>")"
        phoneLabel.textColor = visitorInfo.phone == nil ? .lightGray : .black

        noteLabel.text = "note: \(visitorInfo.note ?? "<empty note>")"
        noteLabel.textColor = visitorInfo.note == nil ? .lightGray : .black

        customAttributesLabel.text = visitorInfo.customAttributes?
            .map { "\($0) = \($1)" }
            .joined(separator: ", ")
            ?? "<empty custom_attributes>"

        customAttributesLabel.textColor = visitorInfo.customAttributes == nil ? .lightGray : .black
    }

    @objc
    private func updateButtonTap() {
        onUpdateButtonTap?()
    }
}
