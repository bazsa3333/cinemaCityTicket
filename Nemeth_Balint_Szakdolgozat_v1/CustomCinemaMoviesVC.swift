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
        
        //Working with time
//        let date = Date()
//        let calendar = Calendar.current
//        let year = calendar.component(.year, from: date)
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        print("RITA: \(year) \(hour):\(minutes)")
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy.MM.dd"
//
//        guard let date2 = dateFormatter.date(from: "2017.01.17") else {
//
//            fatalError("RITA: ERROR és FATAL")
//        }
//
//        print(calendar.component(.day, from: date2))
//
//        if (date > date2) {
//
//            print("nagyobb bazdmeg")
//        }
    }

    func parseMovies() {
        
        let ref = DataService.ds.REF_MOVIES
//        let storage = DataService.ds.REF_STORAGE
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for movies in snapshot.children.allObjects as! [DataSnapshot] {
                
                for x in 0..<self.cinema.ids.count {
                
                    if movies.key == self.cinema.ids[x] {
                    
                        let movieObject = movies.value as? [String: AnyObject]
                        let name = movieObject?["name"]
                        let cinemaName = self.cinema.name
                        let id = movies.key
                        
                        let release = movieObject?["release"]
                        print(release as! String)
                        let rating = movieObject?["rating"]
                        print(rating as! String)
                        let description = movieObject?["description"]
                        print(description as! String)
                        let genre = movieObject?["genre"]
                        print(genre as! String)
                        let length = movieObject?["length"]
                        print(length as! String)
                        
                        let picture = "fifthyShadesOfFreed.jpg"
                        
                        let movie = CustomCinemaMovie(name: name as! String, id: id, cinemaName: cinemaName, picture: picture, description: description as! String, genre: genre as! String, length: length as! String, rating: rating as! String, release: release as! String)
                        self.movies.append(movie)
                        
//                        let storageRef = Storage.storage().reference(forURL: "gs://szakdolgozat-2012b.appspot.com/").child("fifthyShadesOfFreed.jpg")
//
//
//                        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                            if let error = error {
//
//                                print("RITA: Error occured: \(error.localizedDescription)")
//                            } else {
//
//                                let pic = UIImage(data: data!)
//
//                                let picture = data
//
//                                let movie = CustomCinemaMovie(name: name as! String, id: id, cinemaName: cinemaName, picture: picture!)
//                                self.movies.append(movie)
//                            }
//                        }
                        }
                    
                }
            }
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
