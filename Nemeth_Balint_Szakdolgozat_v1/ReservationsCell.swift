//
//  ReservationsCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 04. 25..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class ReservationsCell: UITableViewCell {

    @IBOutlet weak var movieNameLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var reservationsLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var cinemaLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(reservations: Reservation) {
        
        movieNameLbl.text = reservations.name
        dateLbl.text = reservations.date
        reservationsLbl.text = reservations.seats
        timeLbl.text = reservations.time
        cinemaLbl.text = reservations.cinemaName
    }
}
