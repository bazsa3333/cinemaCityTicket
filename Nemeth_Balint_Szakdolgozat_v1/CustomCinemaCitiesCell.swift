//
//  CustomCinemaCitiesCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 10..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class CustomCinemaCitiesCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    
    func configureCell(cities: CustomCinemaCity) {
        
        lbl.text = cities.name
    }
}
