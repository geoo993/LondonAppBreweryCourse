//
//  NSAttributedString+Ext.swift
//  StoryCore
//
//  Created by GEORGE QUENTIN on 10/01/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    
    public var attributes : [NSAttributedStringKey: Any?] {
        return self.attributes(at: 0, 
                               longestEffectiveRange: nil, 
                               in: NSRange(location: 0, length: self.length))
    }
 
    public var font : UIFont? {
        return self.attributes[NSAttributedStringKey.font] as? UIFont 
    }
    
    public var paragraphStyle: NSParagraphStyle? {
        return self.attributes[NSAttributedStringKey.paragraphStyle] as? NSParagraphStyle
    }
    
    public var lineHeight: CGFloat? {
        guard 
            let paragraphStyle = self.paragraphStyle, 
            let lineHeight = self.font?.lineHeight else { return nil }
        let lineHeightMultiple = paragraphStyle.lineHeightMultiple
        return lineHeight * ((lineHeightMultiple.isZero) ? 1 : lineHeightMultiple)
    }
    
    public var textAlignment: NSTextAlignment? {
        return paragraphStyle?.alignment
    }
    
    public var lineSpacing: CGFloat? {
        return paragraphStyle?.lineSpacing
    }
    
    public var backgroundColor: UIColor? {
        return self.attributes[NSAttributedStringKey.backgroundColor] as? UIColor
    }
    
    public var textColor: UIColor? {
        return self.attributes[NSAttributedStringKey.foregroundColor] as? UIColor
    }

    func font(at location: Int) -> UIFont? {
        if let font = 
            self.attributes(at: location, effectiveRange: nil)[NSAttributedStringKey.font] 
                as? UIFont {
            return font
        }
        return nil
    }
    
    func lineHeight(at location: Int) -> CGFloat? {
        guard let paragraphStyle = 
            self.attributes(at: location, effectiveRange: nil)[NSAttributedStringKey.paragraphStyle] 
                as? NSParagraphStyle, let font = self.font(at:location) else {
            return self.font?.lineHeight
        }
        let lineHeightMultiple = paragraphStyle.lineHeightMultiple
        return font.lineHeight * ((lineHeightMultiple.isZero) ? 1 : lineHeightMultiple)
    }
    
    func textAlignment(at location: Int) -> NSTextAlignment? {
        guard let paragraphStyle = 
            self.attributes(at: location, effectiveRange: nil)[NSAttributedStringKey.paragraphStyle] 
                as? NSParagraphStyle else {
            return nil
        }
        return paragraphStyle.alignment
    }
    
    func mutableAttributedString(from range: NSRange) -> NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self.attributedSubstring(from: range))
    }
    
    func boundingWidth(options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGFloat {
        return self.boundingRect(options: options, context: context).size.width
    }
    
    func boundingRect(options: NSStringDrawingOptions, context: NSStringDrawingContext?) -> CGRect {
        return self.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, 
                                              height: CGFloat.greatestFiniteMagnitude), 
                                 options: options, context: context)
    }
    
    func boundingRectWithSize(_ size: CGSize, 
                              options: NSStringDrawingOptions, 
                              numberOfLines: Int, 
                              context: NSStringDrawingContext?) -> CGRect? {
        guard let lineHeight = self.lineHeight else { return nil }
        let boundingRect = self.boundingRect(with: CGSize(width: size.width, 
                                                          height: lineHeight * CGFloat(numberOfLines)), 
                                             options: options, context: context)
        return boundingRect
    }

}
