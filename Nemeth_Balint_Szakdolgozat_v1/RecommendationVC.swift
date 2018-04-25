//
//  RecommendationVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 24..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class RecommendationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCinemaMovieCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [CustomCinemaMovie]()
    var preferedMovies = [CustomCinemaMovie]()
    var selectedMovieForInfoBtn: CustomCinemaMovie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        parseMovies()
    }

    func parseMovies() {
        
        var total: Int = 0
        var preferedGenre: String?
        
        let ref = DataService.ds.REF_MOVIES
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for movies in snapshot.children.allObjects as! [DataSnapshot] {
                
                let movieObject = movies.value as? [String: AnyObject]
                let inTheCinemas = movieObject?["inTheCinemas"] as? Bool
                print(inTheCinemas)
                
                if inTheCinemas! {
                    
                    let name = movieObject?["name"] as? String
                    let rating = movieObject?["rating"] as? String
                    let description = movieObject?["description"] as? String
                    let genre = movieObject?["genre"] as? String
                    let length = movieObject?["length"] as? String
                    let pictureUrl = movieObject?["picture"] as? String
                    let release = movieObject?["release"] as? String
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy.MM.dd"
                    guard let date = dateFormatter.date(from: release as! String) else {
                        
                        fatalError("RITA: Problem with the dateformatter!")
                    }
                    let goodDate = date.addingTimeInterval(32400)
                    let goodDateString = String(describing: goodDate)
                    let year = (goodDateString as NSString).substring(to: 4)
                    
                    let movie = CustomCinemaMovie(name: name!, rating: rating!, description: description!, genre: genre!, length: length!, picture: pictureUrl!, release: year)
                    
                    self.movies.append(movie)
                }
                
            }
            
            let ref = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("interest")
            ref .observe(DataEventType.value, with: {(snapshot) in
                
                for genre in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    if genre.value as! Int > total {
                        
                        total = genre.value as! Int
                        preferedGenre = genre.key
                    }
                }
                
                if total != 0 {
                    
                    for i in 0..<self.movies.count {
                        
                        if self.movies[i].genre.range(of: preferedGenre!) != nil {
                            
                            self.preferedMovies.append(self.movies[i])
                        }
                    }
                } else {
                
                let alert = UIAlertController(title: "We are sorry", message: "You have no record of history, so we can't recommend!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                }
                if self.preferedMovies.count == 0 {
                    
                let alert = UIAlertController(title: "We are sorry", message: "Unfortunately we do not have anything to recommend to you!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                }
                self.tableView.reloadData()
            })
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCinemaMovieCell", for: indexPath) as? CustomCinemaMovieCell {
            
            cell.delegate = self
            
            let movie = preferedMovies[indexPath.row]
            cell.configureCell(movie: movie)
            
            return cell
        } else {
            
            return CustomCinemaMovieCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "InfoVC" {
            
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
        
        return preferedMovies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func infoBtnTapped(cell: UITableViewCell) {
        
        var index = tableView.indexPath(for: cell)
        
        selectedMovieForInfoBtn = preferedMovies[(index?.row)!]
        
        performSegue(withIdentifier: "InfoVC", sender: selectedMovieForInfoBtn)
    }

}
