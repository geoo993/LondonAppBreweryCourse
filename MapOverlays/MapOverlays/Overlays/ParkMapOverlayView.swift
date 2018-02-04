//
//  ParkMapOverlayView.swift
//  Park View
//
//  Created by GEORGE QUENTIN on 03/02/2018.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import MapKit

public class ParkMapOverlayView: MKOverlayRenderer {
    var overlayImage: UIImage
    
    public init(overlay:MKOverlay, overlayImage:UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override public func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let imageReference = overlayImage.cgImage else { return }
        
        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(imageReference, in: rect)
    }
}
