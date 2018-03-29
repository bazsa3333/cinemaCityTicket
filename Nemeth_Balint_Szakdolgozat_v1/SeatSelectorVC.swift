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
    
    var map2: String!
    let seats2 = ZSeatSelector()
    
//    var map2:String =   "_DDDDDD_DDDDDD_DDDDDDDD_/" +
//                        "_AAAAAA_AAAAAA_DUUUAAAA_/" +
//                        "________________________/" +
//                        "_AAAAAUUAAAUAAAAUAAAAAAA/" +
//                        "_UAAUUUUUUUUUUUUUUUAAAAA/" +
//                        "_AAAAAAAAAAAUUUUUUUAAAAA/" +
//                        "_AAAAAAAAUAAAAUUUUAAAAAA/" +
//                        "_AAAAAUUUAUAUAUAUUUAAAAA/"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        parseSeats()
        print("Rita: \(self.map2)")
    }
    
    func parseSeats() {
        
        let ref = DataService.ds.REF_CINEMAS.child((self.time?.cityName)!).child((self.time?.cinemaId)!).child("movies").child((self.time?.dateId)!).child("showings").child((self.time?.dateId)!)
        
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            let value = snapshot.value as? Dictionary<String, AnyObject>
            let seatMap = value?["seatMap"] as? String
            
            self.map2 = seatMap!
            
            self.seats2.frame = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: 300)
            self.seats2.setSeatSize(CGSize(width: 25, height: 25))
            self.seats2.setAvailableImage(   UIImage(named: "A")!,
                                             andUnavailableImage:    UIImage(named: "U")!,
                                             andDisabledImage:       UIImage(named: "D")!,
                                             andSelectedImage:       UIImage(named: "S")!)
            self.seats2.layout_type = "Normal"
            self.seats2.setMap(self.map2)
            self.seats2.seat_price           = 5.0
            self.seats2.selected_seat_limit  = self.seatLimit!
            self.seats2.seatSelectorDelegate = self
            self.seats2.maximumZoomScale         = 5.0
            self.seats2.minimumZoomScale         = 0.05
            self.view.addSubview(self.seats2)
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
            total += seat.price
        }
        print("----- Total -----\n")
        print("----- \(total) -----\n")
    }
    
    @IBAction func okBtnTapped(_ sender: Any) {
        
        print("Row: \(seatsSelected[(seatsSelected.count)-2].row), Column: \(seatsSelected[(seatsSelected.count)-2].column)")
        print("Row: \(seatsSelected[(seatsSelected.count)-1].row), Column: \(seatsSelected[(seatsSelected.count)-1].column)")
        
        var column: Int = 0
        var row: Int = 1
        var indexForEmptyColumns: Int = 0
        
        for i in 0..<self.map2.characters.count {
            
            
            if (map2[i] == "A") || (map2[i] == "U") || (map2[i] == "D") {
                
                column += 1
                indexForEmptyColumns = 0
            } else if map2[i] == "_" {
                
                indexForEmptyColumns += 1

            } else {
                
                if indexForEmptyColumns < 4 {
                    
                    row += 1
                }
                column = 0
            }
            
            if ((row == seatsSelected[(seatsSelected.count)-2].row) && (column == seatsSelected[(seatsSelected.count)-2].column)) || ((row == seatsSelected[(seatsSelected.count)-1].row) && (column == seatsSelected[(seatsSelected.count)-1].column)) {
                
                print("Rita \(row) \(column)")
                
                var chars = Array(map2.characters)
                chars[i] = "U"
                map2 = String(chars)
                
                let ref = DataService.ds.REF_CINEMAS.child((self.time?.cityName)!).child((self.time?.cinemaId)!).child("movies").child((self.time?.dateId)!).child("showings").child((self.time?.dateId)!).child("seatMap")
                
                ref.setValue(map2)
                
                performSegue(withIdentifier: "backToStartVC", sender: nil)
            }
        }
        print("RITA: \(map2)")
        seatsSelected.removeAll()
    }
    
}
