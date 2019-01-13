

import UIKit

public class VimeoVideoExtractor: NSObject {
    fileprivate let domain = "ph.hercsoft.HCVimeoVideoExtractor"
    fileprivate let configURL = "https://player.vimeo.com/video/{id}/config"
    fileprivate var completion: ((_ video: HCVimeoVideo?, _ error:Error?) -> Void)?
    fileprivate var videoId: String = ""
    
    
    public static func fetchVideoURLFrom(url: URL, completion: @escaping (_ video: HCVimeoVideo?, _ error:Error?) -> Void) -> Void {
        let videoId = url.lastPathComponent
        if videoId != "" {
            let videoExtractor = HCVimeoVideoExtractor(id: videoId)
            videoExtractor.completion = completion
            videoExtractor.start()
        }
        else {
            completion(nil, NSError(domain: "ph.hercsoft.HCVimeoVideoExtractor", code:0, userInfo:[NSLocalizedDescriptionKey :  "Invalid video id" , NSLocalizedFailureReasonErrorKey : "Failed to parse the video id"]))
        }
    }
    
    public static func fetchVideoURLFrom(id: String, completion: @escaping (_ video: HCVimeoVideo?, _ error:Error?) -> Void) -> Void {
        if id != "" {
            let videoExtractor = HCVimeoVideoExtractor(id: id)
            videoExtractor.completion = completion
            videoExtractor.start()
        }
        else {
            completion(nil, NSError(domain: "ph.hercsoft.HCVimeoVideoExtractor", code:0, userInfo:[NSLocalizedDescriptionKey :  "Invalid video id" , NSLocalizedFailureReasonErrorKey : "Invalid video id"]))
        }
    }
    
    private init(id: String) {
        self.videoId = id
        self.completion = nil
        super.init()
    }
    
    private func start() -> Void {
        
        guard let completion = self.completion else {
            print("ERROR: Invalid completion handler")
            return
        }
        
        if self.videoId == "" {
            completion(nil, NSError(domain: self.domain, code:0, userInfo:[NSLocalizedDescriptionKey :  "Invalid video id" , NSLocalizedFailureReasonErrorKey : "Invalid video id"]))
            return
        }
        
        let dataURL = self.configURL.replacingOccurrences(of: "{id}", with: self.videoId)
        if let url = URL(string: dataURL) {
            let urlRequest = URLRequest(url: url)
            let session = URLSession.shared
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                guard error == nil else {
                    completion(nil, error)
                    return
                }
                
                guard let responseData = data else {
                    completion(nil, NSError(domain: self.domain, code:2, userInfo:[NSLocalizedDescriptionKey :  "Invalid response" , NSLocalizedFailureReasonErrorKey : "Invalid response from Vimeo"]))
                    return
                }
                
                do {
                    guard let data = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                        completion(nil, NSError(domain: self.domain, code:3, userInfo:[NSLocalizedDescriptionKey :  "Invalid response" , NSLocalizedFailureReasonErrorKey : "Failed to parse Vimeo response"]))
                        return
                    }
                    
                    if let files = (data as NSDictionary).value(forKeyPath: "request.files.progressive") as? Array<Dictionary<String,Any>> {
                        
                        let video = HCVimeoVideo()
                        if let title = (data as NSDictionary).value(forKeyPath: "video.title") as? String {
                            video.title = title
                        }
                        
                        if let thumbnails = (data as NSDictionary).value(forKeyPath: "video.thumbs") as? Dictionary<String,Any> {
                            for (quality, url) in thumbnails {
                                if let turl = url as? String {
                                    video.thumbnailURL[self.thumbnailQualityWith(string: quality)] = URL(string: turl)
                                }
                            }
                        }
                        
                        for file in files {
                            if let quality = file["quality"] as? String {
                                if let url = file["url"] as? String {
                                    video.videoURL[self.videoQualityWith(string: quality)] = URL(string: url)
                                }
                            }
                        }
                        
                        if video.videoURL.count > 0 {
                            completion(video, nil)
                        }
                        else {
                            completion(nil, NSError(domain: self.domain, code:5, userInfo:[NSLocalizedDescriptionKey :  "Failed to retrive mp4 video url" , NSLocalizedFailureReasonErrorKey : "Failed to retrive mp4 video url"]))
                        }
                    }
                    else {
                        completion(nil, NSError(domain: self.domain, code:4, userInfo:[NSLocalizedDescriptionKey :  "Failed to retrive mp4 video url" , NSLocalizedFailureReasonErrorKey : "Failed to retrive mp4 video url"]))
                    }
                } catch  {
                    completion(nil, NSError(domain: self.domain, code:3, userInfo:[NSLocalizedDescriptionKey :  "Failed to parse Vimeo response" , NSLocalizedFailureReasonErrorKey : "Failed to parse Vimeo response"]))
                    return
                }
            })
            task.resume()
        }
        else {
            completion(nil, NSError(domain: self.domain, code:1, userInfo:[NSLocalizedDescriptionKey :  "Failed to retrieve video URL" , NSLocalizedFailureReasonErrorKey : "Failed to retrieve video URL"]))
        }
    }
 
    private func videoQualityWith(string: String) -> HCVimeoVideoQuality {
        if string == "360p" {
            return .Quality360p
        }
        else if string == "540p" {
            return .Quality540p
        }
        else if string == "640p" {
            return .Quality640p
        }
        else if string == "720p" {
            return .Quality720p
        }
        else if string == "960p" {
            return .Quality960p
        }
        else if string == "1080p" {
            return .Quality1080p
        }
        
        return .QualityUnknown
    }
    
    private func thumbnailQualityWith(string: String) -> HCVimeoThumbnailQuality {
        if string == "640" {
            return .Quality640
        }
        else if string == "960" {
            return .Quality960
        }
        else if string == "1280" {
            return .Quality1280
        }
        else if string == "base" {
            return .QualityBase
        }        
        return .QualityUnknown
    }
}
