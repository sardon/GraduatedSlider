//
//  SliderBackgroundLayer.swift
//  GraduatedSlider
//
//  Created by Sebastien Ardon on 8/06/2018.
//  Copyright (c) 2018 Sebastien Ardon. All rights reserved.
//

import UIKit
import CoreGraphics

class BackgroundLayer: CALayer {

    var graduationsColor: CGColor? {
        didSet {
            setNeedsDisplay()
        }
    }

    var isHorizontal: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var graduationCount: Int {
        majorGraduationsCount * minorGraduationsCount
    }

    private let minorGratuationLengthRatio: CGFloat = 0.7
    private let minorGraduationsCount: Int = 5
    private let majorGraduationsThickness: CGFloat = 1.0
    private let minorGraduationsThickess: CGFloat = 0.5

    private var majorGraduationsCount: Int {
        isHorizontal ? Int(bounds.width/50) : Int(bounds.height/50)
    }

    override func draw(in ctx: CGContext) {

        var transform: CGAffineTransform = .identity

        if isHorizontal {
            transform  = CGAffineTransform(translationX: bounds.size.width / 2.0,
                                           y: bounds.size.height / 2.0)
            let rotation: CGFloat = CGFloat(-Float.pi / 2.0)
            transform = transform.rotated(by: rotation)
            transform = transform.translatedBy(x: -bounds.size.width / 2.0,
                                               y: -bounds.size.height / 2.0)
            ctx.concatenate(transform)
        }

        let rect = bounds.applying(transform).insetBy(dx: 0.0, dy: 2.0)

        let majorGradudationsLength = isHorizontal ? bounds.height : bounds.width
        let majorGraduationsBeginX: CGFloat = rect.origin.x + (rect.width - majorGradudationsLength)/2
        let majorGradudationsEndX: CGFloat = majorGraduationsBeginX + majorGradudationsLength

        let minorGraduationsLength = majorGradudationsLength * minorGratuationLengthRatio
        let minorGraduationsBeginX: CGFloat = (rect.width - minorGraduationsLength)/2 + rect.origin.x
        let minorGraduationsEndX: CGFloat = minorGraduationsBeginX + minorGraduationsLength

        // draw graduations
        for i in 0..<majorGraduationsCount {

            let y: CGFloat = rect.origin.y + CGFloat(i) * rect.height / CGFloat(majorGraduationsCount)

            // major
            ctx.drawLine(start: CGPoint(x: majorGraduationsBeginX, y: y),
                         end: CGPoint(x: majorGradudationsEndX, y: y),
                         color: graduationsColor,
                         thickness: majorGraduationsThickness)

            // minor
            for j in 1..<minorGraduationsCount {
                let yMin: CGFloat = y + CGFloat(j) * (rect.height / CGFloat(majorGraduationsCount)) / CGFloat(minorGraduationsCount)
                ctx.drawLine(start: CGPoint(x: minorGraduationsBeginX, y: yMin),
                             end: CGPoint(x: minorGraduationsEndX, y: yMin),
                             color: graduationsColor,
                             thickness: minorGraduationsThickess)
                                                }

        }

        // last main graduation
        let y: CGFloat = rect.origin.y + CGFloat(majorGraduationsCount) * rect.height / CGFloat(majorGraduationsCount)
        ctx.drawLine(start: CGPoint(x: majorGraduationsBeginX, y: y),
                        end: CGPoint(x: majorGradudationsEndX, y: y),
                        color: graduationsColor,
                        thickness: majorGraduationsThickness)
    }
}
