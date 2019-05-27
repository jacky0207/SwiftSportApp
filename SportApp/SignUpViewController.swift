//
//  SignUpViewController.swift
//  SportApp
//
//  Created by 17200113 on 29/11/2018.
//  Copyright © 2018 17200113. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    let db = Firestore.firestore()
    
    @IBAction func confirmClicked(_ sender: Any) {
        var errorMessage = ""
        
        if name.text == "" || email.text == "" || password.text == "" || confirmPassword.text == ""
        {
            let alertController = UIAlertController(title: "Error", message: "Entering data is not yet complete.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        else if password.text != confirmPassword.text
        {
            let alertController = UIAlertController(title: "Error", message: "Password is not the same with confirm password.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authResult, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            let uid = authResult?.user.uid
            
            print("uid \(uid!)")
            
            self.db.collection("account").document(uid!).setData(
                [
                    "name": self.name.text,
                ]
            ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("User added")
                }
            }
            
            self.db.collection("record").document(uid!).setData(
                [
                    "pullup": 0,
                    "pushup": 0,
                    "situp": 0,
                ]
            ) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("User added")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
