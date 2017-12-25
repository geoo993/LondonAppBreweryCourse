
//https://stackoverflow.com/questions/29046571/cut-a-uiimage-into-a-circle-swiftios
//https://stackoverflow.com/questions/34984966/rounding-uiimage-and-adding-a-border

import UIKit

@IBDesignable
public class CircularImageView: LayoutableImageView {

    override public var image: UIImage? {
        didSet {
            super.image = image?.circularImage(with: nil)
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    
    }

}
