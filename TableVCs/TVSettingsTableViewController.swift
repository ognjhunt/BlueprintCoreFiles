//
//  TVSettingsTableViewController.swift
//  ARKitInteraction
//
//  Created by Nijel Hunt on 6/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class TVSettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var widthSlider: UISlider!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var enableTouchScreenSwitch: UISwitch!
    @IBOutlet weak var noBorderImg: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var handPalmImg: UIImageView!
    @IBOutlet weak var updateNowBtn: UIButton!
    @IBOutlet weak var autoUpdateBtn: UIButton!
    @IBOutlet weak var heightSliderLabel: UILabel!
    @IBOutlet weak var widthSliderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        borderView.layer.borderColor = UIColor.link.cgColor
        borderView.layer.borderWidth = 3
//        handPalmImg.layer.borderColor = UIColor.link.cgColor
//        handPalmImg.layer.borderWidth = 3
        updateNowBtn.layer.borderColor = UIColor.darkGray.cgColor
        updateNowBtn.layer.borderWidth = 1
        updateNowBtn.layer.cornerRadius = 6
        
        autoUpdateBtn.layer.borderColor = UIColor.darkGray.cgColor
        autoUpdateBtn.layer.borderWidth = 1
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(noBorderClick))
        noBorderImg.addGestureRecognizer(tapGesture)
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(borderClick))
        borderView.addGestureRecognizer(tapGesture1)
        
        widthSliderLabel.text = ("\(widthSlider.value) in")
        heightSliderLabel.text = ("\(heightSlider.value) in")
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 2
        }
        if section == 1 {
            return 1
        }
        if section == 2{
            return 1
        }
        else {
            return 1
        }
    }
    
    @IBAction func heightSliderValueChanged(_ sender: Any) {
        print(Double(heightSlider.value))

        let myDouble = Double(heightSlider.value)
            
            let doubleStr = String(format: "%.2f", myDouble)

                       heightSliderLabel.text = "\(doubleStr) in"


    }
    
    @IBAction func widthSliderValueChanged(_ sender: Any) {
        print(Double(widthSlider.value))
        let myDouble = Double(widthSlider.value)
        
        let doubleStr = String(format: "%.2f", myDouble)

                   widthSliderLabel.text = "\(doubleStr) in"


    }
    
    
    
    @objc func noBorderClick(){
       // borderView.layer.borderColor = UIColor.link.cgColor
        borderView.layer.borderWidth = 0
        noBorderImg.layer.borderColor = UIColor.link.cgColor
        noBorderImg.layer.borderWidth = 3
        print("ya click")
    }
    
    @objc func borderClick(){
        noBorderImg.layer.borderWidth = 0
        borderView.layer.borderColor = UIColor.link.cgColor
        borderView.layer.borderWidth = 3
        print("yeet click")
    }
    
    @IBAction func borderAction(_ sender: Any) {
        noBorderImg.layer.borderWidth = 0
               borderView.layer.borderColor = UIColor.link.cgColor
               borderView.layer.borderWidth = 3
               print("yeet click")
    }
    
    
    @IBAction func noBorderAction(_ sender: Any) {
        borderView.layer.borderWidth = 0
        noBorderImg.layer.borderColor = UIColor.link.cgColor
        noBorderImg.layer.borderWidth = 3
        print("ya click")
    }
    
}
