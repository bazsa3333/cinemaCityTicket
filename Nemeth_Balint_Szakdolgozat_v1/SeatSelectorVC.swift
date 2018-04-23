//
//  SeatSelectorVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 03. 26..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

class selection {
    
    private var _row: Int!
    private var _column: Int!
    
    var column: Int {
        
        return _column
    }
    
    var row: Int {
        
        return _row
    }
    
    init(row: Int, column: Int) {
        
        self._column = column
        self._row = row
    }
}

class SeatSelectorVC: UIViewController, ZSeatSelectorDelegate {

    @IBOutlet weak var label: UILabel!
    
    var seatsSelected = [selection]()
    var time: CustomCinemaShowingTime?
    var seatLimit: Int?
    
    var map: String!
    let seats = ZSeatSelector()
    
    var childrenCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseSeats()
    }
    
    func parseSeats() {
        
        let ref = DataService.ds.REF_CINEMAS.child((self.time?.cityName)!).child((self.time?.cinemaId)!).child("movies").child((self.time?.movieId)!).child("showings").child((self.time?.dateId)!).child("times").child((self.time?.timeId)!)
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            let value = snapshot.value as? Dictionary<String, AnyObject>
            let seatMap = value?["seatMap"] as? String
            
            self.map = seatMap!
            
            self.seats.frame = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: 300)
            self.seats.setSeatSize(CGSize(width: 25, height: 25))
            self.seats.setAvailableImage(   UIImage(named: "A")!,
                                             andUnavailableImage:    UIImage(named: "U")!,
                                             andDisabledImage:       UIImage(named: "D")!,
                                             andSelectedImage:       UIImage(named: "S")!)
            self.seats.layout_type = "Normal"
            self.seats.setMap(self.map)
//            self.seats.seat_price           = 5.0
            self.seats.selected_seat_limit  = self.seatLimit!
            self.seats.seatSelectorDelegate = self
            self.seats.maximumZoomScale         = 5.0
            self.seats.minimumZoomScale         = 0.05
            self.view.addSubview(self.seats)
        })
    }
    
    func seatSelected(_ seat: ZSeat) {
        //print("Seat at row: \(seat.row) and column: \(seat.column)\n")
    }
    
    func getSelectedSeats(_ seats: NSMutableArray) {
        var total:Float = 0.0;
        for i in 0..<seats.count {
            let seat:ZSeat  = seats.object(at: i) as! ZSeat
            print("Seat at row: \(seat.row) and column: \(seat.column)\n")
            self.label.text = "Row: \(seat.row) Column: \(seat.column)"
            
            let seatS = selection(row: seat.row, column: seat.column)
            self.seatsSelected.append(seatS)
        }
    }
    
    @IBAction func okBtnTapped(_ sender: Any) {
        
        var column: Int = 0
        var row: Int = 1
        var indexForEmptyColumns: Int = 0
        
        var reservedSeats = [Dictionary<String, String>]()
        
        if (self.seats.selected_seats.count != self.seats.selected_seat_limit) {
            
            let alert = UIAlertController(title: "Error", message: "You didn't choose enough seats! If you change your mind, go back and modify the number of tickets!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
        
            
            for i in 0..<self.map.characters.count {


                if (map[i] == "A") || (map[i] == "U") || (map[i] == "D") {

                    column += 1
                    indexForEmptyColumns = 0
                } else if map[i] == "_" {

                    indexForEmptyColumns += 1

                } else {

                    if indexForEmptyColumns < 4 {

                        row += 1
                    }
                    column = 0
                }
                
                print(self.seats.selected_seats.count)
                
                for index in 0..<self.seats.selected_seats.count {
                    
                    if(((row == (self.seats.selected_seats[index] as AnyObject).row)) && (column == (self.seats.selected_seats[index] as AnyObject).column)) {
                        
                        print("Rita \(row) \(column)")
        
                        var chars = Array(map.characters)
                        chars[i] = "U"
                        map = String(chars)
                    }
                }
            }
            print("RITA: \(map)")
            
            let ref = DataService.ds.REF_CINEMAS.child((self.time?.cityName)!).child((self.time?.cinemaId)!).child("movies").child((self.time?.movieId)!).child("showings").child((self.time?.dateId)!).child("times").child((self.time?.timeId)!).child("seatMap")
            let ref2 = DataService.ds.REF_RESERVATIONS
            let ref3 = DataService.ds.REF_USERS.child((Auth.auth().currentUser?.uid)!).child("reservations")
            
            for index in 0..<self.seats.selected_seats.count {
                
                let reservedSeat = ["Seat": (String((self.seats.selected_seats[index] as AnyObject).row) + "/" + String((self.seats.selected_seats[index] as AnyObject).column))]
                
                reservedSeats.append(reservedSeat)
            }
            let reservationData = ["cinemaId": self.time?.cinemaId,
                                   "cityName": self.time?.cityName,
                                   "movieId": self.time?.movieId,
                                   "dateId": self.time?.dateId,
                                   "timeId": self.time?.timeId,
                                   "userId": Auth.auth().currentUser?.uid,
                                   "tickets": reservedSeats] as [String : Any]
            
            
            let uuid = UUID().uuidString
            let data = [uuid: reservationData]
            
            let userData = ["id": uuid]
            
            ref.setValue(map)
            ref2.updateChildValues(data)
            ref3.childByAutoId().updateChildValues(userData)
            
            seatsSelected.removeAll()
            
            performSegue(withIdentifier: "backToStartVC", sender: nil)
        }
        
        
    }
    
}
