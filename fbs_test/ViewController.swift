//
//  ViewController.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 25/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import UIKit
import VK_ios_sdk

class ViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate
{
    func vkSdkShouldPresent(_ controller: UIViewController!)
    {
        if (self.presentedViewController != nil)
        {
            self.dismiss(animated: true, completion:
            {

                self.present(controller, animated: true, completion:nil)
            })
        }
        else
        {
            self.present(controller, animated: true, completion:nil)
        }
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!)
    {

    }

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!)
    {
        afterAuth()
    }

    func vkSdkUserAuthorizationFailed()
    {

    }
    


    func afterAuth()
    {
        TestDataProvider.shared.getFriends {
            self.performSegue(withIdentifier: "friendsListSegue", sender: self)
        }
    }

    @IBAction func touchUpInside(_ sender: Any)
    {
        let scope = ["friends", "email"]
        VKSdk.wakeUpSession(scope)
        {
            (state, error) in
            if (state == VKAuthorizationState.authorized)
            {
                // Authorized and ready to go
                self.afterAuth()
            } else if (state == VKAuthorizationState.initialized)
            {
                VKSdk.authorize(scope)
            } else
            {
                print("sorry can't do that")
            }
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if let sdk = VKSdk.initialize(withAppId: "6672671")
        {
            sdk.uiDelegate = self
            sdk.register(self)


        }

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

