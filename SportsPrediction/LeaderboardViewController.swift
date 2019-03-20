//
//  LeaderboardViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/18/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var leaderBoard: UITableView!
    var users = [String]()
    var streaks = [Int]()
    var combinedUserAndStreak : [String : Int] = [:]
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardCell")
        cell!.textLabel?.text = "\(indexPath.row + 1). Streak: \(streaks[indexPath.row])   -   User: \(users[indexPath.row])"
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
            let rawData = data[users[i]]!["recordStreak"].unsafelyUnwrapped.unsafelyUnwrapped
            let rawToString = String(describing: rawData)
            let rawAsInt = Int(rawToString)
            streaks.append(rawAsInt ?? 0)
            i = i + 1
        }
        for (index, element) in users.enumerated() {
            combinedUserAndStreak[element] = streaks[index]
        }
        let sortedDict = combinedUserAndStreak.sorted(by: { $0.value > $1.value})
        users.removeAll()
        streaks.removeAll()
        var j = 0
        while j < sortedDict.count {
            users.append(sortedDict[j].key)
            streaks.append(sortedDict[j].value)
            j = j + 1
        }
        DispatchQueue.main.async {
            self.leaderBoard.reloadData()
        }
    }
    @IBAction func buttonEvent(_ sender: UIButton) {
        self.performSegue(withIdentifier: "LeaderboardToEvent", sender: self)
    }
    
    
    @IBAction func buttonProfile(_ sender: UIButton) {
        if (Auth.auth().currentUser?.email != nil) {
            self.performSegue(withIdentifier: "LeaderboardToProfile", sender: self)
        }
        else {
            let alert = UIAlertController(title:"You are not signed in!", message: "Please sign in to access profile data", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
}
