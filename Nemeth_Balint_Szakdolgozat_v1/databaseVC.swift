//
//  databaseVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 24..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class databaseVC: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomCinemaMovieCellDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies = [CustomCinemaMovie]()
    var filteredMovies = [CustomCinemaMovie]()
    var selectedMovieForInfoBtn: CustomCinemaMovie? = nil
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parseMovie()
    }
    
    func parseMovie(){
        
        let ref = DataService.ds.REF_MOVIES
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for movies in snapshot.children.allObjects as! [DataSnapshot] {
                
                let movieObject = movies.value as? [String: AnyObject]
                    
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
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCinemaMovieCell", for: indexPath) as? CustomCinemaMovieCell {
            
            cell.delegate = self
            let movie: CustomCinemaMovie!
            
            if inSearchMode {
                
                movie = filteredMovies[indexPath.row]
                cell.configureCell(movie: movie)
            }else {
                
                movie = movies[indexPath.row]
                cell.configureCell(movie: movie)
            }
            
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
        
        if inSearchMode {
            
            return filteredMovies.count
        }else {
            
            return movies.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func infoBtnTapped(cell: UITableViewCell) {
        
        var index = tableView.indexPath(for: cell)
        
        if inSearchMode {
            
            selectedMovieForInfoBtn = filteredMovies[(index?.row)!]
        }else {
            
            selectedMovieForInfoBtn = movies[(index?.row)!]
        }
        
        
        performSegue(withIdentifier: "InfoVC", sender: selectedMovieForInfoBtn)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            tableView.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            
            filteredMovies = movies.filter({ $0.name.range(of: searchBar.text!) != nil })
            
            tableView.reloadData()
            
        }
        
    }
}
