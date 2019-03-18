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
import FirebaseDatabase

struct EventList: Codable{
  let meta: Meta
  var events: [Event]
}

struct Event: Codable{
  let event_id: String
  let sport_id: Int
  var event_date: String?
  let rotation_number_away: Int
  let rotation_number_home: Int
  let teams: [Team]
  let teams_normalized: [TeamNormalized]
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

struct Meta: Codable{
  let delta_last_id: String
}

class ViewController: UIViewController {
  
  let defaults = UserDefaults.standard
  var jsonData: [Event]? = nil
  let dateFormat = "yyyy-MM-DDHH:mm:sszzz"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/4/events?")
  }
  
  func fetchJson(_ fetchUrl: String){
    let sportId = "4"
    let string = "\(fetchUrl)include=scores+or+teams+or+all_periods&sport-id=\(sportId)"
    let url = NSURL(string: string)
    let request = NSMutableURLRequest(url: url! as URL)
    
    request.setValue("*", forHTTPHeaderField: "Access-Control-Allow-Origin") //**
    request.setValue("d372d41f7fmshe392f01d3e7c6b0p13f111jsn1169de9473f3", forHTTPHeaderField: "X-RapidAPI-Key") //**
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let session = URLSession.shared
    
    let mData = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
      guard let data = data else {
        self.failDownloadAlert()
        return
      }
      do{
        let eventList = try JSONDecoder().decode(EventList.self, from: data)
        self.jsonData = eventList.events
        self.enumDate(self.jsonData!)
        print(self.jsonData)
        // print(self.jsonData ?? EventList.self)
      } catch {
        self.failDownloadAlert()
      }
    }
    mData.resume()
  }
  
  func enumDate(_ jsonData: [Event]){
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = self.dateFormat
    var i: Int = 0
    var events = jsonData
    while i < events.count{
      let zindex = events[i].event_date!.firstIndex(of: "Z")!
      var str = "\(events[i].event_date![..<zindex])PDT"
      let tindex = str.firstIndex(of: "T")!
      str.remove(at: tindex)
      events[i].event_date = str
      i = i + 1
    }
    self.jsonData = events
  }
  
  func strToDate(_ str: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = self.dateFormat
    return(dateFormatter.date(from: str)!)
  }
  
  
  @IBOutlet weak var emailTextfield: UITextField!
  @IBOutlet weak var passwordTexfield: UITextField!
  func failDownloadAlert(){
    let alert = UIAlertController(title: "Download Failed", message: "Please check internet/ data URL/ data format", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  

  @IBAction func buttonSignIn(_ sender: UIButton) {
      if let user = emailTextfield.text, let pass = passwordTexfield.text {
          Auth.auth().signIn(withEmail: user, password: pass, completion: { (u, error) in
              if u != nil {
                  let ref = Database.database().reference()
                  //print(user)
                  //ref.child("users").child("\(user)").setValue(["Streak": 0])
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

