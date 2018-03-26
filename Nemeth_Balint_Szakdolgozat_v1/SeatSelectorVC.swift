//
//  SeatSelectorVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 03. 26..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class SeatSelectorVC: UIViewController, ZSeatSelectorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let map2:String =   "_DDDDDD_DDDDDD_DDDDDDDD_/" +
                            "_AAAAAA_AAAAAA_DUUUAAAA_/" +
                            "________________________/" +
                            "_AAAAAUUAAAUAAAAUAAAAAAA/" +
                            "_UAAUUUUUUUUUUUUUUUAAAAA/" +
                            "_AAAAAAAAAAAUUUUUUUAAAAA/" +
                            "_AAAAAAAAUAAAAUUUUAAAAAA/" +
                            "_AAAAAUUUAUAUAUAUUUAAAAA/"
        
        let seats2 = ZSeatSelector()
        seats2.frame = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: 600)
        seats2.setSeatSize(CGSize(width: 30, height: 30))
        seats2.setAvailableImage(   UIImage(named: "A")!,
                                    andUnavailableImage:    UIImage(named: "U")!,
                                    andDisabledImage:       UIImage(named: "D")!,
                                    andSelectedImage:       UIImage(named: "S")!)
        seats2.layout_type = "Normal"
        seats2.setMap(map2)
        seats2.seat_price           = 5.0
        seats2.selected_seat_limit  = 2
        seats2.seatSelectorDelegate = self
        seats2.maximumZoomScale         = 5.0
        seats2.minimumZoomScale         = 0.05
        self.view.addSubview(seats2)
    }
    
    func seatSelected(_ seat: ZSeat) {
        //print("Seat at row: \(seat.row) and column: \(seat.column)\n")
    }
    
    func getSelectedSeats(_ seats: NSMutableArray) {
        var total:Float = 0.0;
        for i in 0..<seats.count {
            let seat:ZSeat  = seats.object(at: i) as! ZSeat
            print("Seat at row: \(seat.row) and column: \(seat.column)\n")
            total += seat.price
        }
        print("----- Total -----\n")
        print("----- \(total) -----\n")
    }

}
