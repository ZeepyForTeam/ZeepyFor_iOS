//
//  RangeSlider.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/05/03.
//

import UIKit

class RangeSlider: UIControl {
  override var frame: CGRect {
    didSet {
      updateLayerFrames()
    }
  }
  
  var minimumValue: CGFloat = 0 {
    didSet {
      updateLayerFrames()
    }
  }
  
  var maximumValue: CGFloat = 1 {
    didSet {
      updateLayerFrames()
    }
  }
  
  var lowerValue: CGFloat = 0.2 {
    didSet {
      updateLayerFrames()
    }
  }
  
  var upperValue: CGFloat = 0.8 {
    didSet {
      updateLayerFrames()
    }
  }
  
  var trackTintColor = UIColor(white: 0.9, alpha: 1) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }
  
  var trackHighlightTintColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 1) {
    didSet {
      trackLayer.setNeedsDisplay()
    }
  }
  
  var thumbImage = UIImage(named: "togglePriceMedium") {
    didSet {
      upperThumbImageView.image = thumbImage
      lowerThumbImageView.image = thumbImage
      updateLayerFrames()
    }
  }
  
  var highlightedThumbImage = UIImage(named: "togglePriceMedium") {
    didSet {
      upperThumbImageView.highlightedImage = highlightedThumbImage
      lowerThumbImageView.highlightedImage = highlightedThumbImage
      updateLayerFrames()
    }
  }
  
  
  private let trackLayer = RangeSliderTrackLayer()
  private let lowerThumbImageView = UIImageView()
  private let upperThumbImageView = UIImageView()
  private var previousLocation = CGPoint()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    trackLayer.rangeSlider = self
    trackLayer.contentsScale = UIScreen.main.scale
    layer.addSublayer(trackLayer)
    
    lowerThumbImageView.image = thumbImage
    addSubview(lowerThumbImageView)
    
    upperThumbImageView.image = thumbImage
    addSubview(upperThumbImageView)
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // 1
  private func updateLayerFrames() {
    CATransaction.begin()
    CATransaction.setDisableActions(true)

    trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
    trackLayer.setNeedsDisplay()
    lowerThumbImageView.frame = CGRect(origin: thumbOriginForValue(lowerValue),
                                       size: thumbImage!.size)
    upperThumbImageView.frame = CGRect(origin: thumbOriginForValue(upperValue),
                                       size: thumbImage!.size)
    CATransaction.commit()
  }
  // 2
  func positionForValue(_ value: CGFloat) -> CGFloat {
    return bounds.width * value
  }
  // 3
  private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
    let x = positionForValue(value) - thumbImage!.size.width / 2.0
    return CGPoint(x: x, y: (bounds.height - thumbImage!.size.height) / 2.0)
  }
}

extension RangeSlider {
  override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    // 1
    previousLocation = touch.location(in: self)
    
    // 2
    if lowerThumbImageView.frame.contains(previousLocation) {
      lowerThumbImageView.isHighlighted = true
    } else if upperThumbImageView.frame.contains(previousLocation) {
      upperThumbImageView.isHighlighted = true
    }
    print("begin")
    // 3
    return lowerThumbImageView.isHighlighted || upperThumbImageView.isHighlighted
  }
  
  override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
    let location = touch.location(in: self)
    
    // 1
    let deltaLocation = location.x - previousLocation.x
    let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width
    
    previousLocation = location
    
    // 2
    if lowerThumbImageView.isHighlighted {
      lowerValue += deltaValue
      lowerValue = boundValue(lowerValue, toLowerValue: minimumValue,
                              upperValue: upperValue)
    } else if upperThumbImageView.isHighlighted {
      upperValue += deltaValue
      upperValue = boundValue(upperValue, toLowerValue: lowerValue,
                              upperValue: maximumValue)
    }
    
    sendActions(for: .valueChanged)
    print("continue")
    return true
  }
  
  override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
    lowerThumbImageView.isHighlighted = false
    upperThumbImageView.isHighlighted = false
    
    print("end")
  }
  
  // 4
  private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat, upperValue: CGFloat) -> CGFloat {
    return min(max(value, lowerValue), upperValue)
  }
}
