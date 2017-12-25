
import UIKit

public class CirclePieIndicatorView: UIView {

    // Our custom view from the XIB file
    var view: UIView!
    
    @IBOutlet var circlePieView: CirclePieView!
    @IBOutlet weak var percentageLabel: UILabel!
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
        
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }

    private func loadViewFromNib()->UIView{
        let bundle = Bundle(for: type(of:self))
        let nib = UINib(nibName: String.init(describing: type(of:self)), bundle: bundle)
        let viewNib = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return viewNib
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    
    
    }
    */
    
}
