//
//  SharingSettingsTableViewController.swift
//  ARKitInteraction
//
//  Created by Nijel Hunt on 6/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SharingSettingsTableViewController: UITableViewController {

    @IBOutlet weak var enableEditingSwitch: UISwitch!
    @IBOutlet weak var infoBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if section == 0{
                   return 1
               }
               else {
                   return 1
               }
               
    }
    
    @IBAction func addGroupAction(_ sender: Any) {
    }
    
    @IBAction func infoAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Sharing", message: "Sharing enables users to share their experience with other people in their vicinity. When clicking the 'Share' button, COMPANY will ______ and you will be able to choose with whom to share your world with. Once you've shared, other users will be able to see everything that you see within the COMPANY app.", preferredStyle: .actionSheet)
                      
              let action1 = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in
                  print("You've pressed default");
              }
        

              alertController.addAction(action1)
              self.present(alertController, animated: true, completion: nil)
    }
    
}
