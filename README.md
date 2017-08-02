# G8SliderStep
#### A custom range UISlider for iOS, written in Swift - Draggable, Tappable, @IBInspectable
 
  
How it works
-----
<p align="center">
<img style="-webkit-user-select: none;" src="https://github.com/gali8/G8SliderStep/raw/master/Images/G8SliderStep.gif" width="400px">
</p>
<p align="center">
<img style="-webkit-user-select: none;" src="https://github.com/gali8/G8SliderStep/raw/master/Images/Sample0.png" width="320px">
</p>

Samples
-----
<p align="center">
<img style="-webkit-user-select: none;" src="https://github.com/gali8/G8SliderStep/raw/master/Images/Sample1.png" width="320px">
</p>
<p align="center">
<img style="-webkit-user-select: none;" src="https://github.com/gali8/G8SliderStep/raw/master/Images/Sample2.png" width="320px">
</p>
<p align="center">
<img style="-webkit-user-select: none;" src="https://github.com/gali8/G8SliderStep/raw/master/Images/Sample3.png" width="320px">
</p>







Features:
-----
- Ready to use
- Easy customization (font, colors, images, ticks...)
- @IBInspectable
- Tappable
- Draggable
- Titles support
- Rotation support
- Swift 3 support

ToDo:
-----
- Add CocoaPods support

Release note:
-----
##### v2.0.1
- Master supports sliderStep.value programmatically

##### v2.0
- Swift 3 support: use branch master

##### v1.4
- Swift 2.3 support: use branch swift_2.3
- Swift 2 branch moved: use old branch swift_2.x

##### v1.1
- .ValueChanged event invoked on slider tap.

How to use:
-----
### Manual
- Import G8SliderStep.swift into you project
- Add UISlider in you Storyboard file
- Set the UISlider class to G8SliderStep
- Configure your slider by storyboard or/and by code 
- Enjoy :)

####Customizable properties
```swift
    @IBInspectable var enableTap: Bool = true
    @IBInspectable var trackHeight: Float = 4
    @IBInspectable var trackColor: UIColor = UIColor.lightGrayColor()
    @IBInspectable var drawTicks: Bool = true
    @IBInspectable var stepTickWidth: Float = 15
    @IBInspectable var stepTickHeight: Float = 15
    @IBInspectable var stepTickColor: UIColor = UIColor.lightGrayColor()
    @IBInspectable var stepTickRounded: Bool = true
    @IBInspectable var unselectedFont: UIFont = UIFont.systemFontOfSize(13)
    @IBInspectable var selectedFont: UIFont = UIFont.systemFontOfSize(13)
    @IBInspectable var stepTitlesOffset: CGFloat = 1
    
    var customTrack: Bool = true
    
    ///Requireds
    var stepImages: [UIImage]?
    
    //Optionals
    var tickTitles: [String]?
    var tickImages: [UIImage]?
```

### CocoaPods
TODO

## Requirements

* iOS 8.0+
* Xcode 7.3.1+

## Example Usage
### By Code
```swift
@IBOutlet weak var sliderStep: G8SliderStep!

override func viewDidLoad() {
        super.viewDidLoad()

///G8SliderStep configuration
	sliderStep.stepImages = [UIImage(named:"star")!, UIImage(named:"heart")!, UIImage(named:"house")!]
	sliderStep.tickTitles = ["STAR", "HEART", "HOUSE"]
	let shape = UIImage(named:"shape")!
    sliderStep.tickImages = [shape, shape, shape]
    sliderStep.minimumValue = 2
    sliderStep.maximumValue = Float(sliderStep.stepImages!.count) + sliderStep.minimumValue - 1.0
    sliderStep.trackColor = UIColor.darkGray
    sliderStep.stepTickColor = UIColor.orange
    sliderStep.stepTickWidth = 30
    sliderStep.stepTickHeight = 30
    sliderStep.trackHeight = 10
    sliderStep.value = 3
    }
```

### By Storyboard
<p align="center">
<img style="-webkit-user-select: none;" src="https://github.com/gali8/G8SliderStep/raw/master/Images/Storyboard.png" width="320px">
</p>

Buy me a beer
=================
#### If you like my work, please buy me a beer (tap the beer):
<p align="left">
<a href="http://www.g8production.com/Beer#_=_" alt="If you like my work, please buy me a beer ">
<img style="-webkit-user-select: none;" src="http://67.media.tumblr.com/3243ca9030c3fa14ca3042344ae3d510/tumblr_inline_ng26w7z8SG1qmlajm.png">
</a>
</p>

License
=================
G8SliderStep is distributed under the MIT
license (see LICENSE.md).

Contributors
=================
***Daniele Galiotto*** (founder) - iOS Freelance Developer -
**[www.g8production.com](http://www.g8production.com)**
