//
//  FileManager.swift
//  fbs_test
//
//  Created by Oleg Shcherbakov on 03/09/2018.
//  Copyright © 2018 Oleg Shcherbakov. All rights reserved.
//

import Foundation
class AvatarManager
{
    static let instance = AvatarManager()
    
    private init()
    {
        try? FileManager.default.createDirectory(at: avatarDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
    }
    
    let avatarDirectoryUrl = URL(string: NSTemporaryDirectory() + ".avatars/")!
    
    func haveAvatarFor(userId: String) -> Bool
    {
        let path = self.path(for: userId)
        return FileManager.default.fileExists(atPath: path)
    }
    
    func saveAvatar(from sourceUrl: URL, for userId: String)
    {
        let destination = URL(string: path(for: userId))!
        
        try? FileManager.default.moveItem(at: sourceUrl, to: destination)
    }
    
    private func path(for userId: String) -> String
    {
        print("path for \(userId) is \(avatarDirectoryUrl.appendingPathComponent("\(userId).png").path)")
        return avatarDirectoryUrl.appendingPathComponent("\(userId).png").path
    }
    
    func url(for userId: String) -> URL
    {
        return URL(string: path(for: userId))!
    }
}
