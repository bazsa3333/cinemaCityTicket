//
//  PopUpForMoviesInfoVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 02. 28..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class PopUpForMoviesInfoVC: UIViewController {

    var movie: CustomCinemaMovie!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var lenghtLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.image = UIImage(named: movie.picture)
        titleLbl.text = movie.name
        genreLbl.text = movie.genre
        yearLbl.text = movie.release
        ratingLbl.text = movie.rating
        descriptionLbl.text = movie.description
        lenghtLbl.text = movie.length
        
        descriptionLbl.sizeToFit()
    }

    @IBAction func okBtnTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
