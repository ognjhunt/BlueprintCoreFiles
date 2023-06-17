//
//  ComputerSettingsTableViewController.swift
//  ARKitInteraction
//
//  Created by Nijel Hunt on 6/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class ComputerSettingsTableViewController: UITableViewController {
    
    
    @IBOutlet weak var ramSliderLabel: UILabel!
    @IBOutlet weak var ramSlider: UISlider!
    @IBOutlet weak var widthSlider: UISlider!
          @IBOutlet weak var heightSlider: UISlider!
       @IBOutlet weak var heightSliderLabel: UILabel!
       @IBOutlet weak var widthSliderLabel: UILabel!
    @IBOutlet weak var noBorderBtn: UIButton!
    @IBOutlet weak var borderBtn: UIButton!
    @IBOutlet weak var enableTouchScreenSwitch: UISwitch!
    @IBOutlet weak var noBorderImg: UIImageView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var oneFingerTapImg: UIImageView!
    @IBOutlet weak var doubleTapImg: UIImageView!
    @IBOutlet weak var computerKeyboardImg: UIImageView!
    @IBOutlet weak var appleKeyboardImg: UIImageView!
    @IBOutlet weak var updateNowBtn: UIButton!
    @IBOutlet weak var autoUpdateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        borderView.layer.borderColor = UIColor.link.cgColor
        borderView.layer.borderWidth = 3
        oneFingerTapImg.layer.borderColor = UIColor.link.cgColor
        oneFingerTapImg.layer.borderWidth = 3
        
        computerKeyboardImg.layer.borderColor = UIColor.link.cgColor
        computerKeyboardImg.layer.borderWidth = 3
        updateNowBtn.layer.borderColor = UIColor.darkGray.cgColor
        updateNowBtn.layer.borderWidth = 1
        updateNowBtn.layer.cornerRadius = 6
        
        autoUpdateBtn.layer.borderColor = UIColor.darkGray.cgColor
        autoUpdateBtn.layer.borderWidth = 1
        
        borderView.layer.cornerRadius = 4
        
        widthSliderLabel.text = ("\(widthSlider.value) in")
        heightSliderLabel.text = ("\(heightSlider.value) in")
        ramSliderLabel.text = ("\(ramSlider.value) GB")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }
    
    @IBAction func ramSliderValueChanged(_ sender: Any) {
          print(Double(ramSlider.value))
          let myDouble = Double(ramSlider.value)
          
          let doubleStr = String(format: "%.2f", myDouble)

                     ramSliderLabel.text = "\(doubleStr) GB"
      }
    
    @IBAction func doubleTapAction(_ sender: Any) {
        oneFingerTapImg.layer.borderWidth = 0
        doubleTapImg.layer.borderColor = UIColor.link.cgColor
        doubleTapImg.layer.borderWidth = 3
        print("ya click")
    }
    
    @IBAction func oneFingerTapAction(_ sender: Any) {
        doubleTapImg.layer.borderWidth = 0
        oneFingerTapImg.layer.borderColor = UIColor.link.cgColor
        oneFingerTapImg.layer.borderWidth = 3
        print("ya click")
    }
    
    @IBAction func noBorderAction(_ sender: Any) {
        borderView.layer.borderWidth = 0
        noBorderImg.layer.borderColor = UIColor.link.cgColor
        noBorderImg.layer.borderWidth = 3
        print("ya click")
    }
    
    @IBAction func borderAction(_ sender: Any) {
        noBorderImg.layer.borderWidth = 0
        borderView.layer.borderColor = UIColor.link.cgColor
        borderView.layer.borderWidth = 3
        print("yeet click")
    }
    
    @IBAction func computerKeyboardAction(_ sender: Any) {
        appleKeyboardImg.layer.borderWidth = 0
               computerKeyboardImg.layer.borderColor = UIColor.link.cgColor
               computerKeyboardImg.layer.borderWidth = 3
               print("yeet click")
    }
    
    @IBAction func appleKeyboardAction(_ sender: Any) {
        computerKeyboardImg.layer.borderWidth = 0
               appleKeyboardImg.layer.borderColor = UIColor.link.cgColor
               appleKeyboardImg.layer.borderWidth = 3
               print("yeet click")
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
        if section == 3{
            return 1
        }
        if section == 4{
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

}
