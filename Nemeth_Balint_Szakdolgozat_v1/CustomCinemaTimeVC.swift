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
                let hour = timeObject?["hour"] as! String
                let minute = timeObject?["minute"] as! String
                let timeId = times.key
                                
                let currentDate = Date()
                let calendar = Calendar.current
                let currentHour = calendar.component(.hour, from: currentDate)
                let currentMinute = calendar.component(.minute, from: currentDate)
                
                print("\(currentHour):\(currentMinute)")
                
                print("\(Int(hour)!):\(Int(minute)!)")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy.MM.dd"
                
                guard let date = dateFormatter.date(from: self.date?.date as! String) else {
                    
                    fatalError("RITA: ERROR és FATAL")
                }
                
                if (date == currentDate) {
                    
                    if (currentHour < Int(hour)!) {
                        
                        let timeClass = CustomCinemaShowingTime(hour: hour, minute: minute, timeId: timeId, movieId: (self.date?.movieId)!, dateId: (self.date?.dateId)!, cinemaName: (self.date?.cinemaName)!)
                        self.times.append(timeClass)
                    }
                
                    if (currentHour == Int(hour)!) {
                        
                        if (currentMinute <= Int(minute)!) {
                            
                            let timeClass = CustomCinemaShowingTime(hour: hour, minute: minute, timeId: timeId, movieId: (self.date?.movieId)!, dateId: (self.date?.dateId)!, cinemaName: (self.date?.cinemaName)!)
                            self.times.append(timeClass)
                        }
                    }
                    
                } else {
                    
                    let timeClass = CustomCinemaShowingTime(hour: hour, minute: minute, timeId: timeId, movieId: (self.date?.movieId)!, dateId: (self.date?.dateId)!, cinemaName: (self.date?.cinemaName)!)
                    self.times.append(timeClass)

                }
            }
            print(self.times.count)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var time: CustomCinemaShowingTime!
        time = times[indexPath.row]
        
        performSegue(withIdentifier: "NumberOfTicketsVC", sender: time)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "NumberOfTicketsVC" {
            
            if let numberOfTicketsVC = segue.destination as? NumberOfTicketsVC {
                
                if let time = sender as? CustomCinemaShowingTime {
                    
                    numberOfTicketsVC.time = time
                }
            }
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
