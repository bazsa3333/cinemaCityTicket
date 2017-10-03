//
//  ShowingCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 10. 01..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit

class ShowingCell: UITableViewCell {
    
    @IBOutlet weak var lbl: UILabel!

    func configureCell(showing: Showing){
        
        lbl.text = showing.name
    }
}
