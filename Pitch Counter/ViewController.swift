//
//  ViewController.swift
//  Pitch Counter
//
//  Created by Ben Grass on 6/4/15.
//  Copyright (c) 2015 Ben Grass. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var pitchesLabel: UILabel!
    var strikeLabel: UILabel!
    var ballLabel: UILabel!
    var strikeButton: UIButton!
    var ballButton: UIButton!
    var strikePctLabel: UILabel!
    var undoLastButton: UIButton!
    var clearButton: UIButton!
    var pitches: [Int]!
    var game: NSManagedObject!
    @IBOutlet var titleBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        setUp()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func strikes() -> Int {
        return pitches.reduce(0, combine: +)
    }
    
    func balls() -> Int {
        return self.totalPitches() - self.strikes()
    }
    
    func totalPitches() -> Int {
        return pitches.count
    }
    
    func addStrike() {
        pitches.append(1)
        saveGame()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.EaseIn)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.125)
        pitchesLabel.alpha = 0
        strikeLabel.alpha = 0
        strikePctLabel.alpha = 0
        UIView.commitAnimations()
        pitchesLabel.text = totalPitches().description
        strikeLabel.text = strikes().description
        strikePctLabel.text = strikePctString()
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.EaseIn)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.125)
        pitchesLabel.alpha = 1
        strikeLabel.alpha = 1
        strikePctLabel.alpha = 1
        UIView.commitAnimations()

    }
    
    func addBall() {
        pitches.append(0)
        saveGame()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.EaseIn)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.125)
        pitchesLabel.alpha = 0
        ballLabel.alpha = 0
        strikePctLabel.alpha = 0
        UIView.commitAnimations()
        pitchesLabel.text = totalPitches().description
        ballLabel.text = balls().description
        strikePctLabel.text = strikePctString()
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.EaseIn)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.125)
        pitchesLabel.alpha = 1
        ballLabel.alpha = 1
        strikePctLabel.alpha = 1
        UIView.commitAnimations()
    }
    
    func strikePctString() -> String {
        if totalPitches() == 0 {
            return "Strike Percent: 0.00%"
        } else {
            let pct : Float = (Float(strikes()) / Float(totalPitches())) * 100.0
            if pct == 0.00 {
                return "Strike Percent: 0.00%"
            } else {
                return "Strike Percent: \(pct.string(2))%"
            }
        }
    }
    
    func undoPitch() {
        if pitches.count > 0 {
            let last = pitches.removeLast()
            saveGame()
            if last == 1 { // strike
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationCurve(.EaseIn)
                UIView.setAnimationDelegate(self)
                UIView.setAnimationDuration(0.125)
                pitchesLabel.alpha = 0
                strikeLabel.alpha = 0
                strikePctLabel.alpha = 0
                UIView.commitAnimations()
                pitchesLabel.text = totalPitches().description
                strikeLabel.text = strikes().description
                strikePctLabel.text = strikePctString()
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationCurve(.EaseIn)
                UIView.setAnimationDelegate(self)
                UIView.setAnimationDuration(0.125)
                pitchesLabel.alpha = 1
                strikeLabel.alpha = 1
                strikePctLabel.alpha = 1
                UIView.commitAnimations()
                
            } else { // ball
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationCurve(.EaseIn)
                UIView.setAnimationDelegate(self)
                UIView.setAnimationDuration(0.125)
                pitchesLabel.alpha = 0
                ballLabel.alpha = 0
                strikePctLabel.alpha = 0
                UIView.commitAnimations()
                pitchesLabel.text = totalPitches().description
                ballLabel.text = balls().description
                strikePctLabel.text = strikePctString()
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationCurve(.EaseIn)
                UIView.setAnimationDelegate(self)
                UIView.setAnimationDuration(0.125)
                pitchesLabel.alpha = 1
                ballLabel.alpha = 1
                strikePctLabel.alpha = 1
                UIView.commitAnimations()
            }
        }
        
        
    }
    
    func clear() {
        pitches.removeAll(keepCapacity: false)
        saveGame()
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.EaseIn)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.125)
        pitchesLabel.alpha = 0
        strikeLabel.alpha = 0
        ballLabel.alpha = 0
        strikePctLabel.alpha = 0
        UIView.commitAnimations()
        pitchesLabel.text = totalPitches().description
        strikeLabel.text = strikes().description
        ballLabel.text = balls().description
        strikePctLabel.text = strikePctString()
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationCurve(.EaseIn)
        UIView.setAnimationDelegate(self)
        UIView.setAnimationDuration(0.125)
        pitchesLabel.alpha = 1
        strikeLabel.alpha = 1
        ballLabel.alpha = 1
        strikePctLabel.alpha = 1
        UIView.commitAnimations()

    }
    

    
    func loadData(obj: NSManagedObject) {
        game = obj
        let pname:String = game.valueForKey("pitcher")!.valueForKey("name") as! String
        let gdate:NSDate = game.valueForKey("date") as! NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yy"
        let dateStr = dateFormatter.stringFromDate(gdate)
        titleBar.title! = "\(pname) on \(dateStr)"
    }
    
    func saveGame() {
        game.setValue(pitches, forKey: "pitches")
    }

    func setUp() {
        
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height
        pitches = game.valueForKey("pitches") as! [Int]
        
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1)
        pitchesLabel = UILabel(frame: CGRect(x: 0, y: height * 0.13, width: width, height: height * 0.2))
        pitchesLabel.text = "\(totalPitches())"
        pitchesLabel.textColor = .blackColor()
        pitchesLabel.font = UIFont.boldSystemFontOfSize(120)
        pitchesLabel.adjustsFontSizeToFitWidth  = true
        pitchesLabel.textAlignment = .Center
        view.addSubview(pitchesLabel)
        
        ballLabel = UILabel(frame: CGRect(x: width * 0.2, y: 0.36 * height, width: 0.2 * width, height: 0.1 * height))
        ballLabel.text = "\(balls())"
        ballLabel.textColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1)
        ballLabel.font = .systemFontOfSize(50)
        ballLabel.adjustsFontSizeToFitWidth = true
        ballLabel.textAlignment = .Center
        view.addSubview(ballLabel)
        
        strikeLabel = UILabel(frame: CGRect(x: width * 0.6, y: 0.36 * height, width: 0.2 * width, height: 0.1 * height))
        strikeLabel.text = "\(strikes())"
        strikeLabel.textColor = .redColor()
        strikeLabel.font = .systemFontOfSize(50)
        strikeLabel.adjustsFontSizeToFitWidth = true
        strikeLabel.textAlignment = .Center
        view.addSubview(strikeLabel)
        
        ballButton = UIButton(frame: CGRect(x: width * 0.15, y: 0.48 * height, width: 0.30 * width, height: 0.1 * height))
        ballButton.backgroundColor = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 1)
        ballButton.setTitle("Ball", forState: .Normal)
        ballButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        ballButton.layer.cornerRadius = 5
        ballButton.addTarget(self, action: "addBall", forControlEvents: .TouchUpInside)
        view.addSubview(ballButton)
        
        strikeButton = UIButton(frame: CGRect(x: width * 0.55, y: 0.48 * height, width: 0.30 * width, height: 0.1 * height))
        strikeButton.backgroundColor = .redColor()
        strikeButton.setTitle("Strike", forState: .Normal)
        strikeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        strikeButton.layer.cornerRadius = 5
        strikeButton.addTarget(self, action: "addStrike", forControlEvents: .TouchUpInside)
        view.addSubview(strikeButton)
        
        strikePctLabel = UILabel(frame: CGRect(x: width * 0.15, y: 0.63 * height, width: 0.7 * width, height: 0.05 * height))
        strikePctLabel.text = strikePctString()
        strikePctLabel.font = .systemFontOfSize(20)
        strikePctLabel.adjustsFontSizeToFitWidth = true
        strikePctLabel.textAlignment = .Center
        view.addSubview(strikePctLabel)
        
        undoLastButton = UIButton(frame: CGRect(x: width * 0.15, y: 0.72 * height, width: 0.7 * width, height: 0.07 * height))
        undoLastButton.backgroundColor = .blackColor()
        undoLastButton.setTitle("Undo Last Pitch", forState: .Normal)
        undoLastButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        undoLastButton.layer.cornerRadius = 5
        undoLastButton.addTarget(self, action: "undoPitch", forControlEvents: .TouchUpInside)
        view.addSubview(undoLastButton)
        
        clearButton = UIButton(frame: CGRect(x: width/3, y: 0.84 * height, width: width/3, height: 0.1 * height))
        clearButton.backgroundColor = .redColor()
        clearButton.setTitle("Clear", forState: .Normal)
        clearButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        clearButton.layer.cornerRadius = 5
        clearButton.addTarget(self, action: "clear", forControlEvents: .TouchUpInside)
        view.addSubview(clearButton)

    
    }

}

extension Float {
    func string(fractionDigits:Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        return formatter.stringFromNumber(self) ?? "\(self)"
    }
}


