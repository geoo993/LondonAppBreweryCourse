//
//  RoadMapView.swift
//  RoadMap
//
//  Created by GEORGE QUENTIN on 10/05/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import AppCore

@IBDesignable
public class RoadMapView: UIView {

    @IBInspectable var cycles: Int = 5 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var radius: CGFloat = 50 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var topSpacing: CGFloat = 70 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var midSpacing: CGFloat = 50 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var bottomSpacing: CGFloat = 50 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var distribution: CGFloat = 100 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var pathWidth: CGFloat = 10 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var pathColor: UIColor = UIColor.cyan {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var pathStrokeColor: UIColor = UIColor.red {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var dashLineWidth: CGFloat = 8 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var dashLineSize: CGFloat = 14 {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var dashLineColor: UIColor = UIColor.white {
        didSet {
            setupRoadMapView()
        }
    }

    @IBInspectable var background: UIColor = UIColor.white {
        didSet {
            setupRoadMapView()
        }
    }

    let pad = (left: CGFloat(0), top: CGFloat(10))
    var points: [CGPoint] = Array(repeating: .zero, count: 5)
    var counter = 0

    func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x, y: y)
    }

    func centerPointWithPad(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
        return CGPoint(x: x + bounds.midX, y: y + pad.top)
    }

    // MARK: - View Life Cycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupRoadMapView()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupRoadMapView()
    }

    public override func draw(_ rect: CGRect) {
        //super.draw(rect)
        setupRoadMapView()
        //drawArc(with: rect)
        roadMap(with: rect)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
    }

