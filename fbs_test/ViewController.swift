//
//  ViewController.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 25/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import UIKit
import VK_ios_sdk

protocol InitialViewControllerProtocol: class
{
    func showFriendsList()
}

class ViewController: UIViewController, InitialViewControllerProtocol, VKSdkDelegate, VKSdkUIDelegate
{
    var interactor: InitialViewInteractorProtocol?

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
    
    func showFriendsList() {
        
    }
    
    private func config()
    {
        let interactor = InitialViewInteractor()
        let presenter = InitialViewPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func afterAuth()
    {
        TestDataProvider.shared.getFriends {
            self.performSegue(withIdentifier: "friendsListSegue", sender: self)
        }
    }

    @IBAction func touchUpInside(_ sender: Any)
    {
        interactor?.authorize()
        

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

