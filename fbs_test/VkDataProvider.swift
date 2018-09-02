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
        get set
    }
    var imageUrl: URL?
    {
        get
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

protocol VkDataProviderProtocol
{
    func getFriendsWithImages(for interactor: FriendListInteractorProtocol)
}

class VkDataProvider: VkDataProviderProtocol
{
    static let instance = VkDataProvider()

    private var friends: [FriendProtocol]?

    private init()
    {

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
                                    let friend = Friend(name: name, id: String(id), imageUrl: URL(string: urlString))
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

    func getFriendsWithImages(for interactor: FriendListInteractorProtocol)
    {
        obtainFriends
        {
            interactor.onFriendListResult(result: $0)
        }
    }


}
