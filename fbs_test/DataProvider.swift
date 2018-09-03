//
//  VkDataProvider.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 01/09/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import VK_ios_sdk

typealias ResultForFriends = RequestResult<[UserProtocol], Error>

protocol DataProviderProtocol
{
    func getFriendsWithImages(for interactor: FriendListInteractorProtocol)
    func getDataForHeader(for interactor: FriendListInteractorProtocol)
}

class DataProvider: DataProviderProtocol
{
    static let instance = DataProvider()

    private var friends: [UserProtocol]

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
                    let id = info["id"] as? Int,
                    let imagePath = info ["photo_50"] as? String,
                    let imageUrl = URL(string: imagePath) else
                {
                    return
                }
                
                let userId = String(id)
                let localAvatarUrl = AvatarManager.instance.url(for: userId)
                let name = "\(firstName) \(lastName)"
                if !AvatarManager.instance.hasAvatarFor(userId: userId)
                {
                    Downloader.instance.download(from: imageUrl, to: localAvatarUrl, completion:
                    {
                        interactor.onDataForHeader(data: HeaderInfo(imageUrl: AvatarManager.instance.url(for: userId), name: name, id: userId))
                    })
                }
                else
                {
                    interactor.onDataForHeader(data: HeaderInfo(imageUrl: AvatarManager.instance.url(for: userId), name: name, id: userId))
                }
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
                            
                            var friends = [UserProtocol]()
                            
                            _ = response.map
                            {
                                user in
                                if let firstName = user["first_name"] as? String,
                                    let lastName = user["last_name"] as? String,
                                    let id = user["id"] as? Int,
                                    let imagePath = user["photo_50"] as? String,
                                    let imageUrl = URL(string: imagePath)
                                {
                                    let name = "\(firstName) \(lastName)"
                                    let userId = String(id)
                                    let friend = User(id: userId, name: name, imageUrl: imageUrl)
                                    friends.append(friend)
                                }
                            }
                            
                            completion(ResultForFriends(withData: friends))
//                            if toBeDownloaded.isEmpty
//                            {
//                                completion(ResultForFriends(withData: friends))
//                                return
//                            }
//
//                            Downloader.instance.download(toBeDownloaded, completion:
//                            {
//                                completion(ResultForFriends(withData: friends))
//                            })
                            
                            
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
    
    func getFriendsWithImages(for interactor: FriendListInteractorProtocol)
    {
        obtainFriends
        {
            interactor.onFriendListResult(result: $0)
        }
    }


}
