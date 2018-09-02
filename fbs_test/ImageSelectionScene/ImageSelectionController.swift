//
//  ViewController.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 25/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import UIKit
import VK_ios_sdk

protocol ImageSelectionViewControllerProtocol: class
{
   
}

class ImageSelectionViewController: UIViewController, ImageSelectionViewControllerProtocol, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{
    var interactor: ImageSelectionInteractorProtocol?
    var userInfo: HeaderInfo?
    
 
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBAction func onSelectImage(_ sender: Any) {
   
    
  
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
        
        if let id = self.userInfo?.id
        {
            let image = UIImagePNGRepresentation(image)
            try? image?.write(to: AvatarManager.instance.url(for: id))
            
        }
        })
        
        //imageView.image = image
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
        let interactor = ImageSelectionInteractor()
        let presenter = ImageSelectionPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        //self.navigationController!.navigationBar.backItem?.title = "Log out"
        
        guard let url = userInfo?.imageUrl else
        {
            return
        }
        
        if url.path.contains("avatars"),
           let data = try? Data(contentsOf: url)
        {
            avatarView.image = UIImage(data: data)
        }
        else
        {
            avatarView.downloaded(from: url, id: userInfo?.id)
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

