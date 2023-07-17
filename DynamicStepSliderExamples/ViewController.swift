//
//  ViewController.swift
//  DynamicStepSliderExamples
//
//  Created by Sagar on 17/7/23.
//

import UIKit
import DynamicStepSlider

class ViewController: UIViewController {
    var dynamicStepSlider : DynamicStepSlider?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDynamicStepSlider()
    }
    
    private func addDynamicStepSlider() {
        dynamicStepSlider = DynamicStepSlider(frame: .zero)
        dynamicStepSlider?.delegate = self
        dynamicStepSlider?.translatesAutoresizingMaskIntoConstraints = false
        dynamicStepSlider?.numberOfSteps = 5
        dynamicStepSlider?.sliderMinValue = 0.0
        dynamicStepSlider?.sliderMaxValue = 1.0
        dynamicStepSlider?.defaultValue = 0.5
        dynamicStepSlider?.sliderHeight = 2.0
        guard let dynamicStepSlider = dynamicStepSlider else {
            return 
        }
        view.addSubview(dynamicStepSlider)
        NSLayoutConstraint.activate([
            dynamicStepSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dynamicStepSlider.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dynamicStepSlider.widthAnchor.constraint(equalToConstant: 300.0),
            dynamicStepSlider.heightAnchor.constraint(equalToConstant: 40.0),
        ])
        dynamicStepSlider.superview?.layoutIfNeeded()
        dynamicStepSlider.setNeedsDisplay()
    }

}

extension ViewController : DynamicStepSliderDelegate {
    func dynamicStepSliderDragStart() {
        print("drag operation started")
    }
    
    func dynamicStepSliderDragCancel() {
        print("drag operation cancelled")
    }
    
    func dynamicStepSliderDragEnd() {
        print("drag operation ended")
    }
    
    func dynamicStepSliderValueChange(_ value: CGFloat) {
        print("drag operation value changed")
    }
}

