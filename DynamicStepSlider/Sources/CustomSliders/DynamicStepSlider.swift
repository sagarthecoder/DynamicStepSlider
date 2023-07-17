//
//  DynamicStepSlider.swift
//  DynamicStepSlider
//
//  Created by Sagar on 17/7/23.
//

import UIKit

enum SliderMovingPosition {
    case middle
    case moveFromMiddleToLeft
    case moveFromMiddleToRight
}

public protocol DynamicStepSliderDelegate : AnyObject {
    func dynamicStepSliderDragStart()
    func dynamicStepSliderDragCancel()
    func dynamicStepSliderDragEnd()
    func dynamicStepSliderValueChange(_ value : CGFloat)
}

@IBDesignable
public class DynamicStepSlider: UIView {
    @IBInspectable public var numberOfSteps = 1
    @IBInspectable public var stepColor : UIColor? = UIColor.lightGray
    @IBInspectable public var sliderHeight : CGFloat = 1.5
    @IBInspectable public var stepCircleRadius : CGFloat = 6.0
    @IBInspectable public var sliderCornerRadius : CGFloat = 1.5
    @IBInspectable public var customThumbImageForNormalState : UIImage? = nil
    @IBInspectable public var selectedColor : UIColor? = .blue
    @IBInspectable public var unselectedColor : UIColor? = .gray
    @IBInspectable public var sliderMinValue : Float = 0.0
    @IBInspectable public var sliderMaxValue : Float = 1.0
    @IBInspectable public var defaultValue : CGFloat = 0.5
    
    private var slider : CustomHorizontalSlider?
    private var sliderBackgroundView : UIView?
    private var leftColorView : UIView?
    private var rightColorView : UIView?
    public weak var delegate : DynamicStepSliderDelegate?
    private var leftColorViewWidthConstraint : NSLayoutConstraint?
    private var rightColorViewWidthConstraint : NSLayoutConstraint?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func draw(_ rect: CGRect) {
        setup()
    }
    
    private func setup() {
        removeAllSubviewsFromAllDepth()
        addBackgroundView()
        addColorViews()
        addSteps()
        addSlider()
        addTargets()
    }
    
    private func addBackgroundView() {
        
        sliderBackgroundView = UIView(frame: .zero)
        sliderBackgroundView?.backgroundColor = unselectedColor
        sliderBackgroundView?.translatesAutoresizingMaskIntoConstraints = false
        guard let sliderBackgroundView = sliderBackgroundView else {
            return
        }
        addSubview(sliderBackgroundView)
        sliderBackgroundView.roundCorners(radius: sliderCornerRadius, corners: .allCorners)
        NSLayoutConstraint.activate([
            sliderBackgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            sliderBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            sliderBackgroundView.widthAnchor.constraint(equalTo: widthAnchor),
            sliderBackgroundView.heightAnchor.constraint(equalToConstant: sliderHeight),
        ])
    }
    
