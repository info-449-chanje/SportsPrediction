//
//  EventViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/17/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var eventList: [Event] = [];
    
    @IBOutlet weak var EventTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        EventTableView.dataSource = self;
        EventTableView.delegate = self;
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
            
        }));
        alert.addAction(UIAlertAction(title: eventList[indexPath.row].teams[1].name, style: .default, handler: { action in
            
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
    
}
