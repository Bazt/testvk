//
//  InteractorProtocol.swift
//  fbs_test
//
//  Created by Oleg Sherbakov on 31/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import VK_ios_sdk

protocol InitialViewInteractorProtocol: VKSdkDelegate {
    func authorize()
}

class InitialViewInteractor: NSObject, InitialViewInteractorProtocol  {
    var presenter: InitialViewPresenterProtocol?
    
    func authorize()
    {
        let scope = ["friends", "email"]
        VKSdk.wakeUpSession(scope)
        {
            (state, error) in
            if (state == VKAuthorizationState.authorized)
            {
                // Authorized and ready to go
                //VkDataProvider.instance.getFriendsWithImages(for: self)
                self.presenter?.authorization(success: true)
            } else if (state == VKAuthorizationState.initialized)
            {
                VKSdk.authorize(scope)
            } else
            {
                print("sorry can't do that")
            }
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!)
    {
        presenter?.authorization(success: true)
    }
    
    func vkSdkUserAuthorizationFailed()
    {
        presenter?.authorization(success: false)
    }
    
    
}