    private func addColorViews() {
        leftColorView = UIView(frame: .zero)
        rightColorView = UIView(frame: .zero)
        leftColorView?.translatesAutoresizingMaskIntoConstraints = false
        rightColorView?.translatesAutoresizingMaskIntoConstraints = false
        leftColorView?.backgroundColor = unselectedColor
        rightColorView?.backgroundColor = unselectedColor
        guard let leftColorView = leftColorView, let rightColorView = rightColorView else {
            return
        }
        addSubview(leftColorView)
        addSubview(rightColorView)
        let frameWidth = frame.width
        let height = sliderHeight
        leftColorViewWidthConstraint = leftColorView.widthAnchor.constraint(equalToConstant: frameWidth * 0.5)
        rightColorViewWidthConstraint = rightColorView.widthAnchor.constraint(equalToConstant: frameWidth * 0.5)
        leftColorViewWidthConstraint?.isActive = true
        rightColorViewWidthConstraint?.isActive = true
        NSLayoutConstraint.activate([
            leftColorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -frameWidth / 2.0),
            leftColorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftColorView.heightAnchor.constraint(equalToConstant: height),
            
            rightColorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: frameWidth / 2.0),
            rightColorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightColorView.heightAnchor.constraint(equalToConstant: height),
        ])
    }
    
    private func addSlider() {
        slider = CustomHorizontalSlider(frame: .zero)
        slider?.translatesAutoresizingMaskIntoConstraints = false
        if let customThumbImageForNormalState = customThumbImageForNormalState {
            slider?.setThumbImage(customThumbImageForNormalState, for: .normal)
        }
        slider?.minimumTrackTintColor = .clear
        slider?.maximumTrackTintColor = .clear
        slider?.minimumValue = sliderMinValue
        slider?.maximumValue = sliderMaxValue
        slider?.backgroundColor = .clear
        slider?.sliderHeight = sliderHeight
        slider?.value = Float(defaultValue)
        guard let slider = slider else {
            return
        }
        addSubview(slider)
        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
            slider.widthAnchor.constraint(equalTo: widthAnchor),
            slider.heightAnchor.constraint(equalTo: heightAnchor),
        ])
        slider.superview?.layoutIfNeeded()
        updateDynamicSliderValue(slider.value)
    }
    
    private func addSteps() {
        if numberOfSteps > 0 {
            let stepIndexWidth = self.frame.width / CGFloat(numberOfSteps + 1)
            for index in 1...(numberOfSteps) {
                let stepIndexView = UIView(frame: .zero)
                stepIndexView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(stepIndexView)
                let stepView = createStepView()
                stepIndexView.addSubview(stepView)
                NSLayoutConstraint.activate([
                    stepIndexView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: (stepIndexWidth * CGFloat(index)) - stepCircleRadius),
                    stepIndexView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    stepIndexView.widthAnchor.constraint(equalToConstant: stepCircleRadius * 2.0),
                    stepIndexView.heightAnchor.constraint(equalToConstant: stepCircleRadius * 2.0),
                ])
                stepIndexView.superview?.layoutIfNeeded()
            }
        }
    }
    
    private func createStepView()-> UIView {
        let stepView = UIView(frame: CGRect(x: 0, y: 0, width: self.stepCircleRadius * 2.0, height: self.stepCircleRadius * 2.0))
        stepView.backgroundColor = self.stepColor
        stepView.layer.cornerRadius = self.stepCircleRadius
        return stepView
    }
    
    public func updateDynamicSliderValue(_ value : Float) {
        guard let slider = slider else {
            return
        }
        let mid = (slider.minimumValue + slider.maximumValue) / 2.0
        slider.value = value
        if value.isEqual(to: mid) {
            updateColorWithSliderCurrentValue(.middle)
        } else if value.isLess(than: mid) {
            updateColorWithSliderCurrentValue(.moveFromMiddleToLeft)
        } else {
            updateColorWithSliderCurrentValue(.moveFromMiddleToRight)
        }
    }
    
    private func addTargets() {
        slider?.addTarget(self, action: #selector(sliderDragStart(_:)), for: .touchDown)
        slider?.addTarget(self, action: #selector(didSliderDragEnd(_:)), for: .touchUpInside)
        slider?.addTarget(self, action: #selector(didSliderDragEnd(_:)), for: .touchUpOutside)
        slider?.addTarget(self, action: #selector(didSliderDragCancel(_:)), for: .touchCancel)
        slider?.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
    }
    
    public func getDynamicStepSliderValue()-> Float? {
        return slider?.value
    }
    
    @objc private func sliderDragStart(_ slider: UISlider) {
        delegate?.dynamicStepSliderDragStart()
    }
    
    @objc private func didSliderDragEnd(_ slider: UISlider) {
        delegate?.dynamicStepSliderDragEnd()
    }
    
    @objc private func didSliderDragCancel(_ slider: UISlider) {
        delegate?.dynamicStepSliderDragCancel()
    }
    @objc private func sliderValueDidChange(_ slider : UISlider) {
        updateDynamicSliderValue(slider.value)
        delegate?.dynamicStepSliderValueChange(CGFloat(slider.value))
    }
    
    private func updateColorWithSliderCurrentValue(_ position : SliderMovingPosition) {
        guard let sliderValue = slider?.value else {
            return
        }
        let value = CGFloat(sliderValue)
        switch position {
        case .middle:
            leftColorViewWidthConstraint?.constant = 0.0
            rightColorViewWidthConstraint?.constant = 0.0
            break
        case .moveFromMiddleToLeft:
            let stepWidth = max(0.0, 0.5 - value) * frame.width
            leftColorView?.backgroundColor = selectedColor
            leftColorViewWidthConstraint?.constant = stepWidth
            rightColorViewWidthConstraint?.constant = 0.0
            break
        case .moveFromMiddleToRight:
            let stepWidth = max(0.0, value - 0.5) * frame.width
            rightColorView?.backgroundColor = selectedColor
            rightColorViewWidthConstraint?.constant = stepWidth
            leftColorViewWidthConstraint?.constant = 0.0
        }
    }
}

