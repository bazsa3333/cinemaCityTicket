//
//  ReservationsVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 25..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class ReservationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, ReservationCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var reservations = [Reservation]()
    var reservationsIds = [String]()
    var reservationDatas = [CustomCinemaShowingTime]()
    var selectedReservationForDeleteBtn: Reservation? = nil
    var selectedReservationDataForDeleteBtn: CustomCinemaShowingTime? = nil
    
    var name: String?
    var date: String?
    var time: String?
    var cinemaName: String?
    var tickets: String?
    var reservationId: String?
    var cityName: String?
    
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
                            let cinemaMovieId = reservationObject?["cinemaMovieId"] as? String
                            let dateId = reservationObject?["dateId"] as? String
                            let timeId = reservationObject?["timeId"] as? String
                            let cityName = reservationObject?["cityName"] as? String
                            
                            if let tickets = reservationObject?["tickets"] as? [Dictionary<String, AnyObject>], tickets.count > 0 {
                                
                                var seats = ""
                                
                                for x in 0..<tickets.count {
                                    
                                    let seat = tickets[x]["Seat"] as! String
                                    seats.append((seat) + "; ")
                                }
                                
                                let reservationData = CustomCinemaShowingTime(cinemaId: cinemaId!, movieId: movieId!, dateId: dateId!, timeId: timeId!, tickets: seats, cityName: cityName!, cinemaMovieId: cinemaMovieId!, reservationId: id)
                                self.reservationDatas.append(reservationData)
                            }
                        }
                    }
                }
                for i in 0..<self.reservationDatas.count {
                    
//                    self.cityName = self.reservationDatas[i].cityName
//                    self.reservationId = self.reservationDatas[i].reservationId
                    
                    let movieRef = DataService.ds.REF_MOVIES.child(self.reservationDatas[i].movieId)
                    movieRef.observe(DataEventType.value, with: { (snapshot) in

                        let movieObject = snapshot.value as? [String: AnyObject]
                        self.name = movieObject?["name"] as? String
                        
                        let cinemaRef = DataService.ds.REF_CINEMAS.child(self.reservationDatas[i].cityName).child(self.reservationDatas[i].cinemaId)
                        cinemaRef.observe(DataEventType.value, with: { (snapshot) in
                            
                            let cinemaObject = snapshot.value as? [String: AnyObject]
                            self.cinemaName = cinemaObject?["name"] as? String
                            
                            let dateRef = DataService.ds.REF_CINEMAS.child(self.reservationDatas[i].cityName).child(self.reservationDatas[i].cinemaId).child("movies").child(self.reservationDatas[i].cinemaMovieId).child("showings").child(self.reservationDatas[i].dateId)
                            dateRef.observe(DataEventType.value, with: { (snapshot) in
                                
                                let dateObject = snapshot.value as? [String: AnyObject]
                                self.date = dateObject?["date"] as? String
                                
                                let timeRef = DataService.ds.REF_CINEMAS.child(self.reservationDatas[i].cityName).child(self.reservationDatas[i].cinemaId).child("movies").child(self.reservationDatas[i].cinemaMovieId).child("showings").child(self.reservationDatas[i].dateId).child("times").child(self.reservationDatas[i].timeId)
                                timeRef.observe(DataEventType.value, with: { (snapshot) in
                                    
                                    let timeObject = snapshot.value as? [String: AnyObject]
                                    let hour = timeObject?["hour"] as? String
                                    let minute = timeObject?["minute"] as? String
                                    self.time = hour! + ":" + minute!
                                    
                                    self.tickets = self.reservationDatas[i].tickets
                                    self.cityName = self.reservationDatas[i].cityName
                                    self.reservationId = self.reservationDatas[i].reservationId
                                    let data = Reservation(name: self.name!, date: self.date!, seats: self.tickets!, cinemaName: self.cinemaName!, time: self.time!, reservationId: self.reservationId!, cityName: self.cityName!)
                                    self.reservations.append(data)
                                    
//                                    self.reservations.sort() { $0.date < $1.date }
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
            
             cell.delegate = self
            
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
    
    func getSeatMap() {
        
        
    }
    
    func deleteBtnTapped(cell: UITableViewCell) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "If you delete you're going to lose your reservation!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action: UIAlertAction!) in
            
            var index = self.tableView.indexPath(for: cell)
            self.selectedReservationForDeleteBtn = self.reservations[(index?.row)!]
            self.selectedReservationDataForDeleteBtn = self.reservationDatas[(index?.row)!]
            var seats = [String]()
            
            print(self.selectedReservationForDeleteBtn?.reservationId)
            print(self.selectedReservationDataForDeleteBtn?.movieId)
            
            let reservationRef = DataService.ds.REF_RESERVATIONS.child((self.selectedReservationForDeleteBtn?.reservationId)!).child("tickets")
            reservationRef.observe(DataEventType.value, with: { (snapshot) in
                
                for seat in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let seatObject = seat.value as? [String: AnyObject]
                    let value = seatObject?["Seat"] as? String
                    
                    print("Székek: \(value!)")
                    
                    seats.append(value!)
                }
                
                let seatRef = DataService.ds.REF_CINEMAS.child((self.selectedReservationDataForDeleteBtn?.cityName)!).child((self.selectedReservationDataForDeleteBtn?.cinemaId)!).child("movies").child((self.selectedReservationDataForDeleteBtn?.cinemaMovieId)!).child("showings").child((self.selectedReservationDataForDeleteBtn?.dateId)!).child("times").child((self.selectedReservationDataForDeleteBtn?.timeId)!)
                
                seatRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    
                    let object = snapshot.value as? [String: AnyObject]
                    let value = object?["seatMap"] as! String
                    
                    var seatMap = value
                    
                    for i in 0..<seats.count {
                        
                        var row: String = ""
                        var column: String = ""
                        
                        let string = seats[i]
                        for j in 0..<string.characters.count {
                            
                            if string[j] == "/" {
                                
                                let index = string.index(string.startIndex, offsetBy: j)
                                row = String(string.prefix(upTo: index))
                            }
                        }
                        for x in stride(from: (string.characters.count - 1), through: 0, by: -1) {
                            
                            if string[x] == "/" {
                                
                                let index = string.index(string.endIndex, offsetBy: -((string.characters.count - 1)-x))
                                column = String(string.suffix(from: index))
                            }
                        }
                        print("Feldarabolás után: \(row)/\(column)")
                        var seatMapRow: Int = 1
                        var seatMapColumn: Int = 0
                        var indexForEmptyColumns = 0
                        
                        for index in 0..<seatMap.characters.count {
                            
                            if (seatMap[index] == "A") || (seatMap[index] == "U") || (seatMap[index] == "D") {
                                
                                seatMapColumn += 1
                                indexForEmptyColumns = 0
                            } else if seatMap[index] == "_" {
                                
                                indexForEmptyColumns += 1
                                
                            } else {
                                
                                if indexForEmptyColumns < 4 {
                                    
                                    seatMapRow += 1
                                }
                                seatMapColumn = 0
                            }
                            
                            if seatMapRow == Int(row) && seatMapColumn == Int(column) {
                                
                                print("Találat! \(row)/\(column) és \(seatMapRow)/\(seatMapColumn)")
                                
                                var chars = Array(seatMap.characters)
                                print("Index pozicio: \(index)")
                                chars[index] = "A"
                                seatMap = String(chars)
                                print(seatMap)                            }
                        }
                        let seatRefForModification = DataService.ds.REF_CINEMAS.child((self.selectedReservationDataForDeleteBtn?.cityName)!).child((self.selectedReservationDataForDeleteBtn?.cinemaId)!).child("movies").child((self.selectedReservationDataForDeleteBtn?.cinemaMovieId)!).child("showings").child((self.selectedReservationDataForDeleteBtn?.dateId)!).child("times").child((self.selectedReservationDataForDeleteBtn?.timeId)!).child("seatMap")
                        seatRefForModification.setValue(seatMap)
                        
                        let reservationRemoveRef = DataService.ds.REF_RESERVATIONS.child((self.selectedReservationForDeleteBtn?.reservationId)!)
                        reservationRemoveRef.removeValue()
                        
                        let userRef = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("reservations")
                        userRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                            
                            for reservation in snapshot.children.allObjects as! [DataSnapshot] {
                                
                                let reservationObject = reservation.value as? [String: AnyObject]
                                let id = reservationObject?["id"] as? String
                                
                                if self.selectedReservationForDeleteBtn?.reservationId == id {
                                    
                                    let deleteUserReservationRef = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("reservations").child(reservation.key)
                                    deleteUserReservationRef.removeValue()
                                }
                            }
                        })
                    }
                })
            })
        }))
        alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
