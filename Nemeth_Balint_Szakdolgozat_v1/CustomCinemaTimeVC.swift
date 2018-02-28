//
//  CustomCinemaTimeVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 15..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class CustomCinemaTimeVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var times = [CustomCinemaShowingTime]()
    var date: CustomCinemaShowingDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        dateLbl.text = date?.date
        
        parseTime()
    }
    
    func parseTime() {
        
        let ref = DataService.ds.REF_MOVIES.child((self.date?.movieId)!).child("showing").child((self.date?.cinemaName)!).child((self.date?.dateId)!).child("times")
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for times in snapshot.children.allObjects as! [DataSnapshot] {
                
                let timeObject = times.value as? [String: AnyObject]
                let time = timeObject?["time"]
                
                let timeClass = CustomCinemaShowingTime(time: time as! String)
                self.times.append(timeClass)
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCinemaTimeCell", for: indexPath) as? CustomCinemaTimeCell {
            
            let time = times[indexPath.row]
            cell.configureCell(time: time)
            
            return cell
        }else {
            
            return CustomCinemaTimeCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return times.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }

}