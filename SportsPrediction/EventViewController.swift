//
//  EventViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/17/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct Pick {
    let away: String;
    let date: String;
    let home: String;
    let pick: String;
    let result: Bool;
    var dictionary: [String: Any] {
        return ["away": away,
                "date": date,
                "home": home,
                "pick": pick,
                "result": result]
    }
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}

struct Games {
    var sectionName: String
    var sectionObjects: [Event]
}

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventList: [Event] = []
    var picks: [Pick]? = []
    
    var gameArray: [Games] = []
    let dateFormat = "yyyy-MM-DDHH:mm:sszzz"
    var ref: DatabaseReference!
    let email = Auth.auth().currentUser?.email
    var name = ""
    var guest = true
    
    @IBOutlet weak var EventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(email != nil){
            let emailBeforePeriod = email?.split(separator: "@")
            name = String((emailBeforePeriod?[0])!)
            ref = Database.database().reference().child("users").child(name)
            guest = false
        }
        //writeDataToPicks()
        //self.readPicksfromDatabase(completion: self.readCompletionHandler, ref: ref)
        DispatchQueue.main.async {
            self.fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/4/events?", sportId: "4")
            self.fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/2/events?", sportId: "2")
            self.fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/6/events?", sportId: "6")
            self.fetchJson("https://therundown-therundown-v1.p.rapidapi.com/sports/3/events?", sportId: "3")
            self.EventTableView.reloadData();
        }
        EventTableView.dataSource = self;
        EventTableView.delegate = self;
        //print(self.eventList)
    }
    
    func fillEvents(jsonData: [Event]) -> [Games] {
        var sportsGames: [Games] = [];
        var nbaGames: [Event] = [];
        var nflGames: [Event] = [];
        var nhlGames: [Event] = [];
        var mlbGames: [Event] = [];
        for (event) in self.eventList {
            if (event.sport_id == 2) {
                nflGames.append(event);
            } else if (event.sport_id == 4) {
                nbaGames.append(event);
            } else if (event.sport_id == 6) {
                nhlGames.append(event);
            } else {
                mlbGames.append(event);
            }
        }
        sportsGames.append(Games(sectionName: "NBA", sectionObjects: nbaGames))
        sportsGames.append(Games(sectionName: "NHL", sectionObjects: nhlGames))
        sportsGames.append(Games(sectionName: "MLB", sectionObjects: mlbGames))
        sportsGames.append(Games(sectionName: "NFL", sectionObjects: nflGames))
        return sportsGames;

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gameArray.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameArray[section].sectionObjects.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")!;
        cell.textLabel?.text = gameArray[indexPath.section].sectionObjects[indexPath.row].teams[0].name + " @ " + gameArray[indexPath.section].sectionObjects[indexPath.row].teams[1].name
//        cell.textLabel?.text = eventList[indexPath.row].teams[0].name + " vs. " + eventList[indexPath.row].teams[1].name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return gameArray[section].sectionName;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Pick a Team!", message: "Choose Between the Two Teams Below..", preferredStyle: .alert)
        var home: String = "";
        var away: String = "";
        var result: Bool = false;
        if (self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[0].is_away) {
            away = self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[0].name;
            home = self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[1].name;
        } else {
            home = self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[0].name;
            away = self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[1].name;
        }
        if(!self.guest){
            alert.addAction(UIAlertAction(title: self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[0].name , style: .default, handler:  { action in
                if(self.gameArray[indexPath.section].sectionObjects[indexPath.row].winner.name == self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[0].name){
                    result = true
                }
                let pick = Pick(away: away, date: self.gameArray[indexPath.section].sectionObjects[indexPath.row].event_date!, home: home, pick: self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[0].name, result: result)
                self.picks?.append(pick)
                self.readCurr(completion: self.currCompletionHandler, ref: self.ref, pick: pick)
                self.readPicksfromDatabase(completion: self.readCompletionHandler, ref: self.ref)
            }));
            alert.addAction(UIAlertAction(title: self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[1].name, style: .default, handler: { action in
                if(self.gameArray[indexPath.section].sectionObjects[indexPath.row].winner.name == self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[1].name){
                    result = true
                }
                let pick = Pick(away: away, date: self.gameArray[indexPath.section].sectionObjects[indexPath.row].event_date!, home: home, pick: self.gameArray[indexPath.section].sectionObjects[indexPath.row].teams[1].name, result: result);
                self.picks?.append(pick);
                self.readCurr(completion: self.currCompletionHandler, ref: self.ref, pick: pick)
                self.readPicksfromDatabase(completion: self.readCompletionHandler, ref: self.ref)
            }));
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        self.present(alert, animated: true)
    }
    
    func readCurr(completion: @escaping (Any, Pick) -> Void, ref: DatabaseReference, pick: Pick) {
        ref.child("currentStreak").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value
            completion(value, pick)
        })
    }
    
    func currCompletionHandler(data: Any, pick: Pick) {
        var curr: Int = data as! Int
        if(pick.result){
            curr = curr + 1
        } else {
            curr = 0
        }
        self.ref.child("currentStreak").setValue(curr)
    }
    
    
    func readPicksfromDatabase(completion: @escaping (NSArray) -> Void, ref: DatabaseReference) {
        ref.child("picks").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value
            if let obj = value as? NSArray {
                completion(obj)
            } else {
                self.writeDataToPicks()
                ref.child("picks").observeSingleEvent(of: .value, with: { (snapshot) in
                    let val = snapshot.value as! NSArray
                    completion(val)
                })
            }
        })
    }

    func readCompletionHandler(data:NSArray) {
        let loaded: NSArray = data as! NSArray
        var loadablePicks: [NSDictionary]? = []
        for p in loaded {
            let dict = p as! Dictionary<String,Any>
            //if let dict = p as? NSDictionary {
            // use the NSArray list here
            self.picks?.append(Pick(away: dict["away"] as! String, date: dict["date"] as! String, home: dict["home"] as! String, pick: dict["pick"] as! String, result: dict["result"] as! Bool))
            //}
        }
        for p in picks! {
            loadablePicks?.append(p.nsDictionary)
        }
        if let loadablePicks = loadablePicks,
            let list = loadablePicks as? NSArray {
            self.ref.child("picks").setValue( nil)
            self.ref.child("picks").setValue(list)
        }
    }
    
    
    func writeDataToPicks() {
        var loadablePicks: [NSDictionary]? = []
//        for p in picks! {
//            loadablePicks?.append(p.nsDictionary)
//        }
        if let loadablePicks = loadablePicks,
            let list = loadablePicks as? NSArray {
            //self.ref.setValue(["picks": nil])
            self.ref.child("picks").setValue(list)
        }
//        if let p = p,
//            list = p as? NSArray {
//            self.ref.setValue(["picks": list])
//        }
        //self.ref.setValue(["picks": p])
        
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
        var jsonData: [Event] = []
        
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
                
                for e in eventlist.events{
                    let w = self.addResult(e)
                    jsonData.append(Event(event_id: e.event_id, sport_id: e.sport_id, event_date: e.event_date, teams: e.teams, winner: w))
                }
                jsonData = self.enumDate(jsonData)
                //jsonData = self.addResult(jsonData!)
                self.eventList = self.eventList + jsonData

                self.gameArray = self.fillEvents(jsonData: self.eventList);
                DispatchQueue.main.async {
                    self.EventTableView.reloadData();
                }
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
    
    func addResult(_ e: loadEvent) -> Team{
        var i: Int = 0
        let result = Bool.random()
        if(result) {
            return e.teams[0]
        } else {
            return e.teams[1]
        }
    }
    
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
