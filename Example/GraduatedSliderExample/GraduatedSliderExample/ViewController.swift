//
//  ViewController.swift
//  GraduatedSliderExample
//
//  Created by Sebastien Ardon on 30/8/21.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var verticalSlider: GraduatedSlider!
    @IBOutlet weak var horizontalSlider: GraduatedSlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        for slider in [verticalSlider, horizontalSlider] as [GraduatedSlider] {
            slider.addTarget(self, action: #selector(onValueChanged(_:)), for: UIControl.Event.valueChanged)
            slider.addTarget(self, action: #selector(onSliderEditingStart(_:)), for: UIControl.Event.touchDown)
            slider.addTarget(self, action: #selector(onSliderEditingStop(_:)), for: UIControl.Event.touchUpInside)
            slider.addTarget(self, action: #selector(onSliderEditingStop(_:)), for: UIControl.Event.touchUpOutside)
        }
    }

    @objc private func onValueChanged(_ sender: AnyObject) {
        guard let sender = sender as? GraduatedSlider else {
            return
        }
        
        NSLog("value: \(sender.value)")
    }

    @objc private func onSliderEditingStart(_ sender: AnyObject) {
        NSLog("slider editing start")
    }

    @objc private func onSliderEditingStop(_ sender: AnyObject) {
        NSLog("slider editing stop")
    }

}
