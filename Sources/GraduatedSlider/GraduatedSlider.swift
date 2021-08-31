//
//  GraduatedSlider.swift
//  Custom UISlider-like control with graduations
//
//  Created by Sebastien Ardon on 26/05/2018.
//  Copyright (c) 2015 Sebastien Ardon. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class GraduatedSlider: UIControl {

    /// Set to true if the slider is horizontal
    @IBInspectable open var isHorizontal: Bool = false {
        didSet {
            backgroundLayer.isHorizontal = isHorizontal
            cursorLayer.isHorizontal = isHorizontal
            updateLayerFrames()
        }
    }

    /// The slider's graduations color
    @IBInspectable open var graduationColor: UIColor = UIColor(white: 1.0, alpha: 0.7) {
        didSet {
            backgroundLayer.graduationsColor = graduationColor.cgColor
        }
    }

    /// The slider's cursor color
    @IBInspectable open var cursorColor: UIColor = UIColor(white: 0.85, alpha: 0.7) {
        didSet {
            cursorLayer.cursorColor = cursorColor.cgColor
        }
    }

    /// The slider's cursor outline color
    @IBInspectable open var cursorOutlineColor: UIColor = UIColor(white: 0.7, alpha: 0.64) {
        didSet {
            cursorLayer.cursorOutlineColor = cursorOutlineColor.cgColor
        }
    }

    /// The slider's cursor color, when higlighted (currently tracking)
    @IBInspectable open var cursorHighlightedColor: UIColor = UIColor(white: 0.7, alpha: 0.64) {
        didSet {
            cursorLayer.cursorHighlightedColor = cursorOutlineColor.cgColor
        }
    }

    /// Generate haptic feedback when passing over the graduations
    @IBInspectable open dynamic var isHapticFeedbackEnabled: Bool = true

    /// The slider minimum value
    @IBInspectable open dynamic var minimumValue: CGFloat = 0.0 {
        didSet {
            updateLayerFrames()
        }
    }

    /// The slider maximum value
    @IBInspectable open dynamic var maximumValue: CGFloat = 1.0 {
        didSet {
            updateLayerFrames()
        }
    }

    /// The slider current value
    @IBInspectable open dynamic var value: CGFloat = 0.5 {
        didSet {
            updateLayerFrames()
        }
    }

    open override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    open override var bounds: CGRect {
        didSet {
            updateLayerFrames()
        }
    }

    private let backgroundLayer = BackgroundLayer()
    private let cursorLayer = CursorLayer()
    private var previousLocation = CGPoint()
    private var feedbackGenerator: UISelectionFeedbackGenerator?

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        updateLayerFrames()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        updateLayerFrames()
    }

    private func setup() {
        backgroundColor = UIColor.clear
        backgroundLayer.backgroundColor = UIColor.clear.cgColor
        backgroundLayer.contentsScale = UIScreen.main.scale
        backgroundLayer.graduationsColor = graduationColor.cgColor

        cursorLayer.cursorOutlineColor = cursorOutlineColor.cgColor
        cursorLayer.backgroundColor = UIColor.clear.cgColor
        cursorLayer.cornerRadius = 10.0
        cursorLayer.masksToBounds = true
        cursorLayer.contentsScale = UIScreen.main.scale

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(cursorLayer)
        layer.contentsScale = UIScreen.main.scale
        updateLayerFrames()
    }

    private func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)

        backgroundLayer.frame = bounds

        let cursorPosition = CGFloat(positionForValue(value))
        if isHorizontal {
            cursorLayer.frame = CGRect(x: cursorPosition - cursorSize / 2.0,
                                       y: bounds.midY - cursorSize/2,
                                       width: cursorSize,
                                       height: cursorSize)
        } else {
            cursorLayer.frame = CGRect(x: bounds.midX - cursorSize/2,
                                       y: cursorPosition - cursorSize / 2.0,
                                       width: cursorSize,
                                       height: cursorSize)
        }
        CATransaction.commit()
    }

    private var cursorSize: CGFloat {
        return 1.2 * (isHorizontal ? bounds.height : bounds.width)
    }

    private func positionForValue(_ value: CGFloat) -> CGFloat {
        let normalisedValue = normalised(value)
        if isHorizontal {
            return (bounds.width - cursorSize) * normalisedValue + cursorSize / 2.0
        } else {
            return (bounds.height - cursorSize) * (1-normalisedValue) + (cursorSize / 2.0)
        }
    }

    private func normalised(_ value: CGFloat) -> CGFloat {
        return (value / (maximumValue - minimumValue) - minimumValue)
    }

    // MARK: UIControl

    open override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)

        if cursorLayer.frame.contains(previousLocation) {
            cursorLayer.highlighted = true
        } else {
            cursorLayer.highlighted = false
        }

        if isHapticFeedbackEnabled {
            feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator?.prepare()
        }

        return cursorLayer.highlighted
    }

    open override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let delta: CGFloat

        if isHorizontal {
            delta = (location.x - previousLocation.x) * (maximumValue - minimumValue) / (bounds.width - cursorSize)
        } else {
            delta = -(location.y - previousLocation.y) * (maximumValue - minimumValue) / (bounds.height - cursorSize)
        }

        let oldValue: CGFloat = value

        if cursorLayer.highlighted {
            value += delta
            value = value.clamped(to: minimumValue...maximumValue)
        }

        previousLocation = location
        sendActions(for: .valueChanged)

        if isHapticFeedbackEnabled {
            let graduationsCount: CGFloat = CGFloat(backgroundLayer.graduationCount)
            if trunc(normalised(oldValue) * graduationsCount) != trunc(normalised(value) * graduationsCount) {
                feedbackGenerator?.selectionChanged()
            }
        }

        return true
    }

    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        cursorLayer.highlighted = false
    }

    open override func cancelTracking(with event: UIEvent?) {
        cursorLayer.highlighted = false
    }

}

extension Comparable {

    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }

}
