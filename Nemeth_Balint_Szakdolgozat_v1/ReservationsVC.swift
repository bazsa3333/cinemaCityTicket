//
//  ReservationsVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 25..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class ReservationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var reservations = [Reservation]()
    var reservationsIds = [String]()
    var reservationDatas = [CustomCinemaShowingTime]()
    
    var name: String?
    var date: String?
    var time: String?
    var cinemaName: String?
    var tickets: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        parseReservations()
    }
    
    func parseReservations() {
        
        let ref = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("reservations")
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            for id in snapshot.children.allObjects as! [DataSnapshot] {
                
                let idObject = id.value as? [String: AnyObject]
                let reservationId = idObject?["id"] as? String
                self.reservationsIds.append(reservationId!)
            }
            
            let ref2 = DataService.ds.REF_RESERVATIONS
            ref2.observe(DataEventType.value, with: { (snapshot) in
                
                for reservation in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let id = reservation.key
                    
                    for i in 0..<self.reservationsIds.count {
                        
                        if id == self.reservationsIds[i] {
                            
                            let reservationObject = reservation.value as? [String: AnyObject]
                            let cinemaId = reservationObject?["cinemaId"] as? String
                            let movieId = reservationObject?["movieId"] as? String
                            let dateId = reservationObject?["dateId"] as? String
                            let timeId = reservationObject?["timeId"] as? String
                            let cityName = reservationObject?["cityName"] as? String
                            
                            if let tickets = reservationObject?["tickets"] as? [Dictionary<String, AnyObject>], tickets.count > 0 {
                                
                                var seats = ""
                                
                                for x in 0..<tickets.count {
                                    
                                    let seat = tickets[x]["Seat"] as! String
                                    seats.append((seat) + "; ")
                                }
                                
                                let reservationData = CustomCinemaShowingTime(cinemaId: cinemaId!, movieId: movieId!, dateId: dateId!, timeId: timeId!, tickets: seats, cityName: cityName!)
                                self.reservationDatas.append(reservationData)
                            }
                        }
                    }
                }
                for i in 0..<self.reservationDatas.count {

                    let movieRef = DataService.ds.REF_MOVIES.child(self.reservationDatas[i].movieId)
                    movieRef.observe(DataEventType.value, with: { (snapshot) in

                        let movieObject = snapshot.value as? [String: AnyObject]
                        self.name = movieObject?["name"] as? String
                        
                        let cinemaRef = DataService.ds.REF_CINEMAS.child(self.reservationDatas[i].cityName).child(self.reservationDatas[i].cinemaId)
                        cinemaRef.observe(DataEventType.value, with: { (snapshot) in
                            
                            let cinemaObject = snapshot.value as? [String: AnyObject]
                            self.cinemaName = cinemaObject?["name"] as? String
                            
                            let dateRef = DataService.ds.REF_CINEMAS.child(self.reservationDatas[i].cityName).child(self.reservationDatas[i].cinemaId).child("movies").child(self.reservationDatas[i].movieId).child("showings").child(self.reservationDatas[i].dateId)
                            dateRef.observe(DataEventType.value, with: { (snapshot) in
                                
                                let dateObject = snapshot.value as? [String: AnyObject]
                                self.date = dateObject?["date"] as? String
                                
                                let timeRef = DataService.ds.REF_CINEMAS.child(self.reservationDatas[i].cityName).child(self.reservationDatas[i].cinemaId).child("movies").child(self.reservationDatas[i].movieId).child("showings").child(self.reservationDatas[i].dateId).child("times").child(self.reservationDatas[i].timeId)
                                timeRef.observe(DataEventType.value, with: { (snapshot) in
                                    
                                    let timeObject = snapshot.value as? [String: AnyObject]
                                    let hour = timeObject?["hour"] as? String
                                    let minute = timeObject?["minute"] as? String
                                    self.time = hour! + ":" + minute!
                                    
                                    self.tickets = self.reservationDatas[i].tickets
                                    let data = Reservation(name: self.name!, date: self.date!, seats: self.tickets!, cinemaName: self.cinemaName!, time: self.time!)
                                    self.reservations.append(data)
                                    print(self.reservations.count)
                                    
                                    self.reservations.sort() { $0.date < $1.date }
                                    self.tableView.reloadData()
                                })
                            })
                        })
                    })
                }
            })
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReservationCell", for: indexPath) as? ReservationsCell {
            
            let reservation = reservations[indexPath.row]
            cell.configureCell(reservations: reservation)
            
            return cell
        } else {
            
            return CustomCinemaCinemaCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return reservations.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
}
