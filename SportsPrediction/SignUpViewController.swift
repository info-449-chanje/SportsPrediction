//
//  SignUpViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/17/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseAuth

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
