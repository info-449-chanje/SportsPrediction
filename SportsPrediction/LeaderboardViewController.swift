//
//  LeaderboardViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/18/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseDatabase

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var leaderBoard: UITableView!
    var users = [String]()
    var streaks = [Any]()
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell")
        cell!.textLabel?.text = users[indexPath.row]
        return cell!
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        leaderBoard.dataSource = self
        leaderBoard.delegate = self
        createTopUsers(completion: self.completionHandler)
        // Do any additional setup after loading the view.
    }
    
    func createTopUsers(completion: @escaping ([String: AnyObject]) -> Void) {
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! [String: AnyObject]
            completion(value)
        })
    }
    
    func completionHandler(data: [String: AnyObject]) {
        for (key, value) in data {
            users.append(key)
        }
        var i = 0
        while i < users.count {
            streaks.append(data[users[i]]!["recordStreak"].unsafelyUnwrapped.unsafelyUnwrapped)
            i = i + 1
        }
        print(streaks)
        
//        let a = data[users[0]]!["recordStreak"].unsafelyUnwrapped.unsafelyUnwrapped
//        print(a)
//
        
        DispatchQueue.main.async {
            self.leaderBoard.reloadData()
        }
    }
    @IBAction func buttonEvent(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LeaderboardToEvent", sender: self)
    }
    
    @IBAction func buttonProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LeaderboardToProfile", sender: self)
    }
    
    
}
