//
//  ActivityTableViewController.swift
//  SportApp
//
//  Created by Calvin on 26/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ActivityTableViewController: UITableViewController {
    let db = Firestore.firestore()
    
    var setsName : [String] = ["Pull Up", "Push Up", "Sit Up","Squat"]
    var setsExist : [Bool] = [false, false, false, false]
    var currentSet : Int = 0
    
    var pullupSet : [Int] = [0,0,0,0,0]
    var pullupTime : [Int] = [0,0,0,0,0]
    var pushupSet : [Int] = [0,0,0,0,0]
    var pushupTime : [Int] = [0,0,0,0,0]
    var situpSet : [Int] = [0,0,0,0,0]
    var situpTime : [Int] = [0,0,0,0,0]
    var squatSet : [Int] = [0,0,0,0,0]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("check2")
//        let settings = FirestoreSettings()
//        Firestore.firestore().settings = settings
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {

        print("check1")
        downloadData()
        
    }
    
    func downloadData() {
        //...
        let userId = UserDefaults.standard.string(forKey: "userId")
        var date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        var dateString = formatter.string(from: date) //get trainning date

        print("Today is \(dateString)")
        
        let docRef = db.collection("account").document(UserDefaults.standard.string(forKey: "userId")!).collection("schedule").document(dateString)
        
        // Pull up
        var activityRef = docRef.collection("pullup").document("program")
        
        activityRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document exist")
                
                let data = document.data();
                
                // get data
                for index in 0...4
                {
                    self.pullupSet[index] = data!["set\(index+1)"] as! Int
                }
                
                print("\(self.pullupSet)")
                
                self.setsExist[0] = true
                self.tableView.reloadData()
            } else {
                print("pullup does not exist")
            }
        }
        
        // Push up
        activityRef = docRef.collection("pushup").document("program")
        
        activityRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document exist")
                
                let data = document.data();
                
                // get data
                for index in 0...4
                {
                    self.pushupSet[index] = data!["set\(index+1)"] as! Int
                }
                
                print("\(self.pushupSet)")
                
                self.setsExist[1] = true
                self.tableView.reloadData()
            } else {
                print("pushup does not exist")
            }
        }
        
        // Sit up
        activityRef = docRef.collection("situp").document("program")
        
        activityRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document exist")
                
                let data = document.data();
                
                // get data
                for index in 0...4
                {
                    self.situpSet[index] = data!["set\(index+1)"] as! Int
                }
                
                print("\(self.situpSet)")
                
                self.setsExist[2] = true
                self.tableView.reloadData()
            } else {
                print("situp does not exist")
            }
        }
        
        // Squat
        activityRef = docRef.collection("squat").document("program")
        
        activityRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("squat exist")
                
                let data = document.data();
                
                // get data
                for index in 0...4
                {
                    self.squatSet[index] = data!["set\(index+1)"] as! Int
                }
                
                //print("\(self.squatSet)")
                
                self.setsExist[3] = true
                self.tableView.reloadData()
            } else {
                print("squat does not exist")
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        currentSet = 0
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var length = 0
        
        for n in 0...setsExist.count-1
        {
            if setsExist[n] == true
            {
                length += 1
            }
        }
        
        return length
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 // the height you want
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)

        // Configure the cell...
        // To exist set
        while !setsExist[currentSet]
        {
            currentSet += 1
        }
        
        switch(currentSet)
        {
            case 0:
                cell.textLabel?.text = "Pull Up"
                cell.detailTextLabel?.text = "\(pullupSet[0])-\(pullupSet[1])-\(pullupSet[2])-\(pullupSet[3])-\(pullupSet[4])"
                break
            case 1:
                cell.textLabel?.text = "Push Up"
                cell.detailTextLabel?.text = "\(pushupSet[0])-\(pushupSet[1])-\(pushupSet[2])-\(pushupSet[3])-\(pushupSet[4])"
                break
            case 2:
                cell.textLabel?.text = "Sit Up"
                cell.detailTextLabel?.text = "\(situpSet[0])-\(situpSet[1])-\(situpSet[2])-\(situpSet[3])-\(situpSet[4])"
                break
        case 3:
            cell.textLabel?.text = "Squat"
            cell.detailTextLabel?.text = "\(squatSet[0])-\(squatSet[1])-\(squatSet[2])-\(squatSet[3])-\(squatSet[4])"
            break
            default:
                break
        }
            
        // To next set
        print("print currentset: \(currentSet)")
        currentSet += 1

        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "training" {
            if let viewController = segue.destination as? TrainingViewController {
                let row = tableView.indexPathForSelectedRow!.row
                var setsRow = 0
                
                
                for _ in 0...row {
                    while !setsExist[setsRow] {
                        setsRow += 1
                    }
                }

                viewController.title = setsName[setsRow]
                print("setName: \( setsName[setsRow])")
                
                //viewController.activitySet = setCount[setsRow]
            }
        }
    }
    
    
    
    

}
