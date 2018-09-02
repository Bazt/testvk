//
//  Downloader.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 03/09/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
class Downloader
{
    static let instance = Downloader()
    
    private init() {}
    
    func downloadImage(from url: URL, to destination: URL)
    {
        _ = URLSession.shared.downloadTask(with: url)
        {
            localURL, urlResponse, error in
            
            if let localURL = localURL
            {
                try? FileManager.default.moveItem(at: localURL, to: destination)
            }
        }.resume()
    }
        
        
        
}
