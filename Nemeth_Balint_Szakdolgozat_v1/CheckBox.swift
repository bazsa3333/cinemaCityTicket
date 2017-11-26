//
//  CheckBox.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2017. 11. 26..
//  Copyright © 2017. Németh Bálint. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    let checkedImage = UIImage(named: "checkedSign")
    let uncheckedImage = UIImage(named: "uncheckedSign")
    
    var isChecked: Bool = false {
        
        didSet{
            
            if isChecked == true {
                self.setImage(checkedImage, for: UIControlState.normal)
            } else {
                
                self.setImage(uncheckedImage, for: UIControlState.normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked(sender:)), for: UIControlEvents.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton){
        
        if sender == self {
            
            isChecked = !isChecked
        }
    }

}
