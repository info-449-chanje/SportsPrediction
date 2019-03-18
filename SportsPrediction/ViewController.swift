//
//  ViewController.swift
//  SportsPrediction
//
//  Created by Nicholas S. Hytrek on 3/5/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//  TheRundown
//  API key: d372d41f7fmshe392f01d3e7c6b0p13f111jsn1169de9473f3

import UIKit
import FirebaseAuth

class ViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTexfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonSignIn(_ sender: UIButton) {
        if let user = emailTextfield.text, let pass = passwordTexfield.text {
            Auth.auth().signIn(withEmail: user, password: pass, completion: { (user, error) in
                if let u = user {
                    self.performSegue(withIdentifier: "LogIn", sender: self)
                }
                else {
                    print(error!.localizedDescription)
                }
            })
        }
        
    }
    
    @IBAction func buttonSignUp(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SignUp", sender: self)
    }
    
    @IBAction func buttonGuest(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LogIn", sender: self)
    }
}

