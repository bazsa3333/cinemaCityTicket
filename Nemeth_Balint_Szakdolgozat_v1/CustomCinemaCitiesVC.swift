//
//  CustomCinemaCitiesVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 10..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class CustomCinemaCitiesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var cities = [CustomCinemaCity]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        parseCities()
    }

    func parseCities() {
        
        let ref = DataService.ds.REF_CITIES
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for cities in snapshot.children.allObjects as! [DataSnapshot] {
                
                let cityObject = cities.value as? [String: AnyObject]
                let name = cityObject?["name"]
                
                let city = CustomCinemaCity(name: name as! String)
                self.cities.append(city)
                
                print(city.name)
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCinemaCitiesCell", for: indexPath) as? CustomCinemaCitiesCell {
            
            let city = cities[indexPath.row]
            cell.configureCell(cities: city)
            
            return cell
        } else {
        
            return CustomCinemaCitiesCell()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var city: CustomCinemaCity!
        
        city = cities[indexPath.row]
        
        performSegue(withIdentifier: "CustomCinemaCinema", sender: city)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CustomCinemaCinema" {
            
            if let customCinemaCinemaVC = segue.destination as? CustomCinemaCinemaVC {
                
                if let city = sender as? CustomCinemaCity {
                    
                    customCinemaCinemaVC.city = city
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
}
