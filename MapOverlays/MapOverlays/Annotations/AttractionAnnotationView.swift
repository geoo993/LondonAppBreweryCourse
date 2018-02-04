//
//  AttractionAnnotationView.swift
//  Park View
//
//  Created by GEORGE QUENTIN on 03/02/2018.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import MapKit

public class AttractionAnnotationView: MKAnnotationView {
    // Required for MKAnnotationView
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let attractionAnnotation = self.annotation as? AttractionAnnotation else { return }
        
        image = attractionAnnotation.type.image()
    }
}
