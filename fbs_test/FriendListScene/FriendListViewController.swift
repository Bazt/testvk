//
//  FBSTableVC.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 26/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import UIKit

struct HeaderInfo
{
    var imageUrl: URL
    var name: String
    var id: String
}

protocol FriendListControllerProtocol: class
{
    func updateList(with friends: [UserProtocol])
    func updateHeader(with data: HeaderInfo)
}

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendListControllerProtocol

{
    @IBOutlet weak var friendsView: UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var interactor: FriendListInteractorProtocol?
    var friends: [UserProtocol]?
    var headerInfo: HeaderInfo?
    
    func updateList(with friends: [UserProtocol])
    {
        DispatchQueue.main.async {
        self.friends = friends
        self.friendsView.reloadData()
        }
    }
    
    func updateHeader(with data: HeaderInfo)
    {
        DispatchQueue.main.async {
            self.headerInfo = data
            self.headerLabel.text = data.name
            self.headerImageView.image = UIImage(contentsOfFile: data.imageUrl.path)
        }

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
        let interactor = FriendListInteractor()
        let presenter = FriendListPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        interactor?.getFriendList()
        interactor?.getDataForHeader()
        
        self.friendsView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCellId")
        
        self.friendsView.delegate = self
        self.friendsView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCellId", for: indexPath) as UITableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = friends?[indexPath.row].name ?? "No name"
        let defaultImage = UIImage(named: "default_avatar")
        cell.imageView?.image  = defaultImage
        //headerImageView?.image = defaultImage
        
        
        friends?[indexPath.row].getImage(completion:
        {
            image in
            cell.imageView?.image = image
        })
        //cell.imageView?.downloaded(from: url, id: friends?[indexPath.row].id)
        
        print("cellForRowAt \(indexPath.row), title = \(cell.textLabel?.text ?? "nil")")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        performSegue(withIdentifier: "showDetails", sender: self)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let r = 56
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationController = segue.destination as? ImageSelectionViewController
        {
            destinationController.userInfo = headerInfo
        }
    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        
//    }
}

//extension UIImageView {
//    func downloaded(from url: URL, id: String?, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                    self.image = image
//                    let png = UIImagePNGRepresentation(image)
//                    if let id = id
//                    {
//
//
//                        let success = try? png?.write(to: AvatarManager.instance.url(for: id))
//                        print(success, id, AvatarManager.instance.url(for: id))
//                    }
//                }
//            }.resume()
//    }
//}
