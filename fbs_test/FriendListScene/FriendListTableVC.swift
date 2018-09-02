//
//  FBSTableVC.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 26/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import UIKit

protocol FriendListControllerProtocol: class
{
    func updateList(with friends: [FriendProtocol])
}

class FriendListTableVC: UITableViewController, FriendListControllerProtocol
{
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet var friendsView: UITableView!
    
    var interactor: FriendListInteractorProtocol?
    var friends: [FriendProtocol]?
    
    func updateList(with friends: [FriendProtocol])
    {
        self.friends = friends
        friendsView.reloadData()
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
        
        self.friendsView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.friendsView.delegate = self
        self.friendsView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCellId", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = friends?[indexPath.row].name ?? "No name"
        let url = friends?[indexPath.row].imageUrl ?? URL(string: "https://vk.com/images/camera_50.png")
        cell.imageView?.downloaded(from: url!)
        
        print("cellForRowAt \(indexPath.row), title = \(cell.textLabel?.text ?? "nil")")
        return cell
        
    }


//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        
//    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
