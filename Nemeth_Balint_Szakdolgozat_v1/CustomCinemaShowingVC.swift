//
//  CustomCinemaShowingVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 15..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class CustomCinemaShowingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var dateTableView: UITableView!
    
    var dates = [CustomCinemaShowingDate]()
    var movie: CustomCinemaMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateTableView.delegate = self
        dateTableView.dataSource = self
        
        parseShowings()
    }
    
    func parseShowings() {
        
        let ref = DataService.ds.REF_MOVIES.child((self.movie?.id)!).child("showing").child((self.movie?.cinemaName)!)
        
        ref.observe(DataEventType.value, with: { (snapshot) in
           
            for showings in snapshot.children.allObjects as! [DataSnapshot] {
                
                let showingObject = showings.value as? [String: AnyObject]
                let dateString = showingObject?["date"]
                let dateId = showings.key
                
                //Working with time
                //régi adatok törlése!!!
                        let currentDate = Date()
//                        let calendar = Calendar.current
                //        let year = calendar.component(.year, from: date)
                //        let hour = calendar.component(.hour, from: date)
                //        let minutes = calendar.component(.minute, from: date)
                //        print("RITA: \(year) \(hour):\(minutes)")
                //
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy.MM.dd"
                
                        guard let date = dateFormatter.date(from: dateString as! String) else {
                
                            fatalError("RITA: ERROR és FATAL")
                        }
                
                        if (currentDate <= date) {
                            
                            let sh = CustomCinemaShowingDate(date: dateString as! String, movieId: (self.movie?.id)!, dateId: dateId, cinemaName: (self.movie?.cinemaName)!)
                            self.dates.append(sh)
                        }
            }
            self.dateTableView.reloadData()
        })
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = dateTableView.dequeueReusableCell(withIdentifier: "CustomCinemaDateCell", for: indexPath) as? CustomCinemaDateCell{
            
            let showing = dates[indexPath.row]
            cell.configureCell(date: showing)
            
            return cell
        }else {
            
            return CustomCinemaDateCell()
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var date: CustomCinemaShowingDate!
        date = dates[indexPath.row]
        
        performSegue(withIdentifier: "CustomCinemaTime", sender: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CustomCinemaTime" {
            
            if let customCinemaShowingTimeVC = segue.destination as? CustomCinemaTimeVC {
                
                if let date = sender as? CustomCinemaShowingDate {
                    
                    customCinemaShowingTimeVC.date = date
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
