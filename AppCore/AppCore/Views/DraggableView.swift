
//https://stackoverflow.com/questions/29659360/swift-uidynamic-animate-panel-from-bottom-to-top
////from:: https://www.youtube.com/watch?v=PyYrLy8kTYg

import UIKit

class DraggableView: UIView, UICollisionBehaviorDelegate {
    
    @IBOutlet weak var bottomIndicator : UIView!
    @IBOutlet weak var backgroundImageView : UIImageView!
    
    var animator : UIDynamicAnimator? = nil
    var containerBoundary : UICollisionBehavior!
    var snapBehavior : UISnapBehavior!
    var dynamicItemBehavior : UIDynamicItemBehavior!
    var gravityBehavior : UIGravityBehavior!
    var panGesture : UIPanGestureRecognizer!
    
    var heightToSee : CGFloat = 80
    var maxHeight : CGFloat? = nil
    var superViewHeight : CGFloat? = nil
    
    
    func setup(){
        self.translatesAutoresizingMaskIntoConstraints = true
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupPanGesture()
        setupAnimator()
    }
    
    func setupAnimator(){
        animator = UIDynamicAnimator(referenceView: self.superview!)
        setupDynamicItemBehavior()
        setupGravityBehavior()
        setupContainerBoundary()
        configureContainerBoundary()
        animator?.addBehavior(gravityBehavior)
        animator?.addBehavior(dynamicItemBehavior)
        animator?.addBehavior(containerBoundary)
    }
    
    func setupDynamicItemBehavior (){
        dynamicItemBehavior = UIDynamicItemBehavior(items: [self])
        dynamicItemBehavior.resistance = 0
        dynamicItemBehavior.allowsRotation = false
        dynamicItemBehavior.elasticity = 0
    }
    func setupGravityBehavior (){
        gravityBehavior = UIGravityBehavior(items: [self])
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: -1)
    }
    func setupContainerBoundary (){
        containerBoundary = UICollisionBehavior(items: [self])
        containerBoundary.collisionDelegate = self 
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        
        dynamicItemBehavior.resistance = 100
    }
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item1: UIDynamicItem, with item2: UIDynamicItem) {
        
        dynamicItemBehavior.resistance = 0;
    }
    
    func configureContainerBoundary (){
        let containerBoundaryWidth = UIScreen.main.bounds.size.width
        let upperContainerBoundary = (-self.frame.size.height + heightToSee)
        containerBoundary.addBoundary(withIdentifier: ("upperBoundary" as NSCopying) , from: CGPoint(x:0,y:upperContainerBoundary), to: CGPoint(x:containerBoundaryWidth,y:upperContainerBoundary))
        
        let lowerContainerBoundary = maxHeight ?? UIScreen.main.bounds.size.height
        containerBoundary.addBoundary(withIdentifier: ("lowerBoundary" as NSCopying) , from: CGPoint(x:0,y:lowerContainerBoundary), to: CGPoint(x:containerBoundaryWidth,y:lowerContainerBoundary))
        
    }
  
    func crossToTopSectionOfSuperView(){
        panGestureSnapToTop()
    }
    
    func crossToBottomSectionOfSuperView(){
        panGestureSnapToBottom()
        //print("Going to the bottom section of supper view")
    }
    
    func panGestureSnapToTop(){
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: -2.0)
        self.roundCorners([.bottomRight, .bottomLeft], radius: 0)
        //print("Going to the top")
    }
    
    func panGestureSnapToBottom(){
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 2.0)
        //print("Going to the bottom")
        self.roundCorners([.bottomRight, .bottomLeft], radius: 10)
    }
    
    func setupPanGesture(){
        panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.handlePan))
        panGesture?.cancelsTouchesInView = false
        bottomIndicator.addGestureRecognizer(panGesture)//change from bottom indicator to self
    }
    
    @objc func handlePan (pan:UIPanGestureRecognizer) {
        let velocity = pan.velocity(in: self.superview).y
        var movement = self.frame
        movement.origin.x = 0
        movement.origin.y = movement.origin.y + (velocity * 0.04)
        
        if pan.state == .ended {
            panGestureEnded()
        }else if pan.state == .began{
            panGestureSnapToBottom()
        }else{
            if (self.snapBehavior != nil) {
                animator?.removeBehavior(snapBehavior)
            }
            snapBehavior = UISnapBehavior(item: self, snapTo: CGPoint(x: movement.midX, y: movement.midY))
            animator?.addBehavior(snapBehavior)
        }
    }
    
    func panGestureEnded(){
        
        if (self.snapBehavior != nil) {
            animator?.removeBehavior(snapBehavior)
        }
        let velocity = dynamicItemBehavior.linearVelocity(for: self)
        
        let panOffset = panGesture.translation(in: self)
        let panMovement: CGFloat = abs(panOffset.y)
        
        //if fabsf(Float(velocity.y)) > Float(maxHeight! / 2) {
        if (panMovement > (maxHeight! / 2) )  {
            
            if velocity.y < 0 {
                panGestureSnapToTop()
            }else{
                panGestureSnapToBottom()
            }
        }else{
            
            if let superViewHeight = superViewHeight {
                if self.frame.origin.y > (superViewHeight / 2) {
                    crossToBottomSectionOfSuperView()
                }else{
                    crossToTopSectionOfSuperView()
                }
            }
        }
        
    }
    /*
     override init(frame: CGRect) {
     super.init(frame: frame)
     
     }
     */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
     override func awakeFromNib() {
     super.awakeFromNib()
     // Initialization code
     }
     
     public override func willMove(toSuperview newSuperview: UIView?) {
     super.willMove(toSuperview: newSuperview)
     }
     
     public override func layoutSubviews() {
     super.layoutSubviews()
     
     }
     
     */
    
    deinit {
        self.removeNestedSubviewsAndConstraints()
        animator = nil
        containerBoundary = nil
        snapBehavior = nil
        dynamicItemBehavior = nil
        gravityBehavior = nil
        panGesture = nil
    }
}
