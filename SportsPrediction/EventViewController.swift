//
//  EventViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/17/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseAuth

struct Pick {
    let pick: String
    var event: Event
}

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventList: [Event] = [];
    var picks: [Pick] = [];
    let dateFormat = "yyyy-MM-DDHH:mm:sszzz"
    
    @IBOutlet weak var EventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/4/events?", sportId: "4")
            self.fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/2/events?", sportId: "2")
            self.fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/6/events?", sportId: "6")
            self.fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/3/events?", sportId: "3")
        }
        EventTableView.dataSource = self;
        EventTableView.delegate = self;
        //print(self.eventList)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")!;
        cell.textLabel?.text = eventList[indexPath.row].teams[0].name + " vs. " + eventList[indexPath.row].teams[1].name ;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Pick a Team!", message: "Choose Between the Two Teams Below..", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: eventList[indexPath.row].teams[0].name , style: .default, handler:  { action in
            let pick = Pick(pick: self.eventList[indexPath.row].teams[0].name, event: self.eventList[indexPath.row])
            self.picks.append(pick);
        }));
        alert.addAction(UIAlertAction(title: eventList[indexPath.row].teams[1].name, style: .default, handler: { action in
            let pick = Pick(pick: self.eventList[indexPath.row].teams[1].name, event: self.eventList[indexPath.row])
            self.picks.append(pick);
        }));
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func buttonProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EventToProfile", sender: self)
    }
    
    @IBAction func buttonLeaderboard(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EventToLeaderboard", sender: self)
    }

    @IBAction func buttonInProgress(_ sender: UIButton) {
        self.performSegue(withIdentifier: "EventToInProgress", sender: self)
    }
    
    func fetchJson(_ fetchUrl: String, sportId: String){
        let string = "\(fetchUrl)include=scores+or+teams+or+all_periods&sport-id=\(sportId)"
        let url = NSURL(string: string)
        let request = NSMutableURLRequest(url: url! as URL)
        var jsonData: [Event]? = nil
        
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
                let eventlist = try JSONDecoder().decode(EventList.self, from: data)
                jsonData = eventlist.events
                jsonData = self.enumDate(jsonData!)
                //jsonData = self.addResult(jsonData!)
                self.eventList = self.eventList + jsonData!
                print(jsonData)
                self.EventTableView.reloadData()
                // print(self.jsonData ?? EventList.self)
            } catch {
                self.failDownloadAlert()
            }
        }
        mData.resume()
        
    }
    
    func enumDate(_ jsonData: [Event]) -> [Event]{
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
        return events
    }
    
//    func addResult(_ jsonData: [Event]) -> [Event]{
//        var i: Int = 0
//        var events = jsonData
//        while i < events.count{
//            let result = Bool.random()
//            if(result) {
//                events[i].winner = events[i].teams[0]
//            } else {
//                events[i].winner = events[i].teams[1]
//            }
//            i = i + 1
//        }
//        return events
//    }
    
    func strToDate(_ str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        return(dateFormatter.date(from: str)!)
    }
    
    func failDownloadAlert(){
        let alert = UIAlertController(title: "Download Failed", message: "Please check internet/ data URL/ data format", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
