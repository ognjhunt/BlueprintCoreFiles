//
//  NetworkPasswordTableViewController.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 9/18/22.
//

import UIKit
import ProgressHUD
import FirebaseFirestore
import SCLAlertView
import FirebaseAuth
import FirebaseStorage

class NetworkPasswordTableViewController: UITableViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    
    var blueprintUid  : String!
    
    var network: Blueprint!
    
    let db = Firestore.firestore()
    
    
    internal static func instantiate(with blueprintId: String) -> NetworkPasswordTableViewController {

        let vc = UIStoryboard(name: "Networks", bundle: nil).instantiateViewController(withIdentifier: "NetworkPasswordVC") as! NetworkPasswordTableViewController
        vc.blueprintUid = blueprintId
        return vc
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
       
    }

    func reloadData(){
        FirestoreManager.getBlueprint(blueprintUid) { network in
       //     self.navigationController?.title = network?.name
            self.network = network
            self.passwordTextField.text = network?.password
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        guard let network = network else {
            return
        }
     //   let newPassword = passwordTextField.text?.trimmingCharacters(in: <#T##CharacterSet#>)
        // no changes made
        if (passwordTextField.text == network.password){
          //  navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
        }
        
        ProgressHUD.show()
        
        // ----------  validate fields ----------
        if !validateFields() { return }
    
                 
             
                
        // ---------- create update doc ----------
        var updateDoc = [String:Any]()
                 if self.passwordTextField.text != network.password {
            //updateDoc[user.username] = usernameTextField.text
            
           let docRef = self.db.collection("blueprints").document(blueprintUid)
             if let newPassword = passwordTextField.text, !newPassword.isEmpty, newPassword != network.password {
                 // Update the password field in Firestore
                 docRef.updateData([
                     "password": newPassword,
                     "visibility": "private"
                 ])
                 // Rest of the code...
             }
             ProgressHUD.dismiss()
                 
                         
     //            let profileVC = self.navigationController?.viewControllers.first as? ProfileViewController
             let profileVC = self.navigationController?.viewControllers.first as? UserProfileViewController
                // profileVC?.collectionView.refreshControl?.beginRefreshing()
               //  profileVC?.reloadData()
                 self.dismiss(animated: true) //navigationController?.popViewController(animated: true)
       }
    }
    
    private func alertAndDismiss(_ message: String) {
        
        //activityIndicator.stopAnimating()
        ProgressHUD.dismiss()
        
        view.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Uh oh!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func validateFields() -> Bool {

        // ------- username -------
        guard let username = passwordTextField.text, username != "" else {
            alertAndDismiss("Network Name cannot be empty")
            return false
        }
        return true
    
    }
}
