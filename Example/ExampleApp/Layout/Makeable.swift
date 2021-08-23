import UIKit

protocol Makeable {}

extension Makeable where Self: UIView {
    func make(_ configuration: (Self) -> Void) -> Self {
        configuration(self)
        return self
    }

    func makeView() -> Self {
        makeView { _ in }
    }

    func makeView(_ configuration: (Self) -> Void) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        configuration(self)

        return self
    }
}

extension UIView: Makeable {}
