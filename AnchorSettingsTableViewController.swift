//
//  AnchorSettingsTableViewController.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 10/16/22.
//

import UIKit
import FirebaseFirestore

class AnchorSettingsTableViewController: UITableViewController {

    @IBOutlet weak var interactionSwitch: UISwitch!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var anchorNameLabel: UILabel!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
    }
    
    func reloadData(){
        let defaults = UserDefaults.standard
        let id = defaults.value(forKey: "selectedAnchorID") // .set(String(tappedEntity.id), forKey: "selectedAnchorID")
        FirestoreManager.getSessionAnchor(id as! String) { anchor in
            self.anchorNameLabel.text = anchor?.name
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM d',' h:mm a" //"HH:mm:ss" // "MMM dd, yyyy"
            let date = dateFormatterPrint.string(from: anchor!.timeStamp)
            self.dateLabel.text = "\(String(describing: date))"
            if (anchor?.isPublic == true) {
                self.publicSwitch.isOn = true
            } else {
                self.publicSwitch.isOn = false
            }
         //   dateLabel.text = anchor.timestamp
        }
    }

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 3
        } else if section == 1 {
            return 1
        } else {
            return 1
        }
    }

    @IBAction func publicSwitchAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        let id = defaults.value(forKey: "selectedAnchorID")
        if publicSwitch.isOn {
            let docRef = self.db.collection("sessionAnchors").document(id as! String)

            docRef.updateData([
                "isPublic" : true
            ])
        } else {
            let docRef = self.db.collection("sessionAnchors").document(id as! String)

            docRef.updateData([
                "isPublic" : false
            ])
        }
    }
    
    
    @IBAction func interactionSwitchAction(_ sender: Any) {
    }
    
    @IBAction func removeAction(_ sender: Any) {
    }
    
}
