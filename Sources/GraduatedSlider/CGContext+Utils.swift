//
//  CGContext+Utils.swift
//  GraduatedSliderExample
//
//  Created by Sebastien Ardon on 8/06/2018.
//  Copyright (c) 2015 Sebastien Ardon. All rights reserved.
//

import UIKit
import CoreGraphics

extension CGContext {

    func drawLine(start: CGPoint,
                  end: CGPoint,
                  color: CGColor?,
                  thickness: CGFloat) {

        saveGState()
        setLineCap(CGLineCap.square)
        if let color = color {
            setStrokeColor(color)
        }
        setLineWidth(thickness)
        move(to: CGPoint(x: start.x + 0.5, y: start.y + 0.5))
        addLine(to: CGPoint(x: end.x + 0.5, y: end.y + 0.5))
        strokePath()
        restoreGState()
    }

    func drawCircle(rect: CGRect,
                    thickness: CGFloat,
                    color: CGColor?,
                    fill: Bool) {
        saveGState()
        if let color = color {
            setStrokeColor(color)
            if fill {
                setFillColor(color)
            }
        }
        setLineWidth(thickness)
        addEllipse(in: rect)
        if fill {
            fillPath()
        }
        strokePath()
        restoreGState()
    }
}
