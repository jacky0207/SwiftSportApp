//
//  CalenderViewController.swift
//  SportApp
//
//  Created by 17200113 on 26/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

// Reference: https://medium.com/@Wei_Wei/簡單日曆-使用-swift-4-af9ef5a570f7

import UIKit
import Firebase

class CalenderViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var db: Firestore!
    
//    var really = false
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var weekDay = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    var dayWork = [Bool](repeating: false, count: 31)
    
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    
    // Today
    let thisYear = Calendar.current.component(.year, from: Date())
    let thisMonth = Calendar.current.component(.month, from: Date())
    let thisDay = Calendar.current.component(.day, from: Date())
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var calendar: UICollectionView!
    
    @IBAction func todayClicked(_ sender: Any) {
        currentYear = Calendar.current.component(.year, from: Date())
        currentMonth = Calendar.current.component(.month, from: Date())
        setUp()
    }
    
    @IBAction func lastMonth(_ sender: Any) {
        currentMonth -= 1
        if currentMonth == 0 {
            currentMonth = 12
            currentYear -= 1
        }
        setUp()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        currentMonth += 1
        if currentMonth == 13 {
            currentMonth = 1
            currentYear += 1
        }
        setUp()
    }
    
    func setUp(){
        month.text = months[currentMonth - 1] + " \(currentYear)"
        // Get mywork exist for each day
        let thisMonth = "\(currentYear)\(currentMonth)"
        let docRef = self.db.collection("record").document(UserDefaults.standard.string(forKey: "userId")!).collection(thisMonth)
        
        // Clear dayWork
        dayWork = [Bool](repeating: false, count: 31)

        docRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    let day = Int(id)!

                    self.dayWork[day-1] = true

                    // Debug
                    print("dayWork: \(day)")
                }
            }
//            self.really = true
            self.calendar.reloadData()
        }
    }
    
    var numberOfDaysInThisMonth : Int {
        let dateComponents = DateComponents(year: currentYear ,
                                            month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        let range = Calendar.current.range(of: .day, in: .month,
                                           for: date)
        return range?.count ?? 0
    }
    
    var whatDayIsIt : Int {
        let dateComponents = DateComponents(year: currentYear ,
                                            month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        return Calendar.current.component(.weekday, from: date)
    }
    
    var howManyItemsShouldIAdd:Int{ // number of day in last month
        return whatDayIsIt - 1
    }

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
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return really ? numberOfDaysInThisMonth + howManyItemsShouldIAdd : 0
        return numberOfDaysInThisMonth + howManyItemsShouldIAdd
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.size.width/7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayCell", for: indexPath)
        
        let day = indexPath.row - howManyItemsShouldIAdd + 1
        
        if let textLabel = cell.contentView.subviews[0] as? UILabel{
            if indexPath.row < howManyItemsShouldIAdd {
                textLabel.text = ""
            }
            else{
                textLabel.text = "\(day)"
                if currentYear == thisYear && currentMonth == thisMonth && day == thisDay
                {
                    textLabel.textColor = UIColor.red
                }
                else
                {
                    textLabel.textColor = UIColor.white
                }
            }
        }
        if let image = cell.contentView.subviews[1] as? UIImageView {
            if indexPath.row < howManyItemsShouldIAdd
            {
                image.isHidden = true
            }
            else
            {
                image.isHidden = !dayWork[day-1]
            }
        }
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "myWork" {
            if let viewController = segue.destination as? MyWorkTableViewController {
                let iPath = calendar.indexPathsForSelectedItems
                let indexPath : NSIndexPath = iPath![0] as NSIndexPath
                viewController.year = currentYear
                viewController.month = currentMonth
                viewController.day = indexPath.row - howManyItemsShouldIAdd + 1
                viewController.weekDay = weekDay[indexPath.row%7]
            }
        }
    }

}
