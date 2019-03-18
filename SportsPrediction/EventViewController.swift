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
