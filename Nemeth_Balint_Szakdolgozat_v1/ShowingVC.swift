//
//  ShowingVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 03..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit
import Alamofire

class ShowingVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var movie: Movie!
    var showings = [Showing]()
    
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
                    
                    if let movieNames = sites[self.movie.cinemaPos]["fe"] as? [Dictionary<String, AnyObject>], movieNames.count > 0 {
                        
                        if let showings = movieNames[self.movie.moviePos]["pr"] as? [Dictionary<String, AnyObject>], showings.count > 0 {
                            
                            for x in 0..<showings.count {
                                
                                if let showingDate = showings[x]["dt"], let showingTime = showings[x]["tm"]{
                                    
                                    let showing = Showing(date: showingDate as! String, time: showingTime as! String)
                                    self.showings.append(showing)
                                    print("BALINT: \(showing.date):\(showing.time)")
                                    
                                }
                            }
                            self.tableView.reloadData()
                            print("BALINT: \(showings.count)")
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ShowingCell", for: indexPath) as? ShowingCell {
            
            let showing = showings[indexPath.row]
            cell.configureCell(showing: showing)
            
            return cell
        }else {
            
            return ShowingCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return showings.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }

//    @IBAction func backBtnPressed(_ sender: Any) {
//        
//        dismiss(animated: true, completion: nil)
//    }
}
