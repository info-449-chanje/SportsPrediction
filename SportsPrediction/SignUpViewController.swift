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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonSignup(_ sender: UIButton) {
        if let user = textfieldEmail.text, let pass = textfieldPassword.text {
            Auth.auth().createUser(withEmail: user, password: pass, completion: { (result, error) in
                if result != nil {
                    var emailBeforePeriod = user.split(separator: ".")
                    let ref = Database.database().reference()
                    //TODO: Fix this mess
                    //ref.child("users").setValue([emailBeforePeriod[0]: ["currentStreak": 0], ["recordStreak": 0], ["win": 0], ["loss": 0]])
                    self.performSegue(withIdentifier: "SignUpToSignIn", sender: self)
                }
                else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        self.performSegue(withIdentifier: "SignUpToSignIn", sender: self)
    }
}
