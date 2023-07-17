# DynamicStepSlider

[![Version](https://img.shields.io/cocoapods/v/DynamicStepSlider.svg?style=flat)](https://cocoapods.org/pods/DynamicStepSlider)
[![License](https://img.shields.io/cocoapods/l/DynamicStepSlider.svg?style=flat)](https://cocoapods.org/pods/DynamicStepSlider)
[![Platform](https://img.shields.io/cocoapods/p/DynamicStepSlider.svg?style=flat)](https://cocoapods.org/pods/DynamicStepSlider)

## Summary
This library helps to create circular steps inside Slider dynamically. It sets circular steps from the middle of the Slider (excluding the last side of both directions) maintaining equal space.


### Slider With `n` step
`n = 3`
![](https://media.giphy.com/media/m2h5qGLIEjYBeNnGVW/giphy.gif)

`n = 5`
![](https://media.giphy.com/media/nmCdD9P7pD1x1Xvm6G/giphy.gif)

## Requirements

- iOS 11.0+
- Interoperability with Swift 5.0+

## Installation
### CocoaPods

DynamicStepSlider is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DynamicStepSlider'
```

## Usage
Create an instance  (in interface builder or programmatically) of the `DynamicStepSlider` and add it to your view hierarchy.
## Customization
``` swift
    // dynamicStepSlider is an instance of `DynamicStepSlider`
    dynamicStepSlider.numberOfSteps = 1 // default 1. It should be a positive odd Integer number 
    dynamicStepSlider.stepColor = .lightGray // default is lightGray.
    dynamicStepSlider.sliderHeight = 1.5 // height if the Slider
    dynamicStepSlider.stepCircleRadius = 6.0 // radius of Circular Step
    dynamicStepSlider.sliderCornerRadius = 1.5 // corner radius of Slider
    dynamicStepSlider.customThumbImageForNormalState = nil // default is nil. nil refers to the default thumb image provided by UISlider.
    dynamicStepSlider.selectedColor = .blue // color of dragging area
    dynamicStepSlider.unselectedColor = .gray // color of excluded-dragging area
    dynamicStepSlider.sliderMinValue  = 0.0 // Slider's minimum value
    dynamicStepSlider.sliderMaxValue = 1.0 // Slider's maximum value
    dynamicStepSlider.defaultValue = 0.5 // Slider's default value
```
### It's also possible to set the above customizations inside Xib
`It's necessary to add the following line when you modify any properties to get expected behavior.`
``` swift
dynamicStepSlider.setNeedsDisplay()
```
`For getting current Slider value you need to call`
``` swift
dynamicStepSlider.getDynamicStepSliderValue()
```
By conforming `DynamicStepSliderDelegate ` you'll get the information about when Slider's dragging is started, value changed, canceled, and ended. For better understanding please see the example project.
to get conforming results simply add this
``` swift
dynamicStepSlider.delegate = self
```

## Author

Sagar Chandra Das, sagarthecoder@gmail.com

## License

DynamicStepSlider is available under the MIT license. See the LICENSE file for more info.
