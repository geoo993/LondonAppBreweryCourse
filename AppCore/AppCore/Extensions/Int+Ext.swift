import Foundation

struct Number {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "," // or possibly "." / "," / " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

public extension Int {
    
    public var degreesToRadians: Double { return Double(self) * .pi / 180 }
    
    public var stringWithSepator: String {
        return Number.withSeparator.string(from: NSNumber(value: hashValue)) ?? ""
    }
    
    public static func random(min: Int, max: Int) -> Int {
        guard min < max else {return min}
        return Int(arc4random_uniform(UInt32(1 + max - min))) + min
    }
    
}
