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
    
    func download(from url: URL, to destination: URL, completion: @escaping () -> ())
    {
        _ = URLSession.shared.downloadTask(with: url)
        {
            localURL, urlResponse, error in
            
            if let localURL = localURL
            {
                try? FileManager.default.moveItem(at: localURL, to: destination)
            }
            completion()
        }.resume()
    }
    
    
    
    func download(_ urls: [(from: URL, to: URL)], completion: @escaping () -> ())
    {
        var notFinishedCount = urls.count
        for url in urls
        {
            _ = URLSession.shared.downloadTask(with: url.from)
            {
                localURL, urlResponse, error in
                
                if let localURL = localURL
                {
                    try? FileManager.default.moveItem(at: localURL, to: url.to)
                }
                
                notFinishedCount -= 1
                if notFinishedCount == 0
                {
                    completion()
                }
            }.resume()
        }
    }
        
        
        
}
