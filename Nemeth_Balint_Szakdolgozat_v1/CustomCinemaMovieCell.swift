//
//  CustomCinemaMovieCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 12..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class CustomCinemaMovieCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    
    func configureCell(movie: CustomCinemaMovie) {
        
        lbl.text = movie.name
    }

}
