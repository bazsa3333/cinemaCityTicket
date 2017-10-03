//
//  DetailsVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 01..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit
import Alamofire

class ShowingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var cinema: Cinema!
    var movies = [Showing]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        parseShowings()
    }
    
    func parseShowings() {
        
        Alamofire.request(BASE_URL).responseJSON { response in
            
            print(response.result)
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                
                if let sites = dict["sites"] as? [Dictionary<String, AnyObject>], sites.count > 0 {
                    
                    if let movieNames = sites[self.cinema.pos]["fe"] as? [Dictionary<String, AnyObject>], movieNames.count > 0 {
                        
                        for x in 0..<movieNames.count {
                            
                            if let movieName = movieNames[x]["fn"] {
                                
                                let movie = Showing(name: movieName as! String)
                                self.movies.append(movie)
                                print("BALINT: \(movie.name)")
                                
                            }
                        }
                        self.tableView.reloadData()
                        print(self.movies.count)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShowingCell", for: indexPath) as? ShowingCell {
            
            let movie = movies[indexPath.row]
            cell.configureCell(showing: movie)
            
            return cell
        }else {
            
            return ShowingCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
