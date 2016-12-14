//
//  G8SliderStep.swift
//  G8SliderStep
//
//  Created by Daniele on 25/08/16.
//  Copyright © 2016 g8production. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class G8SliderStep: UISlider {
    
    @IBInspectable var enableTap: Bool = true
    @IBInspectable var trackHeight: Float = 4
    @IBInspectable var trackColor: UIColor = UIColor.lightGray
    @IBInspectable var drawTicks: Bool = true
    @IBInspectable var stepTickWidth: Float = 15
    @IBInspectable var stepTickHeight: Float = 15
    @IBInspectable var stepTickColor: UIColor = UIColor.lightGray
    @IBInspectable var stepTickRounded: Bool = true
    @IBInspectable var unselectedFont: UIFont = UIFont.systemFont(ofSize: 13)
    @IBInspectable var selectedFont: UIFont = UIFont.systemFont(ofSize: 13)
    @IBInspectable var stepTitlesOffset: CGFloat = 1
    
    var customTrack: Bool = true
    
    ///Requireds
    var stepImages: [UIImage]?
    
    //Optionals
    var tickTitles: [String]?
    var tickImages: [UIImage]?
    
    fileprivate var _stepTickLabels: [UILabel]?
    fileprivate var _stepTickImages: [UIImageView]?
    
    var stepWidth: Double {
        return Double(trackWidth) / Double(steps)
    }
    var trackWidth: CGFloat {
        return self.bounds.size.width
    }
    var trackLeftOffset: CGFloat {
        let rect = rectForValue(minimumValue)
        return rect.width / 2
    }
    var trackRightOffset: CGFloat {
        let rect = rectForValue(maximumValue)
        return rect.width / 2
    }
    var steps: Int {
        return Int(maximumValue - minimumValue)
    }
    
    override var value: Float {
        didSet {
            movingSliderStepValue()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentMode = .redraw //enable redraw on rotation (calls setNeedsDisplay)
        
        if enableTap {
            let tap = UITapGestureRecognizer(target: self, action: #selector(G8SliderStep.sliderTapped(_:)))
            self.addGestureRecognizer(tap)
        }
        
        self.addTarget(self, action: #selector(G8SliderStep.movingSliderStepValue), for: .valueChanged)
        self.addTarget(self, action: #selector(G8SliderStep.didMoveSliderStepValue), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    internal func sliderTapped(_ gestureRecognizer: UIGestureRecognizer) {
        if self.isHighlighted {
            return
        }
        
        let pointTapped: CGPoint = gestureRecognizer.location(in: self)
        let percentage = Float(pointTapped.x / trackWidth)
        let delta = percentage * (maximumValue - minimumValue)
        let newValue = minimumValue + delta
        
        self.setValue(newValue, animated: false)
        didMoveSliderStepValue(true)
    }
    
    internal func movingSliderStepValue() {
        let intValue = Int(round(self.value))
        let floatValue = Float(intValue)
        
        setThumbForSliderValue(floatValue)
    }
    
    internal func didMoveSliderStepValue(_ sendValueChangedEvent: Bool = false) {
        let intValue = Int(round(self.value))
        let floatValue = Float(intValue)
        
        UIView.animate(withDuration: 0.15, animations: {
            self.setValue(floatValue, animated: true)
        }, completion: { (fin) in
            self.setThumbForSliderValue(floatValue)
            if sendValueChangedEvent {
                self.sendActions(for: .valueChanged)
            }
        }) 
    }
    
    internal func setThumbForSliderValue(_ value: Float) {
        if let selectionImage = thumbForSliderValue(value) {
            self.setThumbImage(selectionImage, for: UIControlState())
            self.setThumbImage(selectionImage, for: UIControlState.selected)
            self.setThumbImage(selectionImage, for: UIControlState.highlighted)
        }
    }
    
    internal func thumbForSliderValue(_ value: Float) -> UIImage? {
        let intValue = Int(round(value))
        let imageIndex = intValue - Int(minimumValue)
        
        if imageIndex >= 0 && stepImages?.count > imageIndex {
            return stepImages?[imageIndex]
        }
        
        return nil
    }
    
    internal func rectForValue(_ value: Float) -> CGRect {
        let trackRect = self.trackRect(forBounds: bounds)
        let rect = thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return rect
    }
    
    override func draw(_ rect: CGRect) {
        guard minimumValue >= 0 && maximumValue > minimumValue else {
            print("G8SliderStep ERROR: minimumValue AND maximumValue need to be UInt: maximumValue < minimumValue OR minimumValue < 0 OR maximumValue < 0. EXIT.")
            return
        }
        
        guard Float(Int(self.value)) == self.value else {
            print("G8SliderStep ERROR: current/start value needs to be UInt (not Float). EXIT.")
            return
        }
        
        guard Float(Int(minimumValue)) == minimumValue && Float(Int(maximumValue)) == maximumValue else {
            print("G8SliderStep ERROR: minimumValue AND maximumValue need to be UInt (not Float). EXIT.")
            return
        }
        
        guard let images = stepImages, images.count == Int((maximumValue - minimumValue + 1)) else {
            print("G8SliderStep ERROR: images is nil OR images.count != (maximumValue - minimumValue + 1). EXIT.")
            return
        }
        
        guard tickTitles == nil || images.count == tickTitles?.count else {
            print("G8SliderStep ERROR: tickTitles is not nil OR tickTitles.count != stepImages.count. EXIT.")
            return
        }
        
        guard tickImages == nil || tickImages?.count == images.count else {
            print("G8SliderStep ERROR: tickImages is not nil OR tickImages.count != stepImages.count. EXIT.")
            return
        }
        
        guard images.count == (Int(maximumValue) - Int(minimumValue) + 1) else {
            print("G8SliderStep ERROR: Int(maximumValue) - Int(minimumValue) + 1 != images.count. EXIT.")
            return
        }
        
        setThumbForSliderValue(self.value)
        drawLabels()
        drawTrack()
        drawImages()
    }
    
    internal func drawLabels() {
        guard let ti = tickTitles else {
            return
        }
        
        if _stepTickLabels == nil {
            _stepTickLabels = []
        }
        
        if let sl = _stepTickLabels {
            for l in sl {
                l.removeFromSuperview()
            }
            _stepTickLabels?.removeAll()
            
            for index in 0..<ti.count {
                let title = ti[index]
                let lbl = UILabel()
                lbl.font = unselectedFont
                lbl.text = title
                lbl.textAlignment = .center
                lbl.sizeToFit()
                
                var offset: CGFloat = 0
                
                if index == 0 {
                    offset = trackLeftOffset
                }
                
                if index == steps {
                    offset = -trackRightOffset
                }
                
                let x = offset + CGFloat(Double(index) * stepWidth) - (lbl.frame.size.width / 2)
                var rect = lbl.frame
                rect.origin.x = x
                rect.origin.y = bounds.midY - (bounds.size.height / 2) - rect.size.height - stepTitlesOffset
                lbl.frame = rect
                self.addSubview(lbl)
                _stepTickLabels?.append(lbl)
            }
        }
    }
    
    internal func drawImages() {
        guard let ti = tickImages else {
            return
        }
        
        if _stepTickImages == nil {
            _stepTickImages = []
        }
        
        if let sl = _stepTickImages {
            for l in sl {
                l.removeFromSuperview()
            }
            _stepTickImages?.removeAll()
            
            for index in 0..<ti.count {
                let img = ti[index]
                let imv = UIImageView(image: img)
                imv.contentMode = .scaleAspectFit
                imv.sizeToFit()
                
                var offset: CGFloat = 0
                
                if index == 0 {
                    offset = trackLeftOffset
                }
                
                if index == steps {
                    offset = -trackRightOffset
                }
                
                let x = offset + CGFloat(Double(index) * stepWidth) - (imv.frame.size.width / 2)
                var rect = imv.frame
                rect.origin.x = x
                rect.origin.y = bounds.midY - (bounds.size.height / 2)
                imv.frame = rect
                self.insertSubview(imv, at: 2) //index 2 => draw images below the thumb/above the line
                _stepTickImages?.append(imv)
            }
        }
    }
    
    internal func drawTrack() {
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        
        // Remove the original track if custom
        if customTrack {
            
            // Clear original track using a transparent pixel
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
            let transparentImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            setMaximumTrackImage(transparentImage, for: UIControlState())
            setMinimumTrackImage(transparentImage, for: UIControlState())
            
            // Draw custom track
            ctx?.setFillColor(trackColor.cgColor)
            let x = trackLeftOffset
            let y = bounds.midY - CGFloat(trackHeight / 2)
            let rect = CGRect(x: x, y: y, width: bounds.width - trackLeftOffset - trackRightOffset, height: CGFloat(trackHeight))
            let trackPath = UIBezierPath(rect: rect)
            
            ctx?.addPath(trackPath.cgPath)
            ctx?.fillPath()
        }
        
        
        if drawTicks {
            // Draw ticks
            ctx?.setFillColor(stepTickColor.cgColor)
            
            for index in 0...steps {
                
                var offset: CGFloat = 0
                
                if index == 0 {
                    offset = trackLeftOffset
                }
                
                if index == steps {
                    offset = -trackRightOffset
                }
                
                let x = offset + CGFloat(Double(index) * stepWidth) - CGFloat(stepTickWidth / 2)
                let y = bounds.midY - CGFloat(stepTickHeight / 2)
                
                // Create rounded/squared tick bezier
                let stepPath: UIBezierPath
                let rect = CGRect(x: x, y: y, width: CGFloat(stepTickWidth), height: CGFloat(stepTickHeight))
                
                if customTrack && stepTickRounded {
                    let radius = CGFloat(stepTickHeight/2)
                    stepPath = UIBezierPath(roundedRect: rect, cornerRadius: radius)
                } else {
                    stepPath = UIBezierPath(rect: rect)
                }
                
                ctx?.addPath(stepPath.cgPath)
                ctx?.fillPath()
            }
        }
        
        ctx?.restoreGState()
    }
    
    //Avoid exc bad access on viewcontroller view did load
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        drawTrack()
        self.value = self.minimumValue
    }
    
}
