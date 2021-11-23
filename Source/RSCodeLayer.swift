//
//  RSCodeLayer.swift
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 6/13/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

import CoreGraphics
import QuartzCore

open class RSCodeLayer: CALayer {
    @objc var code: CGImage?
    
    override open func draw(in ctx: CGContext) {
        if let code = self.code {
            ctx.saveGState()
            
            ctx.draw(code, in: self.bounds)
            
            ctx.restoreGState()
        }
    }
}
