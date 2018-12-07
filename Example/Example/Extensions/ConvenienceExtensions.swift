import UIKit

extension UIViewController {
    func childInstance<T>(class: T.Type) -> T? {
        return childViewControllers.filter({$0 is T}).first as? T
    }

    func showError(message: String) {
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
}
