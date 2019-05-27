//
//  LoginViewController.swift
//  SportApp
//
//  Created by 17200113 on 16/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var db: Firestore!
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        // Firebase login
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            if let user = user?.user {
                print("userId: \(user.uid)")
                print("userDisplayName: \(user.displayName)")
                print("userImage: \(user.photoURL)")
                
                // Retrieve user information
                let docRef = self.db.collection("account").document(user.uid)
                
                var name : String = ""
//                var gender : String = ""
//                var age : Int = 0
                
                docRef.getDocument { (document, error) in
                    if let document = document, document.exists {
//                        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
//                        print("Document data: \(dataDescription)")
                        
                        let data = document.data();
                        
                        // Store data in variable
//                        userDetail = dataDescription.json
                        name = data!["name"]! as! String
//                        gender = data!["gender"]! as! String
//                        age = data!["age"]! as! Int
                        
                        // Further detail
                        UserDefaults.standard.set(name, forKey: "name")
//                        UserDefaults.standard.set(gender, forKey: "gender")
//                        UserDefaults.standard.set(age, forKey: "age")
                        
                        // Debug
                        print("name: \(name)")
//                        print("gender: \(gender)")
//                        print("age: \(age)")
                    } else {
                        print("Document does not exist")
                    }
                }
                
                // Login detail
                UserDefaults.standard.set(user.uid, forKey: "userId")
                UserDefaults.standard.set(user.displayName, forKey: "userDisplayName")
                UserDefaults.standard.set(user.photoURL, forKey: "userImage")
                
                self.navigationController?.popViewController(animated: true)
            }
            
//            let alertController = UIAlertController(title: "Login", message: "Successfully", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
//            self.present(alertController, animated: true, completion: nil)
            //print("asd")
            let homeView = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! UITabBarController
            //print("asd2")

            self.present(homeView, animated: true, completion: nil)
            //print("as3")

        }
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
