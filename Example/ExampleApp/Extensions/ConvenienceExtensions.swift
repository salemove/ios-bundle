import UIKit
import SalemoveSDK

extension UIViewController {
    func childInstance<T>(class: T.Type) -> T? {
        return children.filter({ $0 is T }).first as? T
    }

    func showError(salemoveError: SalemoveError) {
        showError(message: salemoveError.reason)
    }

    func showError(message: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
        }
    }
}
