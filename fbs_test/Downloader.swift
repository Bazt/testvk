import Foundation

class Downloader
{
    static let instance = Downloader()

    private init()
    {}

    func download(from url: URL, to destination: URL, completion: @escaping () -> ())
    {
        _ = URLSession.shared.downloadTask(with: url)
        {
            localURL, urlResponse, error in

            if let localURL = localURL
            {
                AvatarManager.instance.saveAvatar(from: localURL, to: destination)
            }
            completion()
        }.resume()
    }


    func download(_ urls: [(from: URL, to: URL)], completion: @escaping () -> ())
    {
        var notFinishedCount = urls.count
        for (from, to) in urls
        {
            _ = URLSession.shared.downloadTask(with: from)
            {
                localURL, urlResponse, error in

                if let localURL = localURL
                {
                    AvatarManager.instance.saveAvatar(from: localURL, to: to)
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
