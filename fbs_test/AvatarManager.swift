import Foundation
import UIKit

class AvatarManager
{
    static let instance = AvatarManager()

    internal init()
    {
        createAvatarDirectory()
    }

    let avatarDirectoryUrl = URL(fileURLWithPath: NSTemporaryDirectory() + ".avatars/")

    func createAvatarDirectory()
    {
        if !FileManager.default.fileExists(atPath: avatarDirectoryUrl.path)
        {
            do
            {
                try FileManager.default.createDirectory(at: avatarDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
            } catch
            {
                print(error.localizedDescription)
            }
        }
    }

    func hasAvatarFor(userId: String) -> Bool
    {
        let path = self.path(for: userId)
        return FileManager.default.fileExists(atPath: path)
    }

    func saveAvatar(from sourceUrl: URL, to destination: URL)
    {
        try? FileManager.default.moveItem(at: sourceUrl, to: destination)
    }

    private func path(for userId: String) -> String
    {
        print("path for \(userId) is \(avatarDirectoryUrl.appendingPathComponent("\(userId).png").path)")
        return avatarDirectoryUrl.appendingPathComponent("\(userId).png").path
    }

    func url(for userId: String) -> URL
    {
        return URL(fileURLWithPath: path(for: userId))
    }

    func getImage(for user: UserProtocol, completion: @escaping (UIImage) -> Void)
    {
        let localUrl = url(for: user.id)
        if hasAvatarFor(userId: user.id),
           let image = UIImage(contentsOfFile: localUrl.path)
        {
            completion(image)
        } else
        {
            Downloader.instance.download(from: user.imageUrl, to: localUrl)
            {
                let localUrl = self.url(for: user.id)
                let image = UIImage(contentsOfFile: localUrl.path) ?? UIImage(named: "default_avatar")!
                completion(image)
            }
        }
    }

    func removeAllImages()
    {
        FileManager.default.clearTmpDirectory()
    }
}

extension FileManager
{
    func clearTmpDirectory()
    {
        do
        {
            let tmpDirectory = try contentsOfDirectory(atPath: NSTemporaryDirectory())
            try tmpDirectory.forEach
            {
                [unowned self] file in
                print(AvatarManager.instance.avatarDirectoryUrl.path)
                try self.removeItem(atPath: AvatarManager.instance.avatarDirectoryUrl.path)
            }
        } catch
        {
            print(error)
        }
    }
}