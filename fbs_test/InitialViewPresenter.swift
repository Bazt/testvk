//
//  InitialViewPresenter.swift
//  fbs_test
//
//  Created by Oleg Sherbakov on 31/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation

protocol InitialViewPresenterProtocol {
    func authorizationWith(_ result: Bool)
}

class InitialViewPresenter: InitialViewPresenterProtocol {
    func authorizationWith(_ result: Bool) {
        if result
        {
            viewController?.showFriendsList()
        }
    }
    
    weak var viewController: InitialViewControllerProtocol?
}
