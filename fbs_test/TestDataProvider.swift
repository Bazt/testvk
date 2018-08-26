//
//  TestDataProvider.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 26/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import VK_ios_sdk

class TestDataProvider
{
    static let shared = TestDataProvider()
    
    var friendIds = [Int]()
    var friends = [String]()
    
    
    func getFriendsInfo(_ completion: @escaping () -> ())
    {
        let ids = friendIds.map{String($0)}.joined(separator: ",")
        print(ids)
        let api = VKApi.users().get(["user_ids": ids])
        api?.execute(resultBlock: { (response) in
            print(response ?? "")
            
            guard let r = response?.json as? [[AnyHashable: Any]] else { return }
            let rr = r.map {($0["first_name"], $0["last_name"])}
            guard let rrr = rr as? [(String, String)] else {return}
            self.friends = rrr.map{ $0.0 + " " + $0.1 }
            print(self.friends)
            completion()
        }, errorBlock: { (error) in
            print(error)
        })
    }
    
    func getFriends(_ completion: @escaping () -> ())
    {
        let r = VKApi.friends().get()
        r?.execute(
            resultBlock:
            {
                response in
                print(response ?? "oops")
                
                guard let response = response?.json as? Dictionary<AnyHashable, Any>,
                    let friendIds = response["items"] as? [Int] else { return }
                
                print(friendIds)
                self.friendIds = friendIds
                
                self.getFriendsInfo(completion)
                
        },
            errorBlock:
            {
                error in
                print(error ?? "oops")
        }
        )
    }
}
