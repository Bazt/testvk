//
//  InitialViewController.swift
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
    var interactor:   ImageSelectionInteractorProtocol?
    var selectedUser: UserProtocol?
    
 
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    @IBAction func onSelectImage(_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) || UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            //imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false

            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if var image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let id = selectedUser?.id
        {

            let (h, w) = (image.size.height, image.size.width)
            let size = min(h, w)
            let (x, y) = (max(0, (w - h) / 2), max(0, (h - w) / 2))
            let area = CGRect(x: x, y: y, width: size, height: size)
            if let cgImage = image.cgImage?.cropping(to: area)
            {
                image = UIImage(cgImage: cgImage)
            }
            

            let pngImage = UIImagePNGRepresentation(image)
            try? pngImage?.write(to: AvatarManager.instance.url(for: id))
            avatarView?.image = image
            self.view.setNeedsLayout()
        }
        
        picker.dismiss(animated: true, completion: nil);
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion:
        {
        
            if let id = self.selectedUser?.id
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
        
        selectedUser?.getImage(completion:
        {
            image in 
            DispatchQueue.main.async
            {
                self.avatarView.image = image
            }
        })

        userNameLabel?.text = selectedUser?.name
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

