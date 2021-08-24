import SalemoveSDK
import UIKit

class VisitorInfoViewController: ViewController<VisitorInfoView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.onUpdateButtonTap = { [weak contentView, weak self] in
            Salemove.sharedInstance.fetchVisitorInfo { [weak contentView, weak self] result in
                DispatchQueue.main.async { [weak contentView, weak self] in
                    switch result {
                    case let .success(visitorInfo):
                        self?.showUpdateVisitorInfo(visitorInfo)
                    case .failure:
                        contentView?.handleVisitorInfo(result: result)
                    }
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshVisitorInfo()
    }

    func refreshVisitorInfo() {
        Salemove.sharedInstance.fetchVisitorInfo { [weak contentView] result in
            DispatchQueue.main.async { [weak contentView] in
                contentView?.handleVisitorInfo(result: result)
            }
        }
    }

    func showUpdateVisitorInfo(_ info: Salemove.VisitorInfo) {
        var visitorInfoUpdate = VisitorInfoUpdate(with: info)
        let controller = UpdateVisitorInfoViewController.storyboardInstance
        typealias ViewState = UpdateVisitorInfoViewController.ViewState
        let viewState = ViewState(
            fields: ViewState.fields(from: visitorInfoUpdate),
            handleCloseTap: { [weak controller] in controller?.parent?.dismiss(animated: true) },
            handleUpdateTap: { [weak controller, weak self] in
                guard let controller = controller else { return }
                self?.handleUpdateTap(controller: controller, visitorInfoUpdate: visitorInfoUpdate)
            },
            handleFieldChange: { field in
                ViewState.updateVisitorInfo(&visitorInfoUpdate, for: field)
            }
        )
        controller.viewState = viewState
        present(UINavigationController(rootViewController: controller), animated: true)
    }

    func handleUpdateTap(controller: UpdateVisitorInfoViewController, visitorInfoUpdate: VisitorInfoUpdate) {
        Salemove.sharedInstance.updateVisitorInfo(visitorInfoUpdate) { [weak controller, weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    guard let controller = controller else { return }
                    controller.parent?.dismiss(animated: true) {
                        self?.refreshVisitorInfo()
                    }

                case let .failure(error):
                    self?.showError(error)
                }
            }
        }
    }

    func showError(_ error: Error) {
        let message: String

        if let error = error as? SalemoveError {
            message = "\(error.reason)"
        } else {
            message = "\(error)"
        }

        let action = UIAlertAction(title: "OK", style: .default)
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        controller.addAction(action)
        present(controller, animated: true)
    }
}
