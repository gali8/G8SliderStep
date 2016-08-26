//
//  G8SliderStepViewController.swift
//  G8SliderStep
//
//  Created by Daniele on 25/08/16.
//  Copyright © 2016 g8production. All rights reserved.
//

import UIKit

class G8SliderStepViewController: UIViewController {
    
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
        sliderStep.trackColor = UIColor.darkGrayColor()
        sliderStep.stepTickColor = UIColor.orangeColor()
        sliderStep.stepTickWidth = 30
        sliderStep.stepTickHeight = 30
        sliderStep.trackHeight = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
