import SalemoveSDK

extension VisitorInfoUpdate.NoteUpdateMethod {
    init(with method: UpdateVisitorInfoViewController.NoteUpdateMethod) {
        switch method {
        case .replace:
            self = .replace
        case .append:
            self = .append
        }
    }
}

extension VisitorInfoUpdate.CustomAttributesUpdateMethod {
    init(with method: UpdateVisitorInfoViewController.CustomAttributesUpdateMethod) {
        switch method {
        case .replace:
            self = .replace
        case .merge:
            self = .merge
        }
    }
}

extension VisitorInfoUpdate {
    init(with visitorInfo: Salemove.VisitorInfo) {
        self.init(
            name: visitorInfo.name,
            email: visitorInfo.email,
            phone: visitorInfo.phone,
            note: visitorInfo.note,
            noteUpdateMethod: nil,
            externalID: nil,
            customAttributes: visitorInfo.customAttributes,
            customAttributesUpdateMethod: nil
        )
    }
}
