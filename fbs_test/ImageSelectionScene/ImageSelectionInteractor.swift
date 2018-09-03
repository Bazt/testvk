//
//  ImageSelectionInteractor.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 02/09/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
import UIKit

protocol ImageSelectionInteractorProtocol
{
   func selectImage()
}

class ImageSelectionInteractor: ImageSelectionInteractorProtocol
{
    var presenter: ImageSelectionPresenterProtocol?

    func selectImage()
    {

    }
    

}
