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
  
  
  var ref : DatabaseReference!
  
//  var array = [String]()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    ProfileTableView.dataSource = self
    ProfileTableView.delegate = self
    
    setUpArray()
    
    
    
    ref = Database.database().reference().child("users").child("sam")
//    ref.observe
    
    
    //observing the data changes
    ref.observe(DataEventType.value, with: { (snapshot) in
      
      //if the reference have some values
      if snapshot.childrenCount > 0 {
        
        
        //iterating through all the values
//        for attr in snapshot.children.allObjects as! [DataSnapshot] {
          //getting values
          let attrObject = snapshot.value as? [String: AnyObject]
          let wn  = attrObject?["wins"]
          let wn2 = "\(wn)"
          let wn3 = "WINS: " + self.chop(s: wn2)
          print(wn3)
        
        
          self.myarray.append(wn3)
//          //creating artist object with model and fetched values
//          let artist = ArtistModel(id: artistId as! String?, name: artistName as! String?, genre: artistGenre as! String?)
//
//          //appending it to list
//          self.artistList.append(artist)
          
//        }
        
        //reloading the tableview
//        self.tableViewArtists.reloadData()
      }
    })
    
    print(myarray)
    
//  getUserData()
    
    
  }
  
  func chop(s: String) -> String {
    let r = s.index(s.startIndex, offsetBy: 9)..<s.index(s.endIndex, offsetBy: -1)
    let substring = s[r]
    return String(substring)
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
  
  
  
  
  

  func getUserData() {
    
    
    
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
