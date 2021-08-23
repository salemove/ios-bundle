import UIKit

extension UIView {
    struct Edge: OptionSet {
        let rawValue: Int

        init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let leading = Edge(rawValue: 1 << 0)
        static let trailing = Edge(rawValue: 1 << 1)
        static let top = Edge(rawValue: 1 << 2)
        static let bottom = Edge(rawValue: 1 << 3)

        static let greaterThanLeading = Edge(rawValue: 1 << 4)
        static let lessThanTrailing = Edge(rawValue: 1 << 5)
        static let greaterThanTop = Edge(rawValue: 1 << 6)
        static let lessThanBottom = Edge(rawValue: 1 << 7)

        static let horizontal: Edge = [.leading, .trailing]
        static let vertical: Edge = [.top, .bottom]
        static let all: Edge = [.horizontal, .vertical]
    }

    struct Dimension: OptionSet {
        let rawValue: Int

        init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let width = Dimension(rawValue: 1 << 0)
        static let height = Dimension(rawValue: 1 << 1)

        static let all: Dimension = [.width, .height]
    }

    struct Align: OptionSet {
        let rawValue: Int

        init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let horizontal = Align(rawValue: 1 << 0)
        static let vertical = Align(rawValue: 1 << 1)
        static let center: Align = [.horizontal, .vertical]
    }

