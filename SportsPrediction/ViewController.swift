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


struct EventList: Codable{
    let meta: Meta
    var events: [loadEvent]
}

struct loadEvent: Codable{
    let event_id: String
    let sport_id: Int
    var event_date: String?
    let rotation_number_away: Int
    let rotation_number_home: Int
    let teams: [Team]
    let teams_normalized: [TeamNormalized]
    //var winner: Team
}

struct Event: Codable{
    let event_id: String
    let sport_id: Int
    var event_date: String?
    let teams: [Team]
    var winner: Team
}

struct Team: Codable{
    let team_id: Int
    let team_normalized_id: Int
    let is_away: Bool
    let is_home: Bool
    let name: String
}

struct TeamNormalized: Codable{
    let team_id: Int
    let name: String
    let mascot: String
    let abbreviation: String
    let is_away: Bool
    let is_home: Bool
}

struct futurePick: Codable {
  let date: String
  let home: String
  let away: String
  let pick: String
}

struct pastGame: Codable {
  let date: String
  let home: String
  let away: String
  let winner: String
  let pick: String
}

struct Meta: Codable{
    let delta_last_id: String
}

class ViewController: UIViewController, UITextFieldDelegate {
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    //fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/4/events?")
//    handle = Auth.auth().addStateDidChangeListener( { (auth, user) in
//        
//    })
  }
  
  
  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTexfield: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
  
  

  @IBAction func buttonSignIn(_ sender: UIButton) {
      if let user = emailTextfield.text, let pass = passwordTexfield.text {
          Auth.auth().signIn(withEmail: user, password: pass, completion: { (u, error) in
              if u != nil {
                  self.performSegue(withIdentifier: "LogIn", sender: self)
              }
              else {
                  self.errorLabel.text = error!.localizedDescription
                  //print(error!.localizedDescription)
              }
          })
      }

  }

  @IBAction func buttonSignUp(_ sender: UIButton) {
      self.performSegue(withIdentifier: "SignUp", sender: self)
  }

  @IBAction func buttonGuest(_ sender: UIButton) {
      Auth.auth().signInAnonymously(completion: { (authResult, error) in
        if authResult != nil {
            self.performSegue(withIdentifier: "LogIn", sender: self)
        }
        else {
            self.errorLabel.text = error!.localizedDescription
        }
      })
  }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

