//
//  ProfileViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/18/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  
  @IBOutlet weak var ProfileTableView: UITableView!
  
  
  
  var name: String = "Your Profile"
  
  var currentStreak: Int = 2
  var bestStreak: Int = 4
  
  var wins: Int = 18
  var losses: Int = 14
  
  var history: [pastGame] = []
  
  
  var myarray: [String] = []


  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    ProfileTableView.dataSource = self
    ProfileTableView.delegate = self
    
    setUpArray()
    
  }
  
  func setUpArray() {
    myarray.append(name)
    myarray.append("Current Streak: \(currentStreak)")
    myarray.append("Best Streak: \(bestStreak)")
    myarray.append("Total wins: \(wins)")
    myarray.append("Total losses: \(losses)")
    
    
//    let userID = Auth.auth().currentUser!.uid
    
    
    
//    let user = Auth.auth().currentUser
//    let firstHalf = user!.email?.split(separator: ".")
//    let userID = String(user![0])
    
//    self.myarray[0] = self.name
//    self.myarray[1] = String(self.currentStreak)
//    self.myarray[2] = String(self.bestStreak)
//    self.myarray[3] = String(self.wins)
//    self.myarray[4] = String(self.losses)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return myarray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
    cell.textLabel?.text = myarray[indexPath.item]
    return cell
  }
  
  

  @IBAction func buttonEvent(_ sender: UIButton) {
    self.performSegue(withIdentifier: "ProfileToEvent", sender: self)
  }
  
  @IBAction func buttonLeaderboard(_ sender: UIButton) {
    self.performSegue(withIdentifier: "ProfileToGraph", sender: self)
  }
  
}
