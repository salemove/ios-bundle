import SalemoveSDK

struct InteractorFactory {
    var cleanUpBlock: (() -> Void)?

    func interactor(withChatType chatType: ChatType) -> EngagementStatusViewController? {
        guard let interactor = EngagementStatusViewController.initStoryboardInstance() else {
            debugPrint("could not initialise storyboard for EngagementStatusViewController")
            return nil
        }

        interactor.chatType = chatType
        interactor.cleanUpBlock = cleanUpBlock

        return interactor
    }
}
