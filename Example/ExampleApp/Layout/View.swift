import UIKit

class View: UIView {
    private var needsDefineLayout = true

    required init() {
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {
        if needsDefineLayout {
            needsDefineLayout = false
            defineLayout()
        }
        super.updateConstraints()
    }

    func setup() {}
    func defineLayout() {}
}
