//
//  CustomCinemaCinemaVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 11..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class CustomCinemaCinemaVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var city: CustomCinemaCity!
    var cinemas = [CustomCinemaCinema]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        parseCinemas()
    }
    
    func parseCinemas() {
        
        let ref = DataService.ds.REF_CINEMAS
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for cinemas in snapshot.children.allObjects as! [DataSnapshot] {
                
                if cinemas.key == self.city.name {
                    
                    for cinemaNames in cinemas.children.allObjects as! [DataSnapshot] {
                        
                        let cinemaObject = cinemaNames.value as? [String: AnyObject]
                        let name = cinemaObject?["name"]
                        
                        let cinema = CustomCinemaCinema(name: name as! String)
                        self.cinemas.append(cinema)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCinemaCinemaCell", for: indexPath) as? CustomCinemaCinemaCell {
            
            let cinema = cinemas[indexPath.row]
            cell.configureCell(cinema: cinema)
            
            return cell
        } else {
            
            return CustomCinemaCinemaCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cinemas.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
