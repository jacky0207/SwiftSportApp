//
//  TrainingViewController.swift
//  SportApp
//
//  Created by Calvin on 29/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit
import Firebase
import SwiftyTimer

class TrainingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    
    @IBOutlet weak var set: UILabel!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var countPicker: UIPickerView!

    
    
    var count = ["pullup", "pushup", "situp", "squat"]
    
    var activitySet : [Int] = [0,0,0,0,0]
    var doneSet : [Int] = [0,0,0,0,0]
    var timeSet : [Int] = [0,0,0,0,0]
    
    var countString = [String]()
    var maxCount : Int = 0
    var rest : Int = 0
    var time: Int = 0
    var currentSet : Int = 0
    var reps: Int = 0


    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stopwatch = Timer.new(every: 1.second) { (timer: Timer) in
            self.time += 1
            var min = self.time/60
            var sec = self.time%60
            var minString = "00"
            var secString = "00"
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
            self.timer.text = run
        }
        
        self.countPicker.delegate = self
        self.countPicker.dataSource = self
       
        stopwatch.start()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUp()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //print("maxCount: \(maxCount)")
        return maxCount
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        reps = Int(countString[row]) ?? 0
        return countString[row]
    }
    
    func setUp() {
        var activity = ""
        
        switch title {
            case "Pull Up":
                activity = count[0]
                break
            case "Push Up":
                activity = count[1]
                break
            case "Sit Up":
                activity = count[2]
                break
            case "Squat":
                activity = count[3]
                break
            default:
                break
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let dateString = formatter.string(from: date) //get training date
        
    
    
        //FirebaseApp.configure()
        let db = Firestore.firestore()
        
        let docRef = db.collection("account").document(UserDefaults.standard.string(forKey: "userId")!).collection("schedule").document(dateString).collection(activity).document("program")
    
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document exist")
                
                
                let data = document.data();
                
                // get data
                for index in 0...4
                {
                    self.activitySet[index] = data!["set\(index+1)"] as! Int
                }
                self.rest = data!["rest"] as! Int
                
                //print("check: \(self.activitySet)")
                print("currentSet: \(self.currentSet)")
                
                switch self.currentSet{
                case 0:
                self.set.text = "\(self.activitySet[0])-\(self.activitySet[1])-\(self.activitySet[2])-\(self.activitySet[3])-\(self.activitySet[4])"
                break;
                
                case 1:
                    self.set.text = "\(self.doneSet[0])-\(self.activitySet[1])-\(self.activitySet[2])-\(self.activitySet[3])-\(self.activitySet[4])"
                    break;
                    
                case 2:
                    self.set.text = "\(self.doneSet[0])-\(self.doneSet[1])-\(self.activitySet[2])-\(self.activitySet[3])-\(self.activitySet[4])"
                    break;
                
                case 3:
                    self.set.text = "\(self.doneSet[0])-\(self.doneSet[1])-\(self.doneSet[2])-\(self.activitySet[3])-\(self.activitySet[4])"
                    break;
                    
                case 4:
                    self.set.text = "\(self.doneSet[0])-\(self.doneSet[1])-\(self.doneSet[2])-\(self.doneSet[3])-\(self.activitySet[4])"
                    
                case 4:
                    self.set.text = "\(self.doneSet[0])-\(self.doneSet[1])-\(self.doneSet[2])-\(self.doneSet[3])-\(self.doneSet[4])"

                    
                    break;
                    
                default:
                    break;
                }
                    
                
                
                
                //self.timer.text = "\(self.rest/3600)-\(self.rest/60)-\(self.rest%60)"
            
                
                self.maxCount = self.activitySet[self.currentSet] + 10
                if(self.currentSet==0){
                    for n in 0...self.maxCount{
                        self.countString.append(String(n))
                    }
                    //print("count:\(self.countString)")
                }
                
                self.countPicker.reloadAllComponents()
                self.countPicker.selectRow(self.activitySet[self.currentSet], inComponent: 0, animated: true)
            

            } else {
                print("Document does not exist")
            }
            
        }
        
//        docRef.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            }
//            else {
//                for document in querySnapshot!.documents {
//                    let id = document.documentID
//                    let day = Int(id)!
//
//                    self.dayWork[day-1] = true
//
//                    // Debug
//                    print("dayWork: \(day)")
//                }
//            }
//            //            self.really = true
//            self.calendar.reloadData()
//        }
    }
    


    
//    func countPicker(x : Int) -> [String]{
//        count
//        return
//    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Rest" {
            if let viewController = segue.destination as? RestViewController {
                
                
                viewController.activitySet = self.activitySet
                viewController.doneSet = self.doneSet
                viewController.doneSet[self.currentSet] = reps
                viewController.timeSet = self.timeSet
                viewController.timeSet[self.currentSet] = time
                viewController.countString = self.countString
                viewController.maxCount = self.maxCount
                viewController.currentSet = self.currentSet + 1
                viewController.title = self.title
            
                
                //viewController.activitySet = setCount[setsRow]
            }
        }
    }
 

}
