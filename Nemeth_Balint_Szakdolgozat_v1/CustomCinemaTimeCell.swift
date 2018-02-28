//
//  CustomCinemaTimeCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 15..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class CustomCinemaTimeCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    
    func configureCell(time: CustomCinemaShowingTime) {
        
        lbl.text = time.time
        
    }
}
