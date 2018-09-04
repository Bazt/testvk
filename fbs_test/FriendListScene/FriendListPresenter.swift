import Foundation

protocol FriendListPresenterProtocol
{
    func presentFriends(friends: [UserProtocol])
    func presentError(error: Error?)
    func presentHeader(with user: UserProtocol)
}

class FriendListPresenter: FriendListPresenterProtocol
{
    weak var viewController: FriendListControllerProtocol?

    func presentFriends(friends: [UserProtocol])
    {
        viewController?.updateList(with: friends)
    }

    func presentError(error: Error?)
    {
    }

    func presentHeader(with user: UserProtocol)
    {
        viewController?.updateHeader(with: user)
    }
}
