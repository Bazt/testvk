import Foundation
import VK_ios_sdk

protocol FriendListInteractorProtocol: class {
    func getFriendList()
    func onFriendListResult(result: ResultForFriends)
    func getDataForHeader()
    func onDataForHeader(user: UserProtocol)
}

class FriendListInteractor: FriendListInteractorProtocol  {
    var presenter: FriendListPresenterProtocol?
    
    func getDataForHeader()
    {
        DataProvider.instance.getDataForHeader(for: self)
    }
    
    func onDataForHeader(user: UserProtocol)
    {
        presenter?.presentHeader(with: user)
    }
    
    func getFriendList()
    {
        DataProvider.instance.getFriendsWithImages(for: self)
    }
    
    func onFriendListResult(result: ResultForFriends)
    {
        guard let friends = result.data else
        {
            presenter?.presentError(error: result.error)
            return
        }
        
        presenter?.presentFriends(friends: friends)
    }
    
    
}
