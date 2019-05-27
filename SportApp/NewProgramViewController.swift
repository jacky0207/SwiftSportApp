//
//  NewProgramViewController.swift
//  SportApp
//
//  Created by Calvin on 28/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit
import Firebase

class NewProgramViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var maxText: UITextField!
    @IBOutlet weak var programSelect: UIPickerView!
    
    @IBAction func CancelBtn(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func AddBtn(_ sender: Any) {
        createProgram()
        dismiss(animated: true)
    }
    
    var programData: [String] = [String]()
    var addProgram: String?
    var maxReps: Int?
    let db = Firestore.firestore()
    
    
    @IBAction func changeValue(_ sender: UIStepper) {
        maxText.text = Int(sender.value).description
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.programSelect.delegate = self
        self.programSelect.dataSource = self
        programData = ["Situp", "Pushup", "Squat", "Pullup"]
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return programData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        addProgram = programData[row]
        return programData[row]
    }
    
    func createProgram(){
        maxReps = Int(maxText.text ?? "0") ?? 0
        print(addProgram ?? "error")
        print(maxReps ?? "error")
        if(maxReps ?? 0<0) {return}
        
        
        let userId = UserDefaults.standard.string(forKey: "userId")
        
        var date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        var dateString = formatter.string(from: date) //get trainning date
        
        var dateInt = Int(dateString)
        
        var set1 = maxReps ?? 0
        var set2: Int
        var set3: Int
        var set4: Int
        var set5: Int
        
//        print(dateInt)
//        print(userId)
        for day in 1...14 {
            if(day == 1 || day == 8){
                set2 = Int(floor(Float(set1) * 0.95))
                set3 = Int(floor(Float(set1) * 0.90))
                set4 = Int(floor(Float(set1) * 0.90))
                set5 = Int(floor(Float(set1) * 0.85))
                
                
                db.collection("account").document(userId ?? "0").collection("schedule").document(dateString).collection(addProgram?.lowercased() ?? "0").document("program").setData([
                "rest": 60,
                "set1time": 0,
                "set1": set1,
                "set2": set2,
                "set3": set3,
                "set4": set4,
                "set5": set5,
                
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err) on day \(day)")
                    } else {
                        print("Document added on day \(day)")
                    }
                }
                date = Date.AfterXDay(x:day)
                dateString = formatter.string(from: date)
                print("next program date: \(dateString)")
            }
            
            else if(day == 3 || day == 10){
                
                set2 = Int(floor(Float(set1) * 0.95))
                set3 = Int(floor(Float(set1) * 0.85))
                set4 = Int(floor(Float(set1) * 0.95))
                set5 = Int(floor(Float(set1) * 0.90))
                db.collection("account").document(userId ?? "0").collection("schedule").document(dateString).collection(addProgram?.lowercased() ?? "0").document("program").setData([
                    "rest": 60,
                    "set1time": 0,
                    "set1": set1,
                    "set2": set2,
                    "set3": set3,
                    "set4": set4,
                    "set5": set5,
                    
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err) on day \(day)")
                        } else {
                            print("Document added on day \(day)")
                        }
                }
                date = Date.AfterXDay(x:day)
                dateString = formatter.string(from: date)
                print("next program date: \(dateString)")
            }
            
            
            else if(day == 5 || day == 12){
                
                set2 = Int(floor(Float(set1) * 0.95))
                set3 = Int(floor(Float(set1) * 0.95))
                set4 = Int(floor(Float(set1) * 0.90))
                set5 = Int(floor(Float(set1) * 0.90))
                
                db.collection("account").document(userId ?? "0").collection("schedule").document(dateString).collection(addProgram?.lowercased() ?? "0").document("program").setData([
                    "rest": 60,
                    "set1time": 0,
                    "set1": set1,
                    "set2": set2,
                    "set3": set3,
                    "set4": set4,
                    "set5": set5,
                    
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err) on day \(day)")
                        } else {
                            print("Document added on day \(day)")
                            
                        }
                    }
                set1 = set1 + 1
                date = Date.AfterXDay(x:day)
                dateString = formatter.string(from: date)
                print("next program date: \(dateString)")
                
            }else{
                
                date = Date.AfterXDay(x:day)
                dateString = formatter.string(from: date)
                print("rest on date: \(dateString)")
                
                db.collection("account").document(userId ?? "0").collection("schedule").document(dateString).collection(addProgram?.lowercased() ?? "0").document("program").setData([
                    "rest": 1000,

                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err) on day \(day)")
                        } else {
                            print("Document added on day \(day)")
                            
                        }
                }
                
            }
            
            
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension Date {
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    static var After2Day: Date {
        return Calendar.current.date(byAdding: .day, value: 2, to: Date().noon)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    static var After3Day: Date {
        return Calendar.current.date(byAdding: .day, value: 3, to: Date().noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    static func AfterXDay(x : Int) -> Date{
        return Calendar.current.date(byAdding: .day, value: x, to: Date().noon)!
    }
}

