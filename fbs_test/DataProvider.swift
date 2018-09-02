//
//  VkDataProvider.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 01/09/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import VK_ios_sdk

protocol FriendProtocol
{
    var name: String?
    {
        get
    }
    var id: String?
    {
        get
    }
    var imageUrl: URL?
    {
        get set
    }
}


struct Friend: FriendProtocol
{
    var name: String?
    var id: String?
    var imageUrl: URL?

    init(name: String? = nil, id: String? = nil, imageUrl: URL? = nil)
    {
        self.name = name
        self.id = id
        self.imageUrl = imageUrl
    }
}

typealias ResultForFriends = RequestResult<[FriendProtocol], Error>

protocol DataProviderProtocol
{
    func getFriendsWithImages(for interactor: FriendListInteractorProtocol)
    func getDataForHeader(for interactor: FriendListInteractorProtocol)
}

class DataProvider: DataProviderProtocol
{
    static let instance = DataProvider()

    private var friends: [FriendProtocol]

    private init()
    {
        friends = []
    }
    
    func getDataForHeader(for interactor: FriendListInteractorProtocol)
    {
        let vk = VKApi.users().get(["fields" : "photo_50"])
        vk?.execute(
            resultBlock:
            {
                response in
                
                guard let response = response?.json as? [Any],
                    let info = response.first as? [AnyHashable : Any],
                    let firstName = info["first_name"] as? String,
                    let lastName = info["last_name"] as? String,
                    let id = info["id"] as? String,
                    let imageUrl = info ["photo_50"] as? String else
                {
                    return
                }
                
                let name = "\(firstName) \(lastName)"
                let url = URL(string: imageUrl)!
                interactor.onDataForHeader(data: HeaderInfo(imageUrl: url, name: name, id: id))
            
            },
            errorBlock:
            {
                error in
                
            })
    }

    private func obtainFriends(completion: @escaping (ResultForFriends) -> Void)
    {
        let vkGetFriends = VKApi.friends().get()
        vkGetFriends?.execute(
                resultBlock:
                {
                    response in
                    print(response ?? "couldn't get friends")
                    guard let response = response?.json as? Dictionary<AnyHashable, Any>,
                          let friendIds = response["items"] as? [Int] else
                    {
                        return
                    }

                    let ids = friendIds.map {
                        String($0)
                    }.joined(separator: ",")

                    let vkGetUserInfo = VKApi.users().get(["user_ids": ids, "fields": "photo_50"])
                    vkGetUserInfo?.execute(
                        resultBlock:
                        {
                            (response) in
                            
                            guard let response = response?.json as? [[AnyHashable: Any]] else
                            {
                                return
                            }
                            
                            var friends = [Friend]()
                            _ = response.map
                            {
                                user in
                                if let firstName = user["first_name"] as? String,
                                    let lastName = user["last_name"] as? String,
                                    let id = user["id"] as? Int,
                                    let urlString = user["photo_50"] as? String
                                {
                                    let name = "\(firstName) \(lastName)"
                                    let userId = String(id)
                                    let friend = Friend(name: name, id: userId, imageUrl: URL(string: urlString)!)
                                    
                                    friends.append(friend)
                                }
                            }
                            completion(ResultForFriends(withData: friends))
                        },
                        errorBlock:
                        {
                            error in
                            completion(ResultForFriends(withError: error!))
                        })
                    

                },
                errorBlock:
                {
                    (error) in
                    completion(ResultForFriends(withError: error!))
                })
    }
    
    private func updateAllUrls()
    {
        var changedFriends = [FriendProtocol]()
        
        for friend in friends
        {
            let avatarUrl = AvatarManager.instance.url(for: friend.id!)
            if !AvatarManager.instance.haveAvatarFor(userId: friend.id!)
            {
                var newFriend = friend
                newFriend.imageUrl = avatarUrl
                changedFriends.append(newFriend)
            }
        }
        
        friends = changedFriends
    }
    
    func getFriendsWithImages(for interactor: FriendListInteractorProtocol)
    {
        obtainFriends
        {
            self.updateAllUrls()
            interactor.onFriendListResult(result: $0)
        }
    }


}