    func clearBezierView(){

        subviews.forEach({ $0.removeFromSuperview() })
        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })

    }

    func setupRoadMapView() {

    }


    func roadMap(with rect : CGRect) {

        let pi = CGFloat.pi
        let path = UIBezierPath()

        let minX = CGFloat(rect.minX), minY = rect.minY,
            midX = CGFloat(rect.midX), midY = rect.midY,
            w = rect.width, h = rect.height

        var yPosition: CGFloat = 0
        path.move(to: p(midX, minY))
        path.addLine(to: p(midX, minY + topSpacing )) // move down
        yPosition += topSpacing

        // curving from top to the left side
        path.addArc(withCenter: p(midX - radius, minY + topSpacing ), radius: radius, startAngle: 0, endAngle: pi / 2, clockwise: true)
        yPosition += radius + radius


        for i in 0..<cycles {

            // curving from left side to bottom left
            path.addArc(withCenter: p(midX - radius, minY + yPosition), radius: radius, startAngle: 3 / 2 * pi, endAngle: pi, clockwise: false)
            yPosition += midSpacing

            // curving from bottom left to the right
            path.addArc(withCenter: p(midX - radius, minY + yPosition), radius: radius, startAngle: pi, endAngle: pi / 2, clockwise: false)
            yPosition += midSpacing

            // moving to the right side
            path.addLine(to: p(midX + radius, minY + yPosition ))
            yPosition += midSpacing

            // curving from right side to bottom right
            path.addArc(withCenter: p(midX + radius, minY + yPosition), radius: radius, startAngle: 3 / 2 * pi, endAngle: 0, clockwise: true)
            yPosition += midSpacing

            // curving from bottom right to the left
            path.addArc(withCenter: p(midX + radius, minY + yPosition), radius: radius, startAngle: 0, endAngle: pi / 2, clockwise: true)
            yPosition += midSpacing

            // moving to the left side
            if i < cycles - 1 {
                path.addLine(to: p(midX - radius, minY + yPosition))
                yPosition += midSpacing
            }
        }

        path.addArc(withCenter: p(midX + radius, minY + yPosition + midSpacing), radius: radius, startAngle: 3 / 2 * pi, endAngle: pi, clockwise: false)
        yPosition += midSpacing

        path.addLine(to: p(midX, minY + yPosition + bottomSpacing )) // move down


        // path.move(to: p(-50, -50))
        // path.addLine(to: p(-100, -50))
        //path.close()
        //print(path.point(atPercentOfLength: 1))
        //path.apply(CGAffineTransform(scaleX: 1, y: -1))

//        let subpaths = path.extractSubpaths()
//        subpaths.forEach { sp in
//            sp.length
//            //print(sp, sp.length.format(Decimals.one))
//        }


        path.lineWidth = pathWidth
        pathStrokeColor.setStroke()
        path.stroke()
    }


    // MARK: - Bezier Path
    public func roadPath(bounds: CGRect) -> UIBezierPath {
        let roadPath = UIBezierPath()
        let minX = CGFloat(bounds.minX), minY = bounds.minY, w = bounds.width, h = bounds.height

        roadPath.move(to: CGPoint(x: minX + 0.50206 * w, y: minY + h))
        roadPath.addLine(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.9542 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.53094 * w, y: minY + 0.95043 * h), controlPoint1: CGPoint(x: minX + 0.50206 * w, y: minY + 0.9528 * h), controlPoint2: CGPoint(x: minX + 0.51252 * w, y: minY + 0.95144 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.60165 * w, y: minY + 0.94889 * h), controlPoint1: CGPoint(x: minX + 0.54986 * w, y: minY + 0.94945 * h), controlPoint2: CGPoint(x: minX + 0.57526 * w, y: minY + 0.94889 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.94889 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.94358 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.94889 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.9465 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.91597 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.91066 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.91303 * h), controlPoint2: CGPoint(x: minX + 0.95519 * w, y: minY + 0.91066 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.91066 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.90535 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.91066 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.90827 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.88942 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.88411 * h), controlPoint1: CGPoint(x: minX + 0.00412 * w, y: minY + 0.88648 * h), controlPoint2: CGPoint(x: minX + 0.04893 * w, y: minY + 0.88411 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.40247 * w, y: minY + 0.88411 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.8788 * h), controlPoint1: CGPoint(x: minX + 0.45725 * w, y: minY + 0.88411 * h), controlPoint2: CGPoint(x: minX + 0.50206 * w, y: minY + 0.88172 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.84827 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.60165 * w, y: minY + 0.84296 * h), controlPoint1: CGPoint(x: minX + 0.50206 * w, y: minY + 0.84532 * h), controlPoint2: CGPoint(x: minX + 0.54687 * w, y: minY + 0.84296 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.84296 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.83765 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.84296 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.84057 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.82172 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.81641 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.81878 * h), controlPoint2: CGPoint(x: minX + 0.95519 * w, y: minY + 0.81641 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.81641 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.8111 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.81641 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.81402 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.76597 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.76066 * h), controlPoint1: CGPoint(x: minX + 0.00412 * w, y: minY + 0.76302 * h), controlPoint2: CGPoint(x: minX + 0.04893 * w, y: minY + 0.76066 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.76066 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.75535 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.76066 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.75827 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.72907 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.85261 * w, y: minY + 0.7211 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.72471 * h), controlPoint2: CGPoint(x: minX + 0.93427 * w, y: minY + 0.72118 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.64696 * w, y: minY + 0.72094 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.49957 * w, y: minY + 0.71298 * h), controlPoint1: CGPoint(x: minX + 0.5653 * w, y: minY + 0.72086 * h), controlPoint2: CGPoint(x: minX + 0.49957 * w, y: minY + 0.71733 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.49957 * w, y: minY + 0.67437 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.39998 * w, y: minY + 0.66906 * h), controlPoint1: CGPoint(x: minX + 0.49957 * w, y: minY + 0.67143 * h), controlPoint2: CGPoint(x: minX + 0.45525 * w, y: minY + 0.66906 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.66906 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.66376 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.66906 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.66668 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.64198 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.63667 * h), controlPoint1: CGPoint(x: minX + 0.00412 * w, y: minY + 0.63904 * h), controlPoint2: CGPoint(x: minX + 0.04893 * w, y: minY + 0.63667 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.63667 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.63137 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.63667 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.63429 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.61544 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.61013 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.61249 * h), controlPoint2: CGPoint(x: minX + 0.95519 * w, y: minY + 0.61013 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.60165 * w, y: minY + 0.61013 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.60482 * h), controlPoint1: CGPoint(x: minX + 0.54687 * w, y: minY + 0.61013 * h), controlPoint2: CGPoint(x: minX + 0.50206 * w, y: minY + 0.60774 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.58889 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.40247 * w, y: minY + 0.58358 * h), controlPoint1: CGPoint(x: minX + 0.50206 * w, y: minY + 0.58594 * h), controlPoint2: CGPoint(x: minX + 0.45725 * w, y: minY + 0.58358 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.58358 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.57827 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.58358 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.58119 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.56234 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.55703 * h), controlPoint1: CGPoint(x: minX + 0.00412 * w, y: minY + 0.55939 * h), controlPoint2: CGPoint(x: minX + 0.04893 * w, y: minY + 0.55703 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.55703 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.55172 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.55703 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.55464 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.53579 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.53048 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.53284 * h), controlPoint2: CGPoint(x: minX + 0.95519 * w, y: minY + 0.53048 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.60165 * w, y: minY + 0.53048 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.52517 * h), controlPoint1: CGPoint(x: minX + 0.54687 * w, y: minY + 0.53048 * h), controlPoint2: CGPoint(x: minX + 0.50206 * w, y: minY + 0.52809 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.4795 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.40247 * w, y: minY + 0.47419 * h), controlPoint1: CGPoint(x: minX + 0.50206 * w, y: minY + 0.47656 * h), controlPoint2: CGPoint(x: minX + 0.45725 * w, y: minY + 0.47419 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.47419 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.46888 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.47419 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.4718 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.44127 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.43596 * h), controlPoint1: CGPoint(x: minX + 0.00412 * w, y: minY + 0.43833 * h), controlPoint2: CGPoint(x: minX + 0.04893 * w, y: minY + 0.43596 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.43596 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.43065 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.43596 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.43357 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.41472 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.40941 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.41178 * h), controlPoint2: CGPoint(x: minX + 0.95519 * w, y: minY + 0.40941 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.60165 * w, y: minY + 0.40941 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.4041 * h), controlPoint1: CGPoint(x: minX + 0.54687 * w, y: minY + 0.40941 * h), controlPoint2: CGPoint(x: minX + 0.50206 * w, y: minY + 0.40702 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.37357 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.40247 * w, y: minY + 0.36826 * h), controlPoint1: CGPoint(x: minX + 0.50206 * w, y: minY + 0.37063 * h), controlPoint2: CGPoint(x: minX + 0.45725 * w, y: minY + 0.36826 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.36826 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.36295 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.36826 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.36587 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.34702 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.34171 * h), controlPoint1: CGPoint(x: minX + 0.00412 * w, y: minY + 0.34408 * h), controlPoint2: CGPoint(x: minX + 0.04893 * w, y: minY + 0.34171 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.34171 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.3364 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.34171 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.33932 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.29127 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.28596 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.28832 * h), controlPoint2: CGPoint(x: minX + 0.95519 * w, y: minY + 0.28596 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.28596 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.28065 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.28596 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.28357 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.25437 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.15151 * w, y: minY + 0.2464 * h), controlPoint1: CGPoint(x: minX + 0.00412 * w, y: minY + 0.25001 * h), controlPoint2: CGPoint(x: minX + 0.06985 * w, y: minY + 0.24648 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.35218 * w, y: minY + 0.24598 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.49957 * w, y: minY + 0.23801 * h), controlPoint1: CGPoint(x: minX + 0.43384 * w, y: minY + 0.2459 * h), controlPoint2: CGPoint(x: minX + 0.49957 * w, y: minY + 0.24237 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.49957 * w, y: minY + 0.21109 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.59916 * w, y: minY + 0.20578 * h), controlPoint1: CGPoint(x: minX + 0.49957 * w, y: minY + 0.20815 * h), controlPoint2: CGPoint(x: minX + 0.54389 * w, y: minY + 0.20578 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.20605 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.20074 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.20605 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.20366 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.17897 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.17366 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.17602 * h), controlPoint2: CGPoint(x: minX + 0.95519 * w, y: minY + 0.17366 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.17366 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.16835 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.17366 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.17127 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.14074 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.13543 * h), controlPoint1: CGPoint(x: minX + 0.00412 * w, y: minY + 0.13779 * h), controlPoint2: CGPoint(x: minX + 0.04893 * w, y: minY + 0.13543 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.40247 * w, y: minY + 0.13543 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.13012 * h), controlPoint1: CGPoint(x: minX + 0.45725 * w, y: minY + 0.13543 * h), controlPoint2: CGPoint(x: minX + 0.50206 * w, y: minY + 0.13304 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.11419 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.60165 * w, y: minY + 0.10888 * h), controlPoint1: CGPoint(x: minX + 0.50206 * w, y: minY + 0.11124 * h), controlPoint2: CGPoint(x: minX + 0.54687 * w, y: minY + 0.10888 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.10888 * h))
        roadPath.addCurve(to: CGPoint(x: minX + w, y: minY + 0.10357 * h), controlPoint1: CGPoint(x: minX + 0.95519 * w, y: minY + 0.10888 * h), controlPoint2: CGPoint(x: minX + w, y: minY + 0.10649 * h))
        roadPath.addLine(to: CGPoint(x: minX + w, y: minY + 0.08764 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.90041 * w, y: minY + 0.08233 * h), controlPoint1: CGPoint(x: minX + w, y: minY + 0.08469 * h), controlPoint2: CGPoint(x: minX + 0.95519 * w, y: minY + 0.08233 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.10371 * w, y: minY + 0.08233 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.07702 * h), controlPoint1: CGPoint(x: minX + 0.04893 * w, y: minY + 0.08233 * h), controlPoint2: CGPoint(x: minX + 0.00412 * w, y: minY + 0.07994 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.00412 * w, y: minY + 0.06109 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.16844 * w, y: minY + 0.05578 * h), controlPoint1: CGPoint(x: minX + -0.02626 * w, y: minY + 0.05578 * h), controlPoint2: CGPoint(x: minX + 0.11976 * w, y: minY + 0.05578 * h))
        roadPath.addCurve(to: CGPoint(x: minX + 0.50206 * w, y: minY + 0.05047 * h), controlPoint1: CGPoint(x: minX + 0.45725 * w, y: minY + 0.05578 * h), controlPoint2: CGPoint(x: minX + 0.50206 * w, y: minY + 0.05339 * h))
        roadPath.addLine(to: CGPoint(x: minX + 0.50206 * w, y: minY))

        return roadPath
    }


}

