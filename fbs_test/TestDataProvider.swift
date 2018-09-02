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
    
    func getPhotoUrlFor(userId ids: String)
    {
        let api = VKApi.users().get(["user_ids" : ids, "fields" : "photo_50"])
    }
    
    func getFriendsInfo(_ completion: @escaping () -> ())
    {

    }
    
    func getFriends(_ completion: @escaping () -> ())
    {
        
    }
}
