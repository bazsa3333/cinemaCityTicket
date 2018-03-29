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
        
//        let ref = DataService.ds.REF_MOVIES.child((self.movie?.id)!).child("showing").child((self.movie?.cinemaName)!)
        
        let ref = DataService.ds.REF_CINEMAS.child((movie?.cityName)!).child((movie?.cinemaNameId)!).child("movies")
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for ids in snapshot.children.allObjects as! [DataSnapshot] {
                
                let idObject = ids.value as? [String: AnyObject]
                let id = idObject?["id"] as! String
                
                if id == self.movie?.id {
                    
                    if let showings = idObject?["showings"] as? [Dictionary<String, AnyObject>], showings.count > 0 {
                        
                        for x in 0..<showings.count {
                            
                            let dateString = showings[x]["date"]
                            let dateId = String(x)
                            
                            //Working with time
                            let currentDate = Date().addingTimeInterval(7200)
//                                    let calendar = Calendar.current
                            //        let year = calendar.component(.year, from: date)
                            //        let hour = calendar.component(.hour, from: date)
                            //        let minutes = calendar.component(.minute, from: date)
                            //        print("RITA: \(year) \(hour):\(minutes)")
                            //
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy.MM.dd"
            
                            guard let date = dateFormatter.date(from: dateString as! String) else {
            
                                fatalError("RITA: Problem with the dateformatter!")
                            }
                            
                            let goodDate = date.addingTimeInterval(93599)
                            
                            print(goodDate)
                            print(currentDate)
                            
                            if (currentDate <= goodDate) {
                                
                                let sh = CustomCinemaShowingDate(date: dateString as! String, movieId: (self.movie?.id)!, dateId: dateId, cityName: (self.movie?.cityName)!, cinemaId: (self.movie?.cinemaNameId)!)
                                self.dates.append(sh)
                            }
                        }
                        self.dateTableView.reloadData()
                        }
                }
                
            }
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
