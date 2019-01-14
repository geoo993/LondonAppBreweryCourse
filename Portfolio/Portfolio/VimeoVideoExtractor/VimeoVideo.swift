
import UIKit

public enum VimeoThumbnailQuality: String {
    case Quality640 = "640"
    case Quality960 = "960"
    case Quality1280 = "1280"
    case QualityBase = "base"
    case QualityUnknown = "unknown"
}

public enum VimeoVideoQuality: String {
    case Quality360p = "360p"
    case Quality540p = "540p"
    case Quality640p = "640p"
    case Quality720p = "720p"
    case Quality960p = "960p"
    case Quality1080p = "1080p"
    case QualityUnknown = "unknown"
}

public class VimeoVideo: NSObject {
    public var profileID: Int = 0
    public var profileImage: URL? = URL(string: "")
    public var profileName: String  = ""
    public var profileUrl: String  = ""
    public var title: String = ""
    public var videoDescription: String = ""
    public var thumbnailURL = [VimeoThumbnailQuality: URL]()
    public var videoURL = [VimeoVideoQuality: URL]()
}
