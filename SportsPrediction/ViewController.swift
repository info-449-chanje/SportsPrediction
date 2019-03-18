//
//  ViewController.swift
//  SportsPrediction
//
//  Created by Nicholas S. Hytrek on 3/5/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//  TheRundown
//  API key: d372d41f7fmshe392f01d3e7c6b0p13f111jsn1169de9473f3

import UIKit

struct EventList: Codable{
  let meta: Meta
  let events: [Event]
}

struct Event: Codable{
  let event_id: String
  let sport_id: Int
  let event_date: String
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
  var jsonData: EventList? = nil
  
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
        self.jsonData = eventList
        print(self.jsonData)
      }catch{
        self.failDownloadAlert()
      }
//      if let res = response as? HTTPURLResponse {
//        print("res: \(String(describing: res))")
//        print("data: \(String(describing: data))")
//      }else{
//        print("Error: \(String(describing: error))")
//      }
    }
    mData.resume()
  }
  
  func failDownloadAlert(){
    let alert = UIAlertController(title: "Download Failed", message: "Please check internet/ data URL/ data format", preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
  
  


}

