//
//  InitialViewPresenter.swift
//  fbs_test
//
//  Created by Oleg Sherbakov on 31/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation

protocol InitialViewPresenterProtocol {
    func authorization(success: Bool)
}

class InitialViewPresenter: InitialViewPresenterProtocol {
    func authorization(success: Bool) {
        if success
        {
            viewController?.authorizationSucceeded()
        }
        else
        {
            viewController?.authorizationFaild(with: nil)
        }
    }
    
    weak var viewController: InitialViewControllerProtocol?
}
