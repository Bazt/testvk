import UIKit
import VK_ios_sdk
import Toast_Swift

protocol InitialViewControllerProtocol: class
{
    func authorizationSucceeded()
    func authorizationFaild(with error: Error)
}

class InitialViewController: UIViewController, InitialViewControllerProtocol, VKSdkUIDelegate
{
    var interactor: InitialViewInteractorProtocol?

    @IBAction func touchUpInside(_ sender: Any)
    {
        interactor?.authorize()
    }

    // MARK: UIViewController
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder)
    {
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

    func showNextController()
    {
        self.performSegue(withIdentifier: "friendsListSegue", sender: self)
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

    // MARK: VKSdkUIDelegate
    func vkSdkShouldPresent(_ controller: UIViewController!)
    {
        if (self.presentedViewController != nil)
        {
            self.dismiss(animated: true, completion:
            {

                self.present(controller, animated: true, completion: nil)
            })
        } else
        {
            self.present(controller, animated: true, completion: nil)
        }
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!)
    {
    }

    // MARK: InitialViewControllerProtocol
    func authorizationSucceeded()
    {
        showNextController()
    }

    func authorizationFaild(with error: Error)
    {
        view.makeToast(error.localizedDescription, duration: 3, position: .center)
    }
}

