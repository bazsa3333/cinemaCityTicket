//
//  CustomCinemaCinemaCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 11..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class CustomCinemaCinemaCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!
    
    func configureCell(cinema: CustomCinemaCinema) {
        
        lbl.text = cinema.name
    }
}
