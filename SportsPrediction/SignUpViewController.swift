//
//  SignUpViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/17/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {

    @IBOutlet weak var textfieldEmail: UITextField!
    @IBOutlet weak var textfieldPassword: UITextField!
    @IBOutlet weak var labelError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonSignup(_ sender: UIButton) {
        if let email = textfieldEmail.text, let pass = textfieldPassword.text {
            Auth.auth().createUser(withEmail: email, password: pass, completion: { (result, error) in
                if result != nil {
                    var emailBeforePeriod = email.split(separator: ".")
                    let user = String(emailBeforePeriod[0])
                    let ref = Database.database().reference()
                    ref.child("users").child(user).setValue(["currentStreak": 0, "recordStreak": 0, "wins": 0, "losses": 0])
                    self.performSegue(withIdentifier: "SignUpToSignIn", sender: self)
                }
                else {
                    self.labelError.text = error!.localizedDescription
                    //print(error!.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUpToSignIn", sender: self)
    }
}
