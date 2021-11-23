//
//  RSFocusMarkLayer.swift
//  RSBarcodesSample
//
//  Created by R0CKS/Users/maustin/GitHub/RSBarcodes_Swift/Source/RSFocusMarkLayer.swift:25:42: Missing argument label 'rgba_throws:' in callTAR on 6/13/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

import CoreGraphics
import QuartzCore

#if os(macOS)
import AppKit
#else
import UIKit
#endif

open class RSFocusMarkLayer: CALayer {
    // Use camera.app's focus mark size as default
    @objc open var size = CGSize(width: 76, height: 76)
    // Use camera.app's focus mark sight as default
    @objc open var sight: CGFloat = 6
    // Use camera.app's focus mark color as default
    @objc open var strokeColor = try! RSColor(rgba_throws: "#ffcc00").cgColor
    @objc open var strokeWidth: CGFloat = 1
    @objc open var delay: CFTimeInterval = 1
    @objc open var canDraw = false
    
    @objc open var point : CGPoint = CGPoint(x: 0, y: 0) {
        didSet {
            DispatchQueue.main.async(execute: {
                self.canDraw = true
                self.setNeedsDisplay()
            })
            
            let when = DispatchTime.now() + Double(Int64(self.delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.canDraw = false
                self.setNeedsDisplay()
            })
        }
    }
    
    override open func draw(in ctx: CGContext) {
        if !self.canDraw {
            return
        }
        
        ctx.saveGState()
        
        ctx.setShouldAntialias(true)
        ctx.setAllowsAntialiasing(true)
        ctx.setFillColor(CGColor.clear)
        ctx.setStrokeColor(self.strokeColor)
        ctx.setLineWidth(self.strokeWidth)
        
        // Rect
        ctx.stroke(CGRect(x: self.point.x - self.size.width / 2.0, y: self.point.y - self.size.height / 2.0, width: self.size.width, height: self.size.height))
        
        // Focus
        for i in 0..<4 {
            var endPoint: CGPoint
            switch i {
            case 0:
                ctx.move(to: CGPoint(x: self.point.x, y: self.point.y - self.size.height / 2.0))
                endPoint = CGPoint(x: self.point.x, y: self.point.y - self.size.height / 2.0 + self.sight)
            case 1:
                ctx.move(to: CGPoint(x: self.point.x, y: self.point.y + self.size.height / 2.0))
                endPoint = CGPoint(x: self.point.x, y: self.point.y + self.size.height / 2.0 - self.sight)
            case 2:
                ctx.move(to: CGPoint(x: self.point.x - self.size.width / 2.0, y: self.point.y))
                endPoint = CGPoint(x: self.point.x - self.size.width / 2.0 + self.sight, y: self.point.y)
            case 3:
                ctx.move(to: CGPoint(x: self.point.x + self.size.width / 2.0, y: self.point.y))
                endPoint = CGPoint(x: self.point.x + self.size.width / 2.0 - self.sight, y: self.point.y)
            default:
                endPoint = CGPoint(x: 0, y: 0)
            }
            ctx.addLine(to: CGPoint(x: endPoint.x, y: endPoint.y))
        }
        
        ctx.drawPath(using: CGPathDrawingMode.fillStroke)
        
        ctx.restoreGState()
    }
}
