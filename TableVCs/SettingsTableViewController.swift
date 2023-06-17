//
//  SettingsTableViewController.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 12/22/20.
//  Copyright © 2020 Placenote. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  if interface
       
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var next1 = storyboard.instantiateViewController(withIdentifier: "LibraryVC") as! LibraryViewController
           // next.modalPresentationStyle = .fullScreen
            self.present(next1, animated: true, completion: nil)
        }
        if indexPath.section == 0 && indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var next = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileViewController
            //next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var next = storyboard.instantiateViewController(withIdentifier: "HomeTableVC") as! HomeTableViewController
            //next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 4
        } else if section == 1 {
            return 2
        } else if section == 2{
            return 5
        } else if section == 3{
            return 1
        } else if section == 4{
            return 1
        } else if section == 5{
            return 2
        }
        
        else {
            return 3
        }}

    
    @IBAction func logoutAction(_ sender: Any) {
        let alert = UIAlertController(title: "Logout?", message: "Are you sure you want to logout of Blueprint?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { alert in
            
            FirebaseAuthHelper.signOut() {
                self.dismiss(animated: true, completion: nil)
                let navController = UINavigationController(rootViewController: LaunchViewController())
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: false, completion: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}
