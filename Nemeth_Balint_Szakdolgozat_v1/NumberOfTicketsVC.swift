//
//  NumberOfTicketsVC.swift
//  Nemeth_Balint_Szakdolgozat_v1
//
//  Created by Bálint Németh on 2018. 03. 25..
//  Copyright © 2018. Németh Bálint. All rights reserved.
//

import UIKit

class NumberOfTicketsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var numberForPickerView = [String]()
    var numberOfTickets: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        for index in 1..<21 {
            
            numberForPickerView.append(String(index))
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 20
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return numberForPickerView[row]
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: (pickerLabel?.font.fontName)!, size: 25.0)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = numberForPickerView[row]
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
    @IBAction func okBtnTapped(_ sender: Any) {
        
        numberOfTickets = pickerView.selectedRow(inComponent: 0)
    }
}
