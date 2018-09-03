//
//  FBSTableVC.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 26/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import UIKit
import VK_ios_sdk

protocol FriendListControllerProtocol: class
{
    func updateList(with friends: [UserProtocol])
    func updateHeader(with user: UserProtocol)
}

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendListControllerProtocol

{
    @IBOutlet weak var friendsView:     UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel:     UILabel!

    var interactor:  FriendListInteractorProtocol?
    var friends =    [UserProtocol]()
    var currentUser: UserProtocol?
    var refresher: UIRefreshControl!
    

    func updateList(with friends: [UserProtocol])
    {
        DispatchQueue.main.async
        {
            self.friends = friends
            self.friendsView.reloadData()
            
            if self.refresher.isRefreshing
            {
                self.refresher.endRefreshing()
            }
        }
    }

    func updateHeader(with data: UserProtocol)
    {
        DispatchQueue.main.async
        {
            self.currentUser = data
            self.headerLabel.text = data.name
            self.headerImageView.image = UIImage(contentsOfFile: data.imageUrl.path)
        }

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
        let interactor = FriendListInteractor()
        let presenter  = FriendListPresenter()
        self.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = self
    }
    
    @objc
    func onRefresh()
    {
        interactor?.getFriendList()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        friendsView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Loading...")
        friendsView.addSubview(refresher)
        refresher.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        refresher.beginRefreshing()
        interactor?.getDataForHeader()
        interactor?.getFriendList()
        

        self.friendsView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseCellId")

        self.friendsView.delegate = self
        self.friendsView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friends.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCellId", for: indexPath) as UITableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = friends[indexPath.row].name
        let defaultImage = UIImage(named: "default_avatar")
        cell.imageView?.image = defaultImage


        friends[indexPath.row].getImage(completion:
        {
            image in
            DispatchQueue.main.async
            {
                cell.imageView?.image = image
            }
        })

        print("cellForRowAt \(indexPath.row), title = \(cell.textLabel?.text ?? "nil")")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "showDetails", sender: self)
    }

    
    override func viewWillDisappear(_ animated: Bool)
    {
        if navigationController?.viewControllers.index(of: self) == nil
        {
            VKSdk.forceLogout()
            AvatarManager.instance.removeAllImages()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let destinationController = segue.destination as? ImageSelectionViewController
        {
            if let row = friendsView.indexPathForSelectedRow?.row,
               friends.count > row
            {
                destinationController.selectedUser = friends[row]
            }
        }
    }
}
