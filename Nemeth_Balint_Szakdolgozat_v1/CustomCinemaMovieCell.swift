//
//  CustomCinemaMovieCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 12..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

protocol CustomCinemaMovieCellDelegate {
    
    func infoBtnTapped(cell: UITableViewCell)
}

class CustomCinemaMovieCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var delegate: CustomCinemaMovieCellDelegate!
    
    func configureCell(movie: CustomCinemaMovie) {
        
        lbl.text = movie.name
        imgView.image = UIImage(named: movie.picture)
    }
    
    @IBAction func infoBtnTapped(_ sender: UIButton) {
        
        delegate.infoBtnTapped(cell: self)
    }
    
}
