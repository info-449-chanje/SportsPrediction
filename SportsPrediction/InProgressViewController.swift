//
//  InProgressViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/18/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class InProgressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var inProgressTable: UITableView!
    var ref: DatabaseReference!
    let email = Auth.auth().currentUser?.email!
    var name = ""
    var picks: [Pick]? = []
    let dateFormat = "yyyy-MM-DDHH:mm:sszzz"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inProgressTable.dataSource = self
        inProgressTable.delegate = self
        let emailBeforePeriod = email?.split(separator: "@")
        name = String((emailBeforePeriod?[0])!)
        ref = Database.database().reference().child("users").child(name);
        
        
        self.readPicksfromDatabase(completion: self.readCompletionHandler, ref: ref)

        // Do any additional setup after loading the view.
    }
    
    func readPicksfromDatabase(completion: @escaping (NSDictionary) -> Void, ref: DatabaseReference) {
        ref.child("picks").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            completion(value)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picks!.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy h:mm a"
        let date = dateformatter.string(from: self.strToDate(picks![indexPath.row].date))
        let alert = UIAlertController(title: "\(picks![indexPath.row].away) @ \(picks![indexPath.row].home)  \(date)", message: "You Picked: \(picks![indexPath.row].pick)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inProgress")
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MM/dd/yy h:mm a"
        let date = dateformatter.string(from: self.strToDate(picks![indexPath.row].date))
        cell!.textLabel?.text = "\(picks![indexPath.row].away) @ \(picks![indexPath.row].home)  \(date)"
        return cell!
    }
    
    func strToDate(_ str: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormat
        return(dateFormatter.date(from: str)!)
    }
    
    func readCompletionHandler(data: NSDictionary) {
        let loaded: NSArray = data["picks"] as! NSArray
        print(loaded)
        for p in loaded {
            let dict = p as! Dictionary<String,Any>
            if let dict = p as? NSDictionary {
                // use the NSArray list here
                self.picks?.append(Pick(away: dict["away"] as! String, date: dict["date"] as! String, home: dict["home"] as! String, pick: dict["pick"] as! String, result: dict["result"] as! Bool))
            }

        }
        DispatchQueue.main.async {
            self.inProgressTable.reloadData()
        }

        
    }
    
    @IBAction func buttonBack(_ sender: UIButton) {
        self.performSegue(withIdentifier: "InProgressToEvent", sender: self)
    }
    
}
