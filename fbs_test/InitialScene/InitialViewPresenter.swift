//
//  InitialViewPresenter.swift
//  fbs_test
//
//  Created by Oleg Sherbakov on 31/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation

protocol InitialViewPresenterProtocol {
    func authorizationSucceded()
    func authorizationFailed(with error: Error)
}

class InitialViewPresenter: InitialViewPresenterProtocol
{
    weak var viewController: InitialViewControllerProtocol?
    
    func authorizationFailed(with error: Error)
    {
        viewController?.authorizationFaild(with: error)
    }
    
    func authorizationSucceded()
    {
        viewController?.authorizationSucceeded()
    }
    
}
