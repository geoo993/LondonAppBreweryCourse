import Foundation

public extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}

public extension Float {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(Double.pi) / 180.0
    }
}

public extension CGFloat {
    
    public var float: Double {
        return Double(self)
    }
    
    public static func recommendedHeight(withMaxHeight size: CGFloat) -> CGFloat {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        switch height {
        case 480.0: //Iphone 3,4 => 3.5 inch
            return size * 0.55
        case 568.0: //iphone 5, 5s, SE => 4 inch
            return size * 0.64
        case 667.0: //iphone 8, 7, 6, 6s => 4.7 inch
            return size * 0.72
        case 736.0: //iphone 8s, 7s, 6s+ 6+ => 5.5 inch
            return size * 0.80
        case 812.0: //iphone 10 inch
            return size * 0.84
        case 1024.0: //iPad Retina, iPad Air, iPad Mini
            return size * 0.90
        case 1112.0: //iPad Pro 10.5
            return size * 0.94
        case 1366.0: //iPad Pro 12.9
            return size
        default:
            return 0
        }
    }

    public static func recommendedWidth(withMaxWidth size: CGFloat) -> CGFloat {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        switch width {
        case 320.0: //Iphone 3,4 5, 5s, SE => 4 inch
            return size * 0.60
        case 375.0: //iphone 10, 8, 7, 6, 6s => 4.7 inch
            return size * 0.66
        case 414.0: //iphone 8s, 7s, 6s+ 6+ => 5.5 inch
            return size * 0.72
        case 768.0: //ipad Retina, ipad Air, iPad Mini
            return size * 0.84
        case 834.0: //iPad Pro 10.5
            return size * 92
        case 1024.0: //iPad Pro 12.9
            return size
        default:
            return 0
        }
    }
    
    public func round(to places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return Darwin.round(self * divisor) / divisor
    }
    
    public static func rand() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let rand = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let minimum = min < max ? min : max 
        return  rand * Swift.abs(CGFloat( min - max)) + minimum
    }
    
    public static func distanceBetween(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        let dx : CGFloat = p1.x - p2.x
        let dy : CGFloat = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }
    
    public static func clamp(value: CGFloat, minimum:CGFloat, maximum:CGFloat) -> CGFloat {
        if value < minimum { return minimum }
        if value > maximum { return maximum }
        return value
    }
    
    public func percentageBetween(maxValue: CGFloat, minValue: CGFloat) -> CGFloat {
        let difference: CGFloat = (minValue < 0) ? maxValue : maxValue - minValue;
        return (CGFloat(100) * ((self - minValue) / difference));
    }
    
    public func percentangeFromMaxValue(withPercentage percent : CGFloat, minValue : CGFloat) -> CGFloat {
        let max = (self > minValue) ? self : minValue
        let min = (self > minValue) ? minValue : self
        
        return ( ((max - min) * percent) / CGFloat(100) ) + min
    }
}


