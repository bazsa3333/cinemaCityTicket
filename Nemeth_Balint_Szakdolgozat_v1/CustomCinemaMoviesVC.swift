//
//  CustomCinemaMoviesVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 11..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class CustomCinemaMoviesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [CustomCinemaMovie]()
    var cinema: CustomCinemaCinema!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        parseMovies()
    }

    func parseMovies() {
        
        let ref = DataService.ds.REF_MOVIES
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for movies in snapshot.children.allObjects as! [DataSnapshot] {
                
                if movies.key == self.cinema.id {
                    
                    let movieObject = movies.value as? [String: AnyObject]
                    let name = movieObject?["name"]
                    
                    let movie = CustomCinemaMovie(name: name as! String)
                    self.movies.append(movie)
                }
            }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCinemaMovieCell", for: indexPath) as? CustomCinemaMovieCell {
            
            let movie = movies[indexPath.row]
            cell.configureCell(movie: movie)
            
            return cell
        } else {
            
            return CustomCinemaMovieCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
