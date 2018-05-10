//
//  ByDateCinemaMoviesVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 05. 10..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class ByDateCinemaMoviesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCinemaMovieCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var date: CustomCinemaShowingDate?
    var movies = [CustomCinemaMovie]()
    var selectedMovieForInfoBtn: CustomCinemaMovie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        parseMovies()
    }

    func parseMovies() {
        
        let ref = DataService.ds.REF_CINEMAS
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for city in snapshot.children.allObjects as! [DataSnapshot] {
                
                let cityKey = city.key
                for cinema in city.children.allObjects as! [DataSnapshot] {
                    
                    let cinemaObject = cinema.value as? [String: AnyObject]
                    let cinemaKey = cinema.key
                    if let movies = cinemaObject?["movies"] as? [Dictionary<String, AnyObject>], movies.count > 0 {
                        
                        for x in 0..<movies.count {
                            
                            let movieId = movies[x]["id"]
                            let movieKey = String(x)
                            if let showings = movies[x]["showings"] as? [Dictionary<String, AnyObject>], showings.count > 0 {
                                
                                for y in 0..<showings.count {
                                    
                                    let dateString = showings[y]["date"] as? String
                                    
                                    if dateString == self.date?.date {
                                        
                                        let movieRef = DataService.ds.REF_MOVIES.child(movieId as! String)
                                        movieRef.observe(DataEventType.value, with: { (snapshot) in
                                            
                                            let movieObject = snapshot.value as? [String: AnyObject]
                                            let name = movieObject?["name"]
                                            let rating = movieObject?["rating"]
                                            let description = movieObject?["description"]
                                            let genre = movieObject?["genre"]
                                            let length = movieObject?["length"]
                                            let pictureUrl = movieObject?["picture"]
                                            print(pictureUrl)
                                            let release = movieObject?["release"]
                                            
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "yyyy.MM.dd"
                                            guard let date = dateFormatter.date(from: release as! String) else {
                                                
                                                fatalError("RITA: Problem with the dateformatter!")
                                            }
                                            let goodDate = date.addingTimeInterval(32400)
                                            let goodDateString = String(describing: goodDate)
                                            let year = (goodDateString as NSString).substring(to: 4)
                                            
                                            var helper: Bool = false
                                            for index in 0..<self.movies.count {
                                                
                                                if self.movies[index].name == name as! String {
                                                    
                                                    helper = true
                                                }
                                            }
                                            
                                            if !helper {
                                                
                                                let movie = CustomCinemaMovie(name: name as! String, id: movieId as! String, cityName: cityKey, cinemaNameId: cinemaKey, picture: pictureUrl as! String, description: description as! String, genre: genre as! String, length: length as! String, rating: rating as! String, release: year, cinemaMovieId: movieKey)
                                                self.movies.append(movie)
                                                
                                                print(movie.picture)
                                            }
                                            
                                           
                                            
                                            self.movies.sort() { $0.name < $1.name }
                                            self.tableView.reloadData()
                                        })
                                    }
                                }
                            }
                        }
                    }
                }
            }
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
        
        performSegue(withIdentifier: "PopUpForMoviesInfoVC", sender: selectedMovieForInfoBtn)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        if segue.identifier == "CustomCinemaShowing" {
//
//            if let customCinemaShowingVC = segue.destination as? CustomCinemaShowingVC {
//
//                if let movie = sender as? CustomCinemaMovie {
//
//                    customCinemaShowingVC.movie = movie
//                }
//            }
//        }
        
        if segue.identifier == "PopUpForMoviesInfoVC" {
            
            if let popUpForMoviesInfoVC = segue.destination as? PopUpForMoviesInfoVC {
                
                if let movie = sender as? CustomCinemaMovie {
                    
                    popUpForMoviesInfoVC.movie = movie
                }
            }
        }
    }
}
