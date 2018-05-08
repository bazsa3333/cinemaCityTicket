//
//  CustomCinemaMoviesVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 11..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class CustomCinemaMoviesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCinemaMovieCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [CustomCinemaMovie]()
    var cinema: CustomCinemaCinema!
    
    var selectedMovieForInfoBtn: CustomCinemaMovie? = nil
    
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
                
                for x in 0..<self.cinema.ids.count {
                
                    if movies.key == self.cinema.ids[x] {
                    
                        let movieObject = movies.value as? [String: AnyObject]
                        let name = movieObject?["name"]
                        let id = movies.key
                        let rating = movieObject?["rating"]
                        let description = movieObject?["description"]
                        let genre = movieObject?["genre"]
                        let length = movieObject?["length"]
                        let pictureUrl = movieObject?["picture"]
                        let release = movieObject?["release"]
                        let cinemaMovieId = self.cinema.movieIds[x]
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy.MM.dd"
                        guard let date = dateFormatter.date(from: release as! String) else {
                            
                            fatalError("RITA: Problem with the dateformatter!")
                        }
                        let goodDate = date.addingTimeInterval(32400)
                        let goodDateString = String(describing: goodDate)
                        let year = (goodDateString as NSString).substring(to: 4)
                        print("RITA: \(year)")
                        
                            
                        let movie = CustomCinemaMovie(name: name as! String, id: id, cityName: self.cinema.cityName, cinemaNameId: self.cinema.nameId, picture: pictureUrl as! String, description: description as! String, genre: genre as! String, length: length as! String, rating: rating as! String, release: year, cinemaMovieId: cinemaMovieId)
                        
                        self.movies.append(movie)
                        }
                }  
            }
            self.movies.sort() { $0.name < $1.name }
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCinemaMovieCell", for: indexPath) as? CustomCinemaMovieCell {
            
            cell.delegate = self
            
            let movie = movies[indexPath.row]
            cell.configureCell(movie: movie)
            
            return cell
        } else {
            
            return CustomCinemaMovieCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var movie: CustomCinemaMovie!
        movie = movies[indexPath.row]
        
        performSegue(withIdentifier: "CustomCinemaShowing", sender: movie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "CustomCinemaShowing" {
            
            if let customCinemaShowingVC = segue.destination as? CustomCinemaShowingVC {
                
                if let movie = sender as? CustomCinemaMovie {
                    
                    customCinemaShowingVC.movie = movie
                }
            }
        }
        
        if segue.identifier == "PopUpForMoviesInfoVC" {
            
            if let popUpForMoviesInfoVC = segue.destination as? PopUpForMoviesInfoVC {
                
                if let movie = sender as? CustomCinemaMovie {
                    
                    popUpForMoviesInfoVC.movie = movie
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func infoBtnTapped(cell: UITableViewCell) {
        
        var index = tableView.indexPath(for: cell)
        
        selectedMovieForInfoBtn = movies[(index?.row)!]
        
        print(selectedMovieForInfoBtn?.description)
        
        performSegue(withIdentifier: "PopUpForMoviesInfoVC", sender: selectedMovieForInfoBtn)
    }
    
    
}
