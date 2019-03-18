//
//  ProfileGraphViewController.swift
//  SportsPrediction
//
//  Created by Jacques DeBar on 3/17/19.
//  Copyright © 2019 INFO 449 CHANGJE. All rights reserved.
//

import UIKit

class ProfileGraphViewController: UIViewController {

  
  @IBOutlet weak var graph: PieChartView!
  
  
  var qRight = PieChartDataEntry(value:0)
  var qWrong = PieChartDataEntry(value:0)
  
  
  var qTries = [PieChartDataEntry]()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.title = "Your picks"
    graph.chartDescription?.text = ""
    
    qRight.value = r
    qRight.label = "Correct picks"
    
    qWrong.value = w
    qWrong.label = "Incorrect picks"
    
    qTries = [qRight, qWrong]
    
    updateChartData()
    
  }
  
  func changeRight() {
    
  }
  
  func changeWrong() {
    
  }
  
  
  func updateChartData() {
    
    let chartDataSet = PieChartDataSet(values: qTries, label: nil)
    let chartData = PieChartData(dataSet: chartDataSet)
    
    let colors = [UIColor(named:"success"), UIColor(named:"failure")]
    chartDataSet.colors = colors as! [NSUIColor]
    
    graph.data = chartData


  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
