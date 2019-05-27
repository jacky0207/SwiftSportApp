//
//  HomeViewController.swift
//  SportApp
//
//  Created by 17200113 on 27/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit
import Firebase
import RKPieChart

class HomePageViewController: UIViewController {
    @IBOutlet weak var welcomeMessage: UILabel!
    
    @IBOutlet weak var pullUpTotal: UILabel!
    @IBOutlet weak var pushUpTotal: UILabel!
    @IBOutlet weak var sitUpTotal: UILabel!
    
    @IBOutlet weak var pullUpDaily: UILabel!
    @IBOutlet weak var pushUpDaily: UILabel!
    @IBOutlet weak var sitUpDaily: UILabel!
    
    @IBOutlet weak var welcome: UIView!
    @IBOutlet weak var continueWorkout: UIView!
    @IBOutlet weak var dailyChallenge: UIView!
    @IBOutlet weak var dailyWorkout: UIView!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        // Hide until loaded
        self.welcome.isHidden = true
        self.continueWorkout.isHidden = true
        self.dailyWorkout.isHidden = true
        self.dailyChallenge.isHidden = true
        
        //welcomeMessage.text = "Welcome \(UserDefaults.standard.string(forKey: "name")!)"
        SetUpContinueWorkout()
        SetUpDailyWorkout()
        SetUpContinueWorkoutCompare()
    }
    
    func SetUpContinueWorkout()
    {
        let docRef = self.db.collection("record").document(UserDefaults.standard.string(forKey: "userId")!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data();
                
                // Store data in variable
                let pullup = data!["pullup"]! as! Int
                let pushup = data!["pushup"]! as! Int
                let situp = data!["situp"]! as! Int
                
                // Set data
                self.pullUpTotal.text = "\(pullup)"
                self.pushUpTotal.text = "\(pushup)"
                self.sitUpTotal.text = "\(situp)"
                
                // Debug
                print("pulluptotal: \(pullup)")
                print("pushuptotal: \(pushup)")
                print("situptotal: \(situp)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func SetUpContinueWorkoutCompare()
    {
        let docRef = self.db.collection("record")
        
        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var pullupData = [Int:Int]()
                
                for document in querySnapshot!.documents {
                    let data = document.data();
                    
                    if pullupData[data["pushup"] as! Int] != nil
                    {
                        pullupData[data["pushup"] as! Int] = pullupData[data["pushup"] as! Int]! + 1
                    }
                    else
                    {
                        pullupData[data["pushup"] as! Int] = 1
                    }
                    
//                    let firstItem: RKPieChartItem = RKPieChartItem(ratio: 50, color: UIColor.orange, title: "1️⃣th Item ")
//                    let secondItem: RKPieChartItem = RKPieChartItem(ratio: 30, color: UIColor.gray, title: "2️⃣nd Item")
//                    let thirdItem: RKPieChartItem = RKPieChartItem(ratio: 20, color: UIColor.yellow, title: "3️⃣th Item")
//
//                    let chartView = RKPieChartView(items: [firstItem, secondItem, thirdItem], centerTitle: "I am title 🕶")
//                    chartView.circleColor = .clear
//                    chartView.translatesAutoresizingMaskIntoConstraints = false
//                    chartView.arcWidth = 60
//                    chartView.isIntensityActivated = false
//                    chartView.style = .butt
//                    chartView.isTitleViewHidden = false
//                    chartView.isAnimationActivated = true
//                    self.view.addSubview(chartView)
//
//                    chartView.widthAnchor.constraint(equalToConstant: 250).isActive = true
//                    chartView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//                    chartView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//                    chartView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

                    // get data
                    print("\(data)")
                }
                
                print(pullupData)
            }
        }
    }
    
    func SetUpDailyWorkout()
    {
        // Today
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let day = Calendar.current.component(.day, from: Date())
        
        let thisMonth = "\(year)\(month)"
        let thisDay = "\(day)"
        
        let docRef = self.db.collection("record").document(UserDefaults.standard.string(forKey: "userId")!).collection(thisMonth).document(thisDay)
        
        docRef.getDocument { (document, error) in
            // Done
            if let document = document, document.exists {
                let data = document.data();
                
                // Store data in variable
                if let pullup = data!["pullup"] as? Int
                {
                    self.pullUpDaily.text = "\(pullup)"
                }
                if let pushup = data!["pushup"] as? Int
                {
                    self.pushUpDaily.text = "\(pushup)"
                }
                if let situp = data!["situp"] as? Int
                {
                    self.sitUpDaily.text = "\(situp)"
                }
                
                // Set show
                self.welcome.isHidden = false
                self.continueWorkout.isHidden = false
                self.dailyWorkout.isHidden = false
                
                // Debug
                print("pullup: \(self.pullUpDaily)")
                print("pushup: \(self.pushUpDaily)")
                print("situp: \(self.sitUpDaily)")
            }
            // Not done
            else
            {
                // Set show
                self.welcome.isHidden = false
                self.continueWorkout.isHidden = false
                self.dailyChallenge.isHidden = false
                
                // Debug
                print("Document does not exist")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
