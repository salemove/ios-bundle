import SalemoveSDK
import UIKit

class UpdateVisitorInfoViewController: UIViewController {
    class var storyboardInstance: Self {
        let identifier = "UpdateVisitorInfoViewController"
        guard let controller = UIStoryboard.updateVisitor
                .instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError(
                """
                Unable to cast \(UIStoryboard.updateVisitor
                                    .instantiateViewController(withIdentifier: identifier)) to \(Self.self)
                """
            )
        }
        return controller
    }

    var viewState = ViewState() {
        didSet {
            render()
        }
    }

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nameSwitcher: UISwitch!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailSwitcher: UISwitch!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneSwitcher: UISwitch!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var noteSwitcher: UISwitch!
    @IBOutlet weak var noteUpdateMethodSegments: UISegmentedControl!
    @IBOutlet weak var noteUpdateMethodSwitcher: UISwitch!
    @IBOutlet weak var customAttributesTextField: UITextField!
    @IBOutlet weak var customAttributesSwitcher: UISwitch!
    @IBOutlet weak var customAttUpdateMethodSegments: UISegmentedControl!
    @IBOutlet weak var customAttUpdateMethodSwitcher: UISwitch!
    @IBOutlet weak var externalIdTextField: UITextField!
    @IBOutlet weak var externalIdSwitcher: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        render()
    }

    private func setup() {
        title = "Update Visitor Info"
        setupUpdateButton()
        setupCloseButton()
        setupTextFields()
        setupSwitchers()
        setupSegments()
    }

    private func setupUpdateButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Update",
            style: .plain,
            target: self,
            action: #selector(handleUpdateTap)
        )
    }

    private func setupCloseButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(handleCloseTap)
        )
    }

    private func setupTextFields() {
        [
            nameTextField,
            emailTextField,
            phoneTextField,
            noteTextField,
            customAttributesTextField,
            externalIdTextField
        ].forEach {
            $0?.addTarget(
                self,
                action: #selector(handleTextChange),
                for: .editingChanged
            )
        }
    }

    private func setupSwitchers() {
        [
            nameSwitcher,
            emailSwitcher,
            phoneSwitcher,
            noteSwitcher,
            noteUpdateMethodSwitcher,
            customAttributesSwitcher,
            customAttUpdateMethodSwitcher,
            externalIdSwitcher
        ].forEach {
            $0?.addTarget(self, action: #selector(handleSwitcherToggle), for: .valueChanged)
        }
    }

    private func setupSegments() {
        [
            noteUpdateMethodSegments,
            customAttUpdateMethodSegments
        ].forEach {
            $0?.addTarget(self, action: #selector(handleSegment(segmentedControl:)), for: .valueChanged)
        }
    }

    @objc private func handleTextChange(textField: UITextField) {
        switch textField {
        case nameTextField:
            performUpdate(for: nameSwitcher)
        case emailTextField:
            performUpdate(for: emailSwitcher)
        case phoneTextField:
            performUpdate(for: phoneSwitcher)
        case noteTextField:
            performUpdate(for: noteSwitcher)
        case customAttributesTextField:
            performUpdate(for: customAttributesSwitcher)
        case externalIdTextField:
            performUpdate(for: externalIdSwitcher)
        default:
            print("unhandled textfield", textField)
        }
    }

    // swiftlint:disable cyclomatic_complexity
    private func performUpdate(for switcher: UISwitch) {
        switch switcher {
        case nameSwitcher:
            viewState.handleFieldChange(.name(value: nameTextField.text ?? "", enabled: nameSwitcher.isOn))
        case emailSwitcher:
            viewState.handleFieldChange(.email(value: emailTextField.text ?? "", enabled: emailSwitcher.isOn))
        case phoneSwitcher:
            viewState.handleFieldChange(.phone(value: phoneTextField.text ?? "", enabled: phoneSwitcher.isOn))
        case noteSwitcher:
            viewState.handleFieldChange(.note(value: noteTextField.text ?? "", enabled: noteSwitcher.isOn))
        case noteUpdateMethodSwitcher:
            guard let method = NoteUpdateMethod(rawValue: noteUpdateMethodSegments.selectedSegmentIndex) else {
                return
            }
            viewState.handleFieldChange(.noteUpdateMethod(value: method, enabled: noteUpdateMethodSwitcher.isOn))
        case customAttributesSwitcher:
            viewState.handleFieldChange(
                .customAttributes(
                    value: provideCustomAttributes(raw: customAttributesTextField.text ?? ""),
                    enabled: customAttributesSwitcher.isOn)
            )
        case customAttUpdateMethodSwitcher:
            guard let method = CustomAttributesUpdateMethod(rawValue: customAttUpdateMethodSegments.selectedSegmentIndex) else {
                return
            }
            viewState.handleFieldChange(
                .customAttributesUpdateMethod(value: method, enabled: customAttUpdateMethodSwitcher.isOn)
            )
        case externalIdSwitcher:
            viewState.handleFieldChange(
                .externalID(
                    value: externalIdTextField.text ?? "",
                    enabled: externalIdSwitcher.isOn
                )
            )
        default:
            print("unhandled switcher", switcher)
        }
    }
    // swiftlint:enable cyclomatic_complexity

    private func provideCustomAttributes(raw: String) -> [(String, String)] {
        raw.split(separator: ",")
            .map { $0.split(separator: "=") }
            .compactMap {
                guard let first = $0.first, let last = $0.last else { return nil }
                return (String(first), String(last))
            }
    }

    @objc private func handleUpdateTap() {
        viewState.handleUpdateTap()
    }

    @objc private func handleCloseTap() {
        viewState.handleCloseTap()
    }

    @objc private func handleSwitcherToggle(switcher: UISwitch) {
        performUpdate(for: switcher)
    }

    @objc private func handleSegment(segmentedControl: UISegmentedControl) {
        switch segmentedControl {
        case noteUpdateMethodSegments:
            performUpdate(for: noteUpdateMethodSwitcher)
        case customAttUpdateMethodSegments:
            performUpdate(for: customAttUpdateMethodSwitcher)
        default:
            print("unhandled segmented control", segmentedControl)
        }
    }

    private func render() {
        guard isViewLoaded else {
            return
        }

        for field in viewState.fields {
            switch field {
            case let .name(value, enabled):
                nameTextField.text = value
                nameSwitcher.setOn(enabled, animated: false)
            case let .email(value, enabled):
                emailTextField.text = value
                emailSwitcher.setOn(enabled, animated: false)
            case let .phone(value, enabled):
                phoneTextField.text = value
                phoneSwitcher.setOn(enabled, animated: false)
            case let .note(value, enabled):
                noteTextField.text = value
                noteSwitcher.setOn(enabled, animated: false)
            case let .noteUpdateMethod(value, enabled):
                noteUpdateMethodSegments.selectedSegmentIndex = value.rawValue
                noteUpdateMethodSwitcher.setOn(enabled, animated: false)
            case let .customAttributes(value, enabled):
                customAttributesTextField.text = value.map { "\($0)=\($1)" }.joined(separator: ",")
                customAttributesSwitcher.setOn(enabled, animated: false)
            case let .customAttributesUpdateMethod(value, enabled):
                customAttUpdateMethodSegments.selectedSegmentIndex = value.rawValue
                customAttUpdateMethodSwitcher.setOn(enabled, animated: false)
            case let .externalID(value, enabled):
                externalIdTextField.text = value
                externalIdSwitcher.setOn(enabled, animated: false)
            }
        }
    }
}

extension UpdateVisitorInfoViewController {
    struct ViewState {
        var fields = [Field]()
        var handleCloseTap: () -> Void = {}
        var handleUpdateTap: () -> Void = {}
        var handleFieldChange: (Field) -> Void = { _ in }
    }

    enum Field {
        case name(value: String, enabled: Bool)
        case email(value: String, enabled: Bool)
        case phone(value: String, enabled: Bool)
        case note(value: String, enabled: Bool)
        case noteUpdateMethod(value: NoteUpdateMethod, enabled: Bool)
        case customAttributes(value: [(String, String)], enabled: Bool)
        case customAttributesUpdateMethod(value: CustomAttributesUpdateMethod, enabled: Bool)
        case externalID(value: String, enabled: Bool)
    }

    enum NoteUpdateMethod: Int {
        case replace
        case append
    }

    enum CustomAttributesUpdateMethod: Int {
        case replace
        case merge
    }
}

extension UpdateVisitorInfoViewController.NoteUpdateMethod {
    init(with method: VisitorInfoUpdate.NoteUpdateMethod) {
        switch method {
        case .replace:
            self = .replace
        case .append:
            self = .append
        }
    }
}

extension UpdateVisitorInfoViewController.CustomAttributesUpdateMethod {
    init(with method: VisitorInfoUpdate.CustomAttributesUpdateMethod) {
        switch method {
        case .replace:
            self = .replace
        case .merge:
            self = .merge
        }
    }
}

extension UpdateVisitorInfoViewController.ViewState {
    static func fields(from visitorInfoUpdate: VisitorInfoUpdate) -> [UpdateVisitorInfoViewController.Field] {
        [
            .name(value: visitorInfoUpdate.name ?? "", enabled: visitorInfoUpdate.name != nil),
            .email(value: visitorInfoUpdate.email ?? "", enabled: visitorInfoUpdate.email != nil),
            .phone(value: visitorInfoUpdate.phone ?? "", enabled: visitorInfoUpdate.phone != nil),
            .note(value: visitorInfoUpdate.note ?? "", enabled: visitorInfoUpdate.note != nil),
            .noteUpdateMethod(
                value: visitorInfoUpdate
                    .noteUpdateMethod.map(UpdateVisitorInfoViewController.NoteUpdateMethod.init) ?? .replace,
                enabled: visitorInfoUpdate.noteUpdateMethod != nil
            ),
            .customAttributes(
                value: visitorInfoUpdate.customAttributes?.map { ($0, $1) } ?? [],
                enabled: visitorInfoUpdate.customAttributes != nil
            ),
            .customAttributesUpdateMethod(
                value: visitorInfoUpdate
                    .customAttributesUpdateMethod
                    .map(UpdateVisitorInfoViewController.CustomAttributesUpdateMethod.init) ?? .replace,
                enabled: visitorInfoUpdate.customAttributesUpdateMethod != nil
            ),
            .externalID(value: visitorInfoUpdate.externalID ?? "", enabled: visitorInfoUpdate.externalID != nil)
        ]
    }

    static func updateVisitorInfo(
        _ visitorInfoUpdate: inout VisitorInfoUpdate,
        for field: UpdateVisitorInfoViewController.Field
    ) {
        switch field {
        case let .name(value, enabled):
            visitorInfoUpdate.name = enabled ? value : nil
        case let .email(value, enabled):
            visitorInfoUpdate.email = enabled ? value : nil
        case let .phone(value, enabled):
            visitorInfoUpdate.phone = enabled ? value : nil
        case let .note(value, enabled):
            visitorInfoUpdate.note = enabled ? value : nil
        case let .noteUpdateMethod(value, enabled):
            visitorInfoUpdate.noteUpdateMethod = enabled ? .init(with: value) : nil
        case let .customAttributes(value, enabled):
            visitorInfoUpdate.customAttributes = enabled ? Dictionary(uniqueKeysWithValues: value) : nil
        case let .customAttributesUpdateMethod(value, enabled):
            visitorInfoUpdate.customAttributesUpdateMethod = enabled ? .init(with: value) : nil
        case let .externalID(value, enabled):
            visitorInfoUpdate.externalID = enabled ? value : nil
        }
    }
}
