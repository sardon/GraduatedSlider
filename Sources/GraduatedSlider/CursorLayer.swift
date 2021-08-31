//
//  CursorLayer.swift
//  GraduatedSlider
//
//  Created by Sebastien Ardon on 8/06/2018.
//  Copyright (c) 2015 Sebastien Ardon. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

class CursorLayer: CALayer {

    var cursorColor: CGColor =  UIColor(white: 1.0, alpha: 0.7).cgColor {
        didSet {
            setNeedsDisplay()
        }
    }

    var cursorOutlineColor: CGColor = UIColor(white: 0.7, alpha: 0.64).cgColor {
        didSet {
            setNeedsDisplay()
        }
    }

    var cursorHighlightedColor: CGColor = UIColor.white.cgColor {
        didSet {
            setNeedsDisplay()
        }
    }

    var highlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var isHorizontal: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    weak var sliderControl: GraduatedSlider?

    override func draw(in ctx: CGContext) {

        var transform: CGAffineTransform = CGAffineTransform.identity
        if isHorizontal {
            transform  = CGAffineTransform(translationX: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
            let rotation: CGFloat = CGFloat(-Float.pi / 2.0)
            transform = transform.rotated(by: rotation)
            transform = transform.translatedBy(x: -bounds.size.width / 2.0, y: -bounds.size.height / 2.0)
            ctx.concatenate(transform)
        }
        let transformedRect = bounds.applying(transform)
        let rect  = transformedRect.insetBy(dx: 3.0, dy: 3.0)
        let thumbPath = UIBezierPath(roundedRect: rect, cornerRadius: 6.0)

        if highlighted {
            ctx.setFillColor(cursorHighlightedColor)
            ctx.setStrokeColor(cursorHighlightedColor)
            ctx.setLineWidth(2.0)
            ctx.addPath(thumbPath.cgPath)
            ctx.drawPath(using: CGPathDrawingMode.fillStroke)

        } else {
            ctx.setStrokeColor(cursorOutlineColor)
            ctx.setLineWidth(2.0)
            ctx.setFillColor(cursorColor)
            ctx.addPath(thumbPath.cgPath)

            ctx.drawPath(using: CGPathDrawingMode.fillStroke)
        }
    }
}
