import SalemoveSDK

struct MediaTypeActionSheetFactory {
    let mediaTypes: [MediaType]
    let onTextSelected: () -> Void?
    let onAudioSelected: () -> Void?
    let onOneWayVideoSelected: () -> Void?
    let onTwoWayVideoSelected: () -> Void?

    func actionSheet() -> UIAlertController {
        let alertController = self.alertController()

        let textAction = action(withTitle: "Text", closure: onTextSelected)
        alertController.addAction(textAction)

        if mediaTypes.contains(.audio) {
            let audioAction = action(withTitle: "Audio", closure: onAudioSelected)
            alertController.addAction(audioAction)
        }

        if mediaTypes.contains(.video) {
            let oneWayVideoAction = action(withTitle: "One-way Video", closure: onOneWayVideoSelected)
            alertController.addAction(oneWayVideoAction)

            let twoWayVideoAction = action(withTitle: "Two-way Video", closure: onTwoWayVideoSelected)
            alertController.addAction(twoWayVideoAction)
        }

        alertController.addAction(cancelAction())

        return alertController
    }

    private func alertController() -> UIAlertController {
        return UIAlertController(
            title: "Engagement type",
            message: "Please select an engagement type",
            preferredStyle: .actionSheet
        )
    }

    private func action(
        withTitle title: String,
        closure: @escaping () -> Void?
    ) -> UIAlertAction {
        return UIAlertAction(title: title, style: .default) { _ in
            closure()
        }
    }

    private func cancelAction() -> UIAlertAction {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }
}
