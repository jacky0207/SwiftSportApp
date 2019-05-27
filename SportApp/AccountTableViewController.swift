//
//  AccountTableViewController.swift
//  SportApp
//
//  Created by 17200113 on 16/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class AccountTableViewController: UITableViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var logout: UITableViewCell!
    @IBOutlet weak var editPersonalInformation: UITableViewCell!
    
    
    @IBOutlet weak var SetupNewProgram: UIView!
    
    func Logout() {
//        UserDefaults.standard.removeObject(forKey: "userId")
//        UserDefaults.standard.removeObject(forKey: "userDisplayName")
//        UserDefaults.standard.removeObject(forKey: "userImage")
//
//        UserDefaults.standard.removeObject(forKey: "username")
//        UserDefaults.standard.removeObject(forKey: "userGender")
//        UserDefaults.standard.removeObject(forKey: "userImage")
        
        do {
            try Auth.auth().signOut()            
            let LoginView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            //print("asd2")
            
            self.present(LoginView, animated: true, completion: nil)
        } catch let err {
            print(err)
        }
        
//        personalInformation.isHidden = true
//        logout.isHidden = true
//
//        let url = UserDefaults.standard.string(forKey: "userImage") ?? Optional("https://blog.xamarin.com/wp-content/uploads/2017/05/GuestLectures.png")
//
//        if let unwrappedUrl = url {
//
//            Alamofire.request(unwrappedUrl).responseData {
//                response in
//
//                if let data = response.result.value {
//                    self.image.image = UIImage(data: data, scale:1)
//                }
//            }
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "userId") == nil
        {
            editPersonalInformation.isHidden = true
            logout.isHidden = true
        }
        else
        {
           
            editPersonalInformation.isHidden = false
            logout.isHidden = false
        }
        
        let url = UserDefaults.standard.string(forKey: "userImage") ?? Optional("https://blog.xamarin.com/wp-content/uploads/2017/05/GuestLectures.png")
        
        if let unwrappedUrl = url {
            
            Alamofire.request(unwrappedUrl).responseData {
                response in
                
                if let data = response.result.value {
                    self.image.image = UIImage(data: data, scale:1)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 2)
        {
            print("Logout");
            Logout();
        }
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
