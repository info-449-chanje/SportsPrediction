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

struct Games {
    var sectionName: String
    var sectionObjects: [Event]
}

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventList: [Event] = [];
    var picks: [Pick] = [];
    var gameArray: [Games] = [];
    
    @IBOutlet weak var EventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillEvents();
        EventTableView.dataSource = self;
        EventTableView.delegate = self;
      
    }
    
    func fillEvents() {
        var nbaGames: [Event] = [];
        var nflGames: [Event] = [];
        var nhlGames: [Event] = [];
        var mlbGames: [Event] = [];
        var sectionName: String = ""
        for (event) in self.eventList {
            if (event.sport_id == 2) {
                sectionName = "NFL"
                nflGames.append(event);
            } else if (event.sport_id == 4) {
                sectionName = "NBA"
                nbaGames.append(event);
            } else if (event.sport_id == 6) {
                sectionName = "NHL"
                nhlGames.append(event);
            } else {
                sectionName = "MLB"
                mlbGames.append(event);
            }
        }
        gameArray.append(Games(sectionName: sectionName, sectionObjects: nbaGames))
//        gameArray.append(Games(sectionName: sectionName, sectionObjects: nflGames));
//        gameArray.append(Games(sectionName: sectionName, sectionObjects: nhlGames))
//        gameArray.append(Games(sectionName: sectionName, sectionObjects: mlbGames))

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return gameArray.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameArray[section].sectionObjects.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")!;
        cell.textLabel?.text = gameArray[indexPath.section].sectionObjects[indexPath.row].teams[0].name + " vs. " + gameArray[indexPath.section].sectionObjects[indexPath.row].teams[1].name
//        cell.textLabel?.text = eventList[indexPath.row].teams[0].name + " vs. " + eventList[indexPath.row].teams[1].name;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return gameArray[section].sectionName;
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
    
    
}
