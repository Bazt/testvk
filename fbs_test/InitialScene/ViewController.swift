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
    func authorizationSucceeded()
    func authorizationFaild(with error: Error?)
}

class ViewController: UIViewController, InitialViewControllerProtocol, VKSdkUIDelegate
{
    var interactor: InitialViewInteractorProtocol?

    func authorizationSucceeded()
    {
        showNextController()
    }
    
    func authorizationFaild(with error: Error?)
    {
        
    }
    
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
    
    func showNextController()
    {
        self.performSegue(withIdentifier: "friendsListSegue", sender: self)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup()
    {
        let interactor = InitialViewInteractor()
        let presenter = InitialViewPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }

    @IBAction func touchUpInside(_ sender: Any)
    {
        interactor?.authorize()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationController!.navigationBar.backItem?.title = "Log out"
        if let sdk = VKSdk.initialize(withAppId: "6672671")
        {
            sdk.uiDelegate = self
            sdk.register(interactor!)
        }
        
        

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

