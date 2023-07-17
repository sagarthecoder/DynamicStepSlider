//
//  CustomHorizontalSlider.swift
//  DynamicStepSlider
//
//  Created by Sagar on 17/7/23.
//

import UIKit

public class CustomHorizontalSlider: UISlider {
    
    var sliderHeight : CGFloat = 1.5
    public override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let point = CGPoint(x: bounds.minX, y: bounds.midY)
        return CGRect(origin: point, size: CGSize(width: bounds.width, height: sliderHeight))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

