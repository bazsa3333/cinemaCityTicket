//
//  ByDateCinemaShowingVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 05. 08..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class ByDateCinemaShowingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var dates = [CustomCinemaShowingDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        parseDates()
    }

    func parseDates() {
        
        let ref = DataService.ds.REF_CINEMAS
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for city in snapshot.children.allObjects as! [DataSnapshot] {
                
                for cinema in city.children.allObjects as! [DataSnapshot] {
                    
                    let cinemaObject = cinema.value as? [String: AnyObject]
                    
                    if let movies = cinemaObject?["movies"] as? [Dictionary<String, AnyObject>], movies.count > 0 {
                        
                        for x in 0..<movies.count {
                            
                            if let showings = movies[x]["showings"] as? [Dictionary<String, AnyObject>], showings.count > 0 {
                                
                                for y in 0..<showings.count {
                                    
                                    let dateString = showings[y]["date"] as? String
                                    
                                    var helper: Bool = false
                                    for index in 0..<self.dates.count {
                                        
                                        if self.dates[index].date == dateString {
                                            
                                            helper = true
                                        }
                                    }
                                    
                                    if !helper {
                                        
                                        let date = CustomCinemaShowingDate(date: dateString!)
                                        self.dates.append(date)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.dates.sort() { $0.date < $1.date }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCinemaDateCell", for: indexPath) as? CustomCinemaDateCell{
            
            let showing = dates[indexPath.row]
            cell.configureCell(date: showing)
            
            return cell
        }else {
            
            return CustomCinemaDateCell()
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
