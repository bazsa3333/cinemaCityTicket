//
//  CustomCinemaMovieCell.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 12..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit
import Firebase

protocol CustomCinemaMovieCellDelegate {
    
    func infoBtnTapped(cell: UITableViewCell)
}

class CustomCinemaMovieCell: UITableViewCell {

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var comingOutLbl: UILabel!
    
    var delegate: CustomCinemaMovieCellDelegate!
    
    func configureCell(movie: CustomCinemaMovie) {
        
        lbl.text = movie.name
        
        let storageRef = Storage.storage().reference(forURL: movie.picture)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                
                print(error.localizedDescription)
            } else {
                
                self.imgView.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func infoBtnTapped(_ sender: UIButton) {
        
        delegate.infoBtnTapped(cell: self)
    }
    
}
