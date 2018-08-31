//
//  InteractorProtocol.swift
//  fbs_test
//
//  Created by Oleg Sherbakov on 31/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import VK_ios_sdk

protocol InitialViewInteractorProtocol {
    func authorize()
}

class InitialViewInteractor: InitialViewInteractorProtocol {
    var presenter: InitialViewPresenterProtocol?
    
    func authorize() {
        let scope = ["friends", "email"]
        VKSdk.wakeUpSession(scope)
        {
            (state, error) in
            if (state == VKAuthorizationState.authorized)
            {
                // Authorized and ready to go
                self.presenter?.authorizationWith(true)
            } else if (state == VKAuthorizationState.initialized)
            {
                VKSdk.authorize(scope)
            } else
            {
                print("sorry can't do that")
            }
        }
    }
    
    
}
