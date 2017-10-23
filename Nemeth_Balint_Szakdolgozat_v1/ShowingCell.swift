//
//  ShowingCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 03..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit

class ShowingCell: UITableViewCell {
    
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    func configureCell(showing: Showing) {
        
        dateLbl.text = showing.date
        timeLbl.text = showing.time
    }
}
