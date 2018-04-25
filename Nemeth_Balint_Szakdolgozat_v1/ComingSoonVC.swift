//
//  ComingSoonVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 24..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class ComingSoonVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCinemaMovieCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [CustomCinemaMovie]()
    var selectedMovieForInfoBtn: CustomCinemaMovie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        parseMovie()
    }
    
    func parseMovie(){
        
        let ref = DataService.ds.REF_MOVIES
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for movies in snapshot.children.allObjects as! [DataSnapshot] {
                
                let movieObject = movies.value as? [String: AnyObject]
                let inTheCinemas = movieObject?["inTheCinemas"] as? Bool
                
                if !inTheCinemas! {
                    
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
                    let comingOut = (goodDateString as NSString).substring(to: 10)
                    
                    let movie = CustomCinemaMovie(name: name!, rating: rating!, description: description!, genre: genre!, length: length!, picture: pictureUrl!, release: year, comingOut: comingOut)
                    
                    self.movies.append(movie)
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
            cell.comingOutLbl.text = movies[indexPath.row].comingOut
            
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
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func infoBtnTapped(cell: UITableViewCell) {
        
        var index = tableView.indexPath(for: cell)

        selectedMovieForInfoBtn = movies[(index?.row)!]

        performSegue(withIdentifier: "InfoVC", sender: selectedMovieForInfoBtn)
    }
}
