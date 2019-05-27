//
//  MyWorkTableViewController.swift
//  SportApp
//
//  Created by 17200113 on 26/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit
import Firebase

class MyWorkTableViewController: UITableViewController {
    var year : Int = 0
    var month : Int = 0
    var day : Int = 0
    
    var weekDay : String = ""
    
    var pullupSet : [Int] = [0,0,0,0,0]
    var pushupSet : [Int] = [0,0,0,0,0]
    var situpSet : [Int] = [0,0,0,0,0]
    
    var pullupDone : [Int] = [0,0,0,0,0]
    var pushupDone : [Int] = [0,0,0,0,0]
    var situpDone : [Int] = [0,0,0,0,0]
    
    var pullup : Int = 0
    var pushup : Int = 0
    var situp : Int = 0
    
//    var really = false
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var db: Firestore!
    
    var details = [ "pullup", "pushup", "situp" ]
    
    var sections = ["Schedule", "Record"]


    @IBOutlet weak var today: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "Galaxy-S8-wallpaper-11j.jpg"))
        
        // Do any additional setup after loading the view.
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.today.text = "\(self.weekDay), \(self.day) \(self.months[self.month-1]) \(self.year)"
        RetrieveSchedule()
        RetrieveData()
    }
    
    func RetrieveSchedule()
    {
        let monthString = month < 10 ? "0\(month)" : "\(month)"
        let dayString = day < 10 ? "0\(day)" : "\(day)"
        let thisDay = "\(year)\(monthString)\(dayString)"
        
        let docRef = self.db.collection("account").document(UserDefaults.standard.string(forKey: "userId")!).collection("schedule").document(thisDay)
        
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
                
                self.tableView.reloadData()
            } else {
                print("Document does not exist in \(thisDay)")
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
                
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
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
                
                self.tableView.reloadData()
            } else {
                print("Document does not exist")
            }
        }
        
//        let docRef = self.db.collection("account").document(UserDefaults.standard.string(forKey: "userId")!).collection("schedule").document(thisDay)
//
//        docRef.getDocument { (document, error) in
//            if let document = document, document.exists {
//                print("Document exist")
//                // Get data
//                // pull up
//                var activityRef = docRef.collection("pullup")
//
//                activityRef.getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                    } else {
//                        for document in querySnapshot!.documents {
//                            let data = document.data();
//
//                            // get data
//                            for index in 0...4
//                            {
//                                self.pullupSet[index] = data["set\(index+1)"] as! Int
//                            }
//
//                            print("\(self.pullupSet)")
//
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//
//                // push up
//                activityRef = docRef.collection("pushup")
//
//                activityRef.getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                    } else {
//                        for document in querySnapshot!.documents {
//                            let data = document.data();
//
//                            // get data
//                            for index in 0...4
//                            {
//                                self.pushupSet[index] = data["set\(index+1)"] as! Int
//                            }
//
//                            print("\(self.pushupSet)")
//
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//
//                // sit up
//                activityRef = docRef.collection("situp")
//
//                activityRef.getDocuments() { (querySnapshot, err) in
//                    if let err = err {
//                        print("Error getting documents: \(err)")
//                    } else {
//                        for document in querySnapshot!.documents {
//                            let data = document.data();
//
//                            // get data
//                            for index in 0...4
//                            {
//                                self.situpSet[index] = data["set\(index+1)"] as! Int
//                            }
//
//                            print("\(self.situpSet)")
//
//                            self.tableView.reloadData()
//                        }
//                    }
//                }
//            } else {
//                print("Document does not exist")
//            }
//        }
    }
    
    func RetrieveData()
    {
        let thisMonth = "\(year)\(month)"
        let thisDay = "\(day)"
        let docRef = self.db.collection("record").document(UserDefaults.standard.string(forKey: "userId")!).collection(thisMonth).document(thisDay)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data();
                
                // Get data
                // pull up
                var activityRef = docRef.collection("pullup")
                
                activityRef.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var index = 0
                        
                        for document in querySnapshot!.documents {
                            let data = document.data();
                            
                            // get data
                            let achieved = data["achieved"] as! Bool
                            let done = data["done"] as! Int
                            
                            self.pullupDone[index] = done
                            
                            print("\(self.pullupDone[index])")
                            
                            index += 1
                        }
                        
                        self.tableView.reloadData()
                    }
                }
                
                // push up
                activityRef = docRef.collection("pushup")
                
                activityRef.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var index = 0
                        
                        for document in querySnapshot!.documents {
                            let data = document.data();
                            
                            // get data
                            let achieved = data["achieved"] as! Bool
                            let done = data["done"] as! Int
                            
                            self.pushupDone[index] = done
                            
                            print("\(self.pushupDone[index])")
                            
                            index += 1
                        }
                        
                        self.tableView.reloadData()
                    }
                }
                
                // sit up
                activityRef = docRef.collection("situp")
                
                activityRef.getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        var index = 0
                        
                        for document in querySnapshot!.documents {
                            let data = document.data();
                            
                            // get data
                            let achieved = data["achieved"] as! Bool
                            let done = data["done"] as! Int
                            
                            self.situpDone[index] = done
                            
                            print("\(self.situpDone[index])")
                            
                            index += 1
                        }
                        
                        self.tableView.reloadData()
                    }
                }
                
