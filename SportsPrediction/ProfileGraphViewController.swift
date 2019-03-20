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
    
    makePie()
    
    
    
    
    
  }
  
  func makePie() {
    
    let email = Auth.auth().currentUser?.email!
    let emailBeforePeriod = email?.split(separator: "@")
    let name = String((emailBeforePeriod?[0])!)
    print(name)
    
    let ref = Database.database().reference().child("users").child(name) //child("sam")   child(name)
    
    ref.observe(DataEventType.value, with: { (snapshot) in
      print("checkpoint 1")
      //if the reference have some values
      if snapshot.childrenCount > 0 {
        print("checkpoint 2")
        
        let attrObject = snapshot.value as? [String: AnyObject]
        print(Double(self.chop(s: "\(attrObject?["wins"])")) ?? 0.0)
        
        print(self.chop(s: "\(attrObject?["wins"])"))
        
        let qWin = Double(self.chop(s: "\(attrObject?["wins"])")) ?? 0.0
        let qLoss = Double(self.chop(s: "\(attrObject?["losses"])")) ?? 0.0
        
        let winEntry = PieChartDataEntry(value: qWin)
        let lossEntry = PieChartDataEntry(value: qLoss)
        
        print(qWin)
        print(qLoss)
        
        if (qWin == 0.00 && qLoss == 0.00) {
          print("made it")
          
          self.graph.chartDescription?.enabled = true
          self.graph.chartDescription?.text = "No picks have been made"
          self.graph.chartDescription?.font = UIFont.boldSystemFont(ofSize: 24 )
          self.graph.chartDescription?.textAlign = NSTextAlignment.right
          self.graph.chartDescription?.textColor = UIColor.white
          
        }
        
        winEntry.label = "Correct picks"
        lossEntry.label = "Incorrect picks"
        
        self.qTries = [winEntry, lossEntry]
        
        
      }
      
      self.formatPie()
      
    })
  }
  
  func formatPie() {
    
    
//    graph.chartDescription?.enabled = false
//    graph.chartDescription?.text = "description would go here"
    
    
    graph.rotationAngle = 0
    graph.rotationEnabled = false
    graph.isUserInteractionEnabled = true
    
    graph.noDataText = "No data available"
    graph.holeRadiusPercent = 0.3
//    graph.transparentCircleColor = UIColor.clear
    graph.transparentCircleRadiusPercent = 0.4
    
    graph.legend.enabled = true;
    graph.legend.font = UIFont.boldSystemFont(ofSize: 16)
    graph.legend.textColor = UIColor.white
    graph.legend.formSize = CGFloat(20.0)
    
    graph.drawHoleEnabled = true
    graph.holeColor = UIColor.clear
    
    let green = NSUIColor(hex: 0xfc913f)
    let orange = NSUIColor(hex: 0x39e830)
    let white = NSUIColor(hex: 0xffffff)
    let black = NSUIColor(hex: 0x000000)
    
    
    
    let chartAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17) ]
    let chartAttrString = NSAttributedString(string: "Career Record", attributes: chartAttribute)
    graph.centerAttributedText = chartAttrString
    
    
    
    let dataSet = PieChartDataSet(values: qTries, label: "")
    dataSet.valueColors = [white,white]
    dataSet.valueFont = UIFont.boldSystemFont(ofSize: 18)
    dataSet.colors = [orange, green]
    
    //    dataSet.xValuePosition = PieChartDataSet.ValuePosition.outsideSlice
    
    let chartData = PieChartData(dataSet: dataSet)
    
    
    
    graph.data = chartData
    //    graph.backgroundColor = bg
    
  }
  
  
  func chop(s: String) -> String {
    let r = s.index(s.startIndex, offsetBy: 9)..<s.index(s.endIndex, offsetBy: -1)
    let substring = s[r]
    return String(substring)
  }

  

}

