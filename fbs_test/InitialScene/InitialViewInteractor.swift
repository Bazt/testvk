import Foundation
import VK_ios_sdk

protocol InitialViewInteractorProtocol: VKSdkDelegate
{
    func authorize()
}

class InitialViewInteractor: NSObject, InitialViewInteractorProtocol
{
    var presenter: InitialViewPresenterProtocol?

    // MARK: InitialViewInteractorProtocol
    func authorize()
    {
        let scope = ["friends"]
        VKSdk.wakeUpSession(scope)
        {
            (state, error) in
            if (state == VKAuthorizationState.authorized)
            {
                // Authorized and ready to go
                self.onSucessfulAuthorization()

            } else if (state == VKAuthorizationState.initialized)
            {
                VKSdk.authorize(scope)
            } else
            {
                print("sorry can't do that")
            }
        }
    }

    private func onSucessfulAuthorization()
    {
        AvatarManager.instance.createAvatarDirectory()
        presenter?.authorizationSucceded()
    }

    // MARK: VKSdkDelegate
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!)
    {
        print(result.state)
        if let error = result.error
        {
            presenter?.authorizationFailed(with: error)
        } else
        {
            onSucessfulAuthorization()
        }
    }

    func vkSdkUserAuthorizationFailed()
    {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: "AuthorizationFailed due to a problem with permissions"])
        presenter?.authorizationFailed(with: error)
    }
}