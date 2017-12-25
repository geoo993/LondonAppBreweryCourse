import Foundation

public extension UINavigationBar {
    
    public func clearNavigationBarBackground(with color: UIColor){
        self.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
        self.backgroundColor = color
        
    }
}
