
import UIKit

class AnimatableHamburgerView: UIView {
  
  let imageView: UIImageView! = UIImageView(image: UIImage(named: "Hamburger"))
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
  
    required override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
  
    // MARK: RotatingView
  
    func rotate(fraction: CGFloat) {
        let angle = Double(fraction) * (Double.pi / 2)
        imageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
    }
  
    // MARK: Private
  
    private func configure() {
        imageView.contentMode = UIViewContentMode.center
        addSubview(imageView)
    }
  
}
