import UIKit
import VK_ios_sdk

protocol ImageSelectionViewControllerProtocol: class
{

}

class ImageSelectionViewController: UIViewController, ImageSelectionViewControllerProtocol, UIImagePickerControllerDelegate

& UINavigationControllerDelegate
{
    var interactor: ImageSelectionInteractorProtocol?
    var selectedUser: UserProtocol?


    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!

    @IBAction func onSelectImage(_ sender: Any)
    {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
            _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {
            _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom
        {
        case .pad:
            let view = sender as! UIView
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = view.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }

        self.present(alert, animated: true, completion: nil)
    }

    private func openCamera()
    {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else
        {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func openGallary()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any])
    {
        if var image = info[UIImagePickerControllerEditedImage] as? UIImage,
           let id = selectedUser?.id
        {

            let (h, w) = (image.size.height, image.size.width)
            let size = min(h, w)
            let (x, y) = (max(0, (w - h) / 2), max(0, (h - w) / 2))
            let area = CGRect(x: x, y: y, width: size, height: size)
            if let cgImage = image.cgImage?.cropping(to: area)
            {
                image = UIImage(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
            }

            image = rotateImage(image: image)

            let pngImage = UIImagePNGRepresentation(image)

            try? pngImage?.write(to: AvatarManager.instance.url(for: id))
            avatarView?.image = image
            self.view.setNeedsLayout()
        }

        picker.dismiss(animated: true, completion: nil);
    }

    func rotateImage(image: UIImage) -> UIImage
    {

        if (image.imageOrientation == UIImageOrientation.up)
        {
            return image
        }

        UIGraphicsBeginImageContext(image.size)

        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return copy!
    }

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

extension UIImage
{

    func updateImageOrientionUpSide() -> UIImage?
    {
        if self.imageOrientation == .up
        {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        UIGraphicsEndImageContext()
        return nil
    }
}
