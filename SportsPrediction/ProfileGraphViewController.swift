//
//  ProfileGraphViewController.swift
//  SportsPrediction
//
//  Created by Jacques DeBar on 3/17/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit
import Charts
import FirebaseAuth
import FirebaseDatabase

class ProfileGraphViewController: UIViewController {

  
  
  @IBOutlet weak var graph: PieChartView!
  
  
  var qRight = PieChartDataEntry(value:25)
  var qWrong = PieChartDataEntry(value:12)
  
  
  var qTries = [PieChartDataEntry]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    self.title = "Your picks"
    //    graph.chartDescription?.text = ""
    
    //    qRight.value = r
    qRight.label = "Correct picks"
    
    //    qWrong.value = w
    qWrong.label = "Incorrect picks"
    
    qTries = [qRight, qWrong]
    
    //    updateChartData()
    
    
    
    let email = Auth.auth().currentUser?.email!
    var emailBeforePeriod = email?.split(separator: "@")
    let name = String((emailBeforePeriod?[0])!)
    print(name)
    
    var ref = Database.database().reference().child("users").child(name) //child("sam")
    //    ref.observe
    
    
    //observing the data changes
    ref.observe(DataEventType.value, with: { (snapshot) in
      
      //if the reference have some values
      if snapshot.childrenCount > 0 {
        
        
        //        iterating through all the values
        //        for attr in snapshot.children.allObjects as! [DataSnapshot] {
        //        getting values
        let attrObject = snapshot.value as? [String: AnyObject]
        print(Double(self.chop(s: "\(attrObject?["wins"])")) ?? 0.0)
        
        print(self.chop(s: "\(attrObject?["wins"])"))
        
        let qWin = Double(self.chop(s: "\(attrObject?["wins"])")) ?? 0.0
        let qLoss = Double(self.chop(s: "\(attrObject?["losses"])")) ?? 0.0
//
        self.qTries = [PieChartDataEntry(value: qWin), PieChartDataEntry(value: qLoss)]
        
        
//        self.myarray.append("Wins: " + self.chop(s: "\(attrObject?["wins"])"))
//        self.myarray.append("Losses: " + self.chop(s: "\(attrObject?["losses"])"))
//        self.myarray.append("Current Streak: " + self.chop(s: "\(attrObject?["currentStreak"])"))
//        self.myarray.append("Record Streak: " + self.chop(s: "\(attrObject?["recordStreak"])"))
        
        //        self.addToArray(th: "\(attrObject?["wins"])")
        //        self.addToArray(th: "\(attrObject?["losses"])")
        //        self.addToArray(th: "\(attrObject?["currentStreak"])")
        //        self.addToArray(th: "\(attrObject?["recordStreak"])")
        //
        //        let wn3 = "WINS: " + self.chop(s: wn2)
        //        self.myarray.append(wn3)
//        self.ProfileTableView.reloadData()
        //          //creating artist object with model and fetched values
        //          let artist = ArtistModel(id: artistId as! String?, name: artistName as! String?, genre: artistGenre as! String?)
        //
        //          //appending it to list
        //          self.artistList.append(artist)
        
        //        }
        
        //reloading the tableview
        //        self.tableViewArtists.reloadData()
      }
      
      
      self.setupPie()
    })
    
    
    
    
  }
  
  func setupPie() {
    graph.chartDescription?.enabled = false
    graph.drawHoleEnabled = true
    graph.rotationAngle = 0
    graph.rotationEnabled = false
    graph.isUserInteractionEnabled = false
    
    //    graph.legend.enabled = false;
    
    //    var picks: [PieChartDataEntry] = Array()
    
    
    let dataSet = PieChartDataSet(values: qTries, label: "")
    let chartData = PieChartData(dataSet: dataSet)
    
    let green = NSUIColor(hex: 0x16822b)
    let red = NSUIColor(hex: 0xaa1111)
    dataSet.colors = [green, red]
    
    graph.data = chartData
    
  }
  
  
  func chop(s: String) -> String {
    let r = s.index(s.startIndex, offsetBy: 9)..<s.index(s.endIndex, offsetBy: -1)
    let substring = s[r]
    return String(substring)
  }

  
  
  func changeRight() {
    
  }
  
  func changeWrong() {
    
  }

}

