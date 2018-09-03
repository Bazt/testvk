//
// Created by Oleg Sherbakov on 03/09/2018.
// Copyright (c) 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import UIKit

protocol UserProtocol
{
    var name: String
    {
        get
    }
    var id: String
    {
        get
    }
    var imageUrl: URL
    {
        get set
    }

    func getImage(completion: @escaping (UIImage) -> Void)
}


struct User: UserProtocol
{
    var id: String
    var name: String
    var imageUrl: URL
    func getImage(completion: @escaping (UIImage) -> Void)
    {
        AvatarManager.instance.getImage(for: self, completion: completion)
    }
}
