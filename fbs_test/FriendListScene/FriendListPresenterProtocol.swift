//
//  InitialViewPresenter.swift
//  fbs_test
//
//  Created by Oleg Sherbakov on 31/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation

protocol FriendListPresenterProtocol
{
    func presentFriends(friends: [FriendProtocol])
    func presentError(error: Error?)
}

class FriendListPresenter: FriendListPresenterProtocol {
    weak var viewController: FriendListControllerProtocol?
    
    func presentFriends(friends: [FriendProtocol])
    {
        viewController?.updateList(with: friends)
    }
    
    func presentError(error: Error?)
    {
        
    }
}