    /// Create constraints to layout the current view in the center of superview. Created constraints rely on
    ///  `centerAnchor` of superview and the result array will not contain any trailing/leading/width/height constraints.
    /// - Returns: Array of constraints or empty array, if the current view doesn't have superview.
    func layoutInSuperviewCenter(
        edges: Align = .center,
        xOffset: CGFloat = 0.0,
        yOffset: CGFloat = 0.0
    ) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            assertionFailure("Can't layout view due to it is not added to any view hierarcy.")
            return []
        }

        return layoutInCenter(
            superview,
            edges: edges,
            xOffset: xOffset,
            yOffset: yOffset
        )
    }

    /// Create constraints to layout the current view in the center of passed guide (ex.: superview,
    ///  safeAreaLayoutGuide, etc.). Created constraints rely only on `centerXAnchor` and `centerYAnchor` anchors.
    /// - Returns: Array of constraints.
    func layoutInCenter(
        _ guide: Layoutable,
        edges: Align = .center,
        xOffset: CGFloat = 0.0,
        yOffset: CGFloat = 0.0
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var constraints = [NSLayoutConstraint]()

        if edges.contains(.horizontal) {
            constraints += centerXAnchor.constraint(equalTo: guide.centerXAnchor, constant: xOffset)
        }

        if edges.contains(.vertical) {
            constraints += centerYAnchor.constraint(equalTo: guide.centerYAnchor, constant: yOffset)
        }

        return constraints
    }

    /// Create constraints to layout the current view in the superview and rely on passed parameters `edges` and
    ///  `insets`. Created constraints rely on `topAnchor`, `bottomAnchor`, `leadingAnchor`, `trailingAnchor` anchors
    ///  and doesn't rely on `widhtAnchor`, `heightAnchor`.
    /// - Returns: Array of constraints or empty array, if the current view doesn't have superview.
    func layoutInSuperview(
        edges: Edge = .all,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {

        guard let superview = superview else {
            assertionFailure("Can't layout view due to it is not added to any view hierarcy.")
            return [NSLayoutConstraint]()
        }

        return layoutIn(
            superview,
            edges: edges,
            insets: insets,
            priority: priority
        )
    }

    /// Create constraints to layout the current view in the scroll view `edges` and  `insets`. Created constraints rely
    ///  on `topAnchor`, `leadingAnchor`, `trailingAnchor` anchors, and don't rely on `bottomAnchor` (since it is
    ///  layouting inside scroll view), `widhtAnchor`, `heightAnchor`.
    /// - Returns: Array of constraints or empty array, if the current view doesn't have superview.
    func layoutInScrollView(
        edges: Edge = .all,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {

        guard superview is UIScrollView else {
            return layoutInSuperview(
                edges: edges,
                insets: insets,
                priority: priority
            )
        }

        var constraints = layoutInSuperview(
            edges: edges.symmetricDifference(.trailing),
            insets: insets,
            priority: priority
        )

        guard let parentOfScrollView = superview?.superview else {
            return constraints
        }

        constraints += layoutIn(
            parentOfScrollView,
            edges: .trailing,
            insets: insets
        )

        return constraints
    }

    // swiftlint:disable function_body_length
    func layoutIn(
        _ guide: Layoutable,
        edges: Edge = .all,
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        let directionalInsets = NSDirectionalEdgeInsets(
            top: insets.top,
            leading: insets.left,
            bottom: -insets.bottom,
            trailing: -insets.right
        )

        let (leading, trailing, top, bottom) = (
            directionalInsets.leading,
            directionalInsets.trailing,
            directionalInsets.top,
            directionalInsets.bottom
        )

        var constraints = [NSLayoutConstraint]()

        if edges.contains(.leading) || edges.contains(.horizontal) {
            constraints.append(
                leadingAnchor.constraint(
                    equalTo: guide.leadingAnchor,
                    constant: leading
                )
                .priority(priority)
                .identifier(.leading)
            )
        }

        if edges.contains(.top) || edges.contains(.vertical) {
            constraints.append(
                topAnchor.constraint(
                    equalTo: guide.topAnchor,
                    constant: top
                )
                .priority(priority)
                .identifier(.top)
            )
        }

        if edges.contains(.trailing) || edges.contains(.horizontal) {
            constraints.append(
                trailingAnchor.constraint(
                    equalTo: guide.trailingAnchor,
                    constant: trailing
                )
                .priority(priority)
                .identifier(.trailing)
            )
        }

        if edges.contains(.bottom) || edges.contains(.vertical) {
            constraints.append(
                bottomAnchor.constraint(
                    equalTo: guide.bottomAnchor,
                    constant: bottom
                )
                .priority(priority)
                .identifier(.bottom)
            )
        }

        if edges.contains(.greaterThanTop) {
            constraints.append(
                topAnchor.constraint(greaterThanOrEqualTo: guide.topAnchor)
                    .priority(priority)
                    .identifier(.greaterThanTop)
            )
        }

        if edges.contains(.lessThanBottom) {
            constraints.append(
                bottomAnchor.constraint(lessThanOrEqualTo: guide.bottomAnchor)
                    .priority(priority)
                    .identifier(.lessThanBottom)
            )
        }

        return constraints
    }
    // swiftlint:enable function_body_length

    /// Create constraints to match the current view sizes with the passed value. Created constraints rely on
    /// `widthAnchor` and `heightAnchor`.
    /// - Returns: Array of constraints or empty array.
    func match(
        _ dimension: Dimension = .all,
        value: CGFloat,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()

        if dimension.contains(.height) {
            constraints += heightAnchor.constraint(equalToConstant: value)
                .priority(priority)
                .identifier(.height)
        }

        if dimension.contains(.width) {
            constraints += widthAnchor.constraint(equalToConstant: value)
                .priority(priority)
                .identifier(.width)
        }

        return constraints
    }
}

extension Array where Element == NSLayoutConstraint {
    func activate() {
        NSLayoutConstraint.activate(self)
    }

    func deactivate() {
        NSLayoutConstraint.deactivate(self)
    }

    // swiftlint:disable operator_whitespace
    static func +=(
        destination: inout [NSLayoutConstraint],
        newConstraint: NSLayoutConstraint
    ) {
        // swiftlint:enable operator_whitespace
        destination.append(newConstraint)
    }

    func constraints(with id: NSLayoutConstraint.Identifier) -> [NSLayoutConstraint] {
        filter { $0.identifier == id.rawValue }
    }
}

extension NSLayoutConstraint {
    enum Identifier: String {
        case leading, top, trailing, bottom, width, height, greaterThanTop, lessThanBottom
    }

    func priority(_ newValue: UILayoutPriority) -> Self {
        priority = newValue
        return self
    }

    func identifier(_ id: Identifier) -> Self {
        identifier = id.rawValue
        return self
    }
}
