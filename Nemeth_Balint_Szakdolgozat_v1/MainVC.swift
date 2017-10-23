//
//  ViewController.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 01..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit
import Alamofire

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cinemas = [Cinema]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        parseCinemas()
    }

    func parseCinemas() {
        
        Alamofire.request(BASE_URL).responseJSON { response in
        
            print(response.result)
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let sites = dict["sites"] as? [Dictionary<String, AnyObject>], sites.count > 0 {
                    
                    for x in 0..<sites.count {
                        
                        if let name = sites[x]["sn"] {
                            
                            let ci = Cinema(name: name as! String, pos: x)
                            self.cinemas.append(ci)
                            //teszteléshez
                            //print("BALINT: \(ci.name)")
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CinemaCell", for: indexPath) as? CinemaCell {
            
            let mozi = cinemas[indexPath.row]
            cell.configureCell(cinema: mozi)
            
            return cell
        }else {
            
            return CinemaCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var cinema: Cinema!
        
        cinema = cinemas[indexPath.row]
        
        performSegue(withIdentifier: "MovieVC", sender: cinema)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MovieVC" {
            
            if let movieVC = segue.destination as? MovieVC {
                
                if let cinema = sender as? Cinema {
                    
                    movieVC.cinema = cinema
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
        
        return 60
    }

}

