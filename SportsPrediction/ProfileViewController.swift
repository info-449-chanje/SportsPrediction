//
//  ProfileViewController.swift
//  SportsPrediction
//
//  Created by iGuest on 3/18/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  

  @IBOutlet weak var ProfileTableView: UITableView!
  
  var name: String = "Profile"
  
  var currentStreak: Int = 2
  var bestStreak: Int = 4
  
  var wins: Int = 18
  var losses: Int = 14
  
  var history: [pastGame] = [];
  
  
  var myarray: [String] = []
  
  
  var ref : DatabaseReference! = Database.database().reference()
  var handle : DatabaseHandle!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      ProfileTableView.dataSource = self
      ProfileTableView.delegate = self
      
      setUpArray()
      
//      getUserData()
      
      
    }
  
  
  func setUpArray() {
    myarray.append(name)
    myarray.append("Current Streak: \(currentStreak)")
    myarray.append("Best Streak: \(bestStreak)")
    myarray.append("Total wins: \(wins)")
    myarray.append("Total losses: \(losses)")
    
  }
  
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return myarray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
      cell.textLabel?.text = myarray[indexPath.item]
      return cell
    }
  
  
  
  
  
  /*
  func getUserData() {
    
    
    ref.observeSingleEvent(of: .value, with: { snapshot in
      
      if !snapshot.exists() { return }
      
      //print(snapshot)
      
      if let userName = snapshot.value!["wins"] as? String {
        print(userName)
      }
      if let email = snapshot.value!["wins"] as? String {
        print(email)
      }
      
      // can also use
      // snapshot.childSnapshotForPath("full_name").value as! String
    })
    
    
    let userID = Auth.auth().currentUser?.uid
    ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
      // Get user value
      let value = snapshot.value as? NSDictionary
      let wins = value?["wins"] as? String ?? ""
      print("wins \(wins)")
//      let user = User(username: username)
      
      // ...
    }) { (error) in
      print(error.localizedDescription)
    }
    
    
    
    
    let user = Auth.auth().currentUser
    if let user = user {
      // The user's ID, unique to the Firebase project.
      // Do NOT use this value to authenticate with your backend server,
      // if you have one. Use getTokenWithCompletion:completion: instead.
      let uid = user.uid
      var email : String = ""
      if (user.email != nil) {
        email = user.email as! String
//        let ans = email.split(separator: "@")
      } else {
        email = "guest"
      }
//      let name = email?.split(separator: "@")
      // ...
      print("uid: \(uid)")
      print("email: \(String(describing: email))")
      print(email)
    }
    
  }
  */
  

    @IBAction func buttonEvent(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ProfileToEvent", sender: self)
    }
    
    @IBAction func buttonLeaderboard(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ProfileToLeaderboard", sender: self)
    }
    
    @IBAction func buttonSignOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "UserSignOut", sender: self)
        } catch {
            print("Error while signing out")
        }
    }
}
