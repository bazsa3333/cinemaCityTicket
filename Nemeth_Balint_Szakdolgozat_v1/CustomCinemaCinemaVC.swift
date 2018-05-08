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
                        let nameId = cinemaNames.key
                        
                        if let movies = cinemaObject?["movies"] as? [Dictionary<String, AnyObject>], movies.count > 0 {
                            
                            var ids = [String]()
                            var movieIds = [String]()
                            
                            for x in 0..<movies.count {
                                
                                let id = movies[x]["id"]
                                let movieId = String(x)
                                ids.append(id as! String)
                                movieIds.append(movieId)
                            }
                            let cinema = CustomCinemaCinema(name: name as! String, ids: ids, nameId: nameId, cityName: self.city.name, movieIds: movieIds)
                            self.cinemas.append(cinema)
                        }
                    }
                }
            }
            self.cinemas.sort() { $0.name < $1.name }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cinema: CustomCinemaCinema!
        cinema = cinemas[indexPath.row]
        
        performSegue(withIdentifier: "CustomCinemaMovie", sender: cinema)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CustomCinemaMovie" {
            
            if let customCinemaMovieVC = segue.destination as? CustomCinemaMoviesVC {
                
                if let cinema = sender as? CustomCinemaCinema {
                    
                    customCinemaMovieVC.cinema = cinema
                }
            }
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
