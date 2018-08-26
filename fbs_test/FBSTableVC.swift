//
//  FBSTableVC.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 26/08/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import UIKit

class FBSTableVC: UITableViewController
{
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet var friendsView: UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.friendsView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.friendsView.delegate = self
        self.friendsView.dataSource = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TestDataProvider.shared.friendIds.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseCellId", for: indexPath) as UITableViewCell
        let itemsToShow = TestDataProvider.shared.friends
        cell.textLabel?.text = itemsToShow[indexPath.row]
        
        print("cellForRowAt \(indexPath.row), title = \(cell.textLabel?.text ?? "nil")")
        return cell
        
    }


//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
//    {
//        
//    }
}