//                // Store data in variable
//                if let pullup = data!["pullup"] as? Int
//                {
//                    self.pullup = pullup
//                }
//                if let pushup = data!["pushup"] as? Int
//                {
//                    self.pushup = pushup
//                }
//                if let situp = data!["situp"] as? Int
//                {
//                    self.situp = situp
//                }
////                self.pullup = data!["pullup"]! as! Int
////                self.pushup = data!["pushup"]! as! Int
////                self.situp = data!["situp"]! as! Int
//
//                // Debug
//                print("pullup: \(self.pullup)")
//                print("pushup: \(self.pushup)")
//                print("situp: \(self.situp)")
            } else {
                print("Document does not exist")
            }
//            self.really = true;
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return really ? details.count : 0
        return details.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView:UIView = UIView()
//        headerView.backgroundColor = UIColor.clear
//        return headerView
//    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = .clear
        header.textLabel?.textColor = .white
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath)

        // Configure the cell...
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        cell.detailTextLabel?.textColor = UIColor.white
        
        let section = indexPath.section
        let row = indexPath.row
        let name = details[row]
        
        cell.textLabel?.text = name
        
        if (section == 0)
        {
            switch(name)
            {
                case "pullup":
                    cell.detailTextLabel?.text = "\(pullupSet[0])-\(pullupSet[1])-\(pullupSet[2])-\(pullupSet[3])-\(pullupSet[4])"
                    break
                case "pushup":
                    cell.detailTextLabel?.text = "\(pushupSet[0])-\(pushupSet[1])-\(pushupSet[2])-\(pushupSet[3])-\(pushupSet[4])"
                    break
                case "situp":
                    cell.detailTextLabel?.text = "\(situpSet[0])-\(situpSet[1])-\(situpSet[2])-\(situpSet[3])-\(situpSet[4])"
                    break
                default:
                    break
            }
        }
        else
        {
            switch(name)
            {
                case "pullup":
                    cell.detailTextLabel?.text = "\(pullupDone[0])-\(pullupDone[1])-\(pullupDone[2])-\(pullupDone[3])-\(pullupDone[4])"
                    break
                case "pushup":
                    cell.detailTextLabel?.text = "\(pushupDone[0])-\(pushupDone[1])-\(pushupDone[2])-\(pushupDone[3])-\(pushupDone[4])"
                    break
                case "situp":
                    cell.detailTextLabel?.text = "\(situpDone[0])-\(situpDone[1])-\(situpDone[2])-\(situpDone[3])-\(situpDone[4])"
                    break
                default:
                    break
            }
        }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
