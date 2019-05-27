//
//  RestViewController.swift
//  SportApp
//
//  Created by Calvin on 30/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit

class RestViewController: UIViewController {
    @IBOutlet weak var restTimer: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var rest: Int = 15
    var activitySet : [Int] = [0,0,0,0,0]
    var doneSet : [Int] = [0,0,0,0,0]
    var timeSet : [Int] = [0,0,0,0,0]
    var countString = [String]()
    var maxCount : Int = 0
    var currentSet : Int = 0

    var timer : Timer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("doneSet")
        print(doneSet)
        
        let stopwatch = Timer.new(every: 1.second) { (timer: Timer) in
            self.rest -= 1
            var min = self.rest/60
            var sec = self.rest%60
            var minString = "00"
            var secString = "00"
            
            print(self.rest)
            if min < 10{
                minString = "0\(String(min))"
            }else{
                minString = String(min)
            }
            if sec < 10{
                secString = "0\(String(sec))"
            }else{
                secString = String(sec)
            }
            var run = "\(minString):\(secString)"
            self.restTimer.text = run
            
            self.timer = timer
            
            if( self.rest <= 0 ){
//                self.timer?.invalidate()
                
//                self.navigationController?.popViewController(animated: true)
//                let trainView = self.storyboard?.instantiateViewController(withIdentifier: "TrainingViewController") as! UIViewController
//
//                self.present(trainView, animated: true, completion: nil)
                
                self.performSegue(withIdentifier: "Training", sender: self)
            }
            
        }
        stopwatch.start()

        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Training" {
            if let viewController = segue.destination as? TrainingViewController {
                
                print("Back to previous page")
                
                // Stop counting
                self.timer?.invalidate()                
                
                viewController.activitySet = self.activitySet
                viewController.doneSet = self.doneSet
                viewController.timeSet = self.timeSet
                viewController.countString = self.countString
                viewController.maxCount = self.maxCount
                viewController.currentSet = self.currentSet
                viewController.title = self.title
                
                
                //viewController.activitySet = setCount[setsRow]
            }
        }
    }
}
