//
//  ContentDetailsTableViewController.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 11/24/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import ProgressHUD

class ContentDetailsTableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    
    let db = Firestore.firestore()
    
    var name = ""
    var descriptionText = ""
    
    var price = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.overrideUserInterfaceStyle = .light
        self.navigationController?.title = "Upload"
        let dismissKey = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKey)
        
        tableView.register(GeneratedContentImageTableViewCell.self, forCellReuseIdentifier: "contentImageCell")
        tableView.register(UploadContentTableViewCell.self, forCellReuseIdentifier: "saveContentCell")
        tableView.register(ContentPromptTableViewCell.self, forCellReuseIdentifier: "contentPromptCell")
        tableView.register(ContentDescriptionTableViewCell.self, forCellReuseIdentifier: "contentDescriptionCell")
        tableView.register(ContentPriceTableViewCell.self, forCellReuseIdentifier: "contentPriceCell")
        tableView.register(ContentPublicTableViewCell.self, forCellReuseIdentifier: "contentPublicCell")
        tableView.register(ContentNameTableViewCell.self, forCellReuseIdentifier: "contentNameCell")

        // add insets to text field and text view
    }
    
    func generateRandomModelID(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    @objc func uploadImage(){
      //  let data = self.photoAnchorImageView.image?.jpegData(compressionQuality: 0.5)
        guard let data = UserDefaults.standard.data(forKey: "image") else { return }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
      //  image1 = UIImage(data: decoded)
    //    self.contentImageView.image = image1
        let image = UIImage(data: decoded)
        guard let imageData = image?.jpegData(compressionQuality: 0.5) else { return  }
        
        StorageManager.uploadThumbnail(withData: imageData) { success in
            
            if (success == nil) {
                return self.alertAndDismiss("We're sorry, your image cannot be uploaded at this time. Please try again")
            }
        }
    }
    
    @objc func uploadContent(){
        if Auth.auth().currentUser != nil{
            let index = IndexPath(row: 1, section: 0)
            let cell: ContentNameTableViewCell = self.tableView.cellForRow(at: index) as! ContentNameTableViewCell
            self.name = cell.nameTextField.text ?? ""
            
            let index1 = IndexPath(row: 5, section: 0)
            let cell1: ContentPriceTableViewCell = self.tableView.cellForRow(at: index1) as! ContentPriceTableViewCell
            let text = cell1.priceTextField.text ?? ""
            self.price = Int(text)!
            
            let index2 = IndexPath(row: 3, section: 0)
            let cell2: ContentDescriptionTableViewCell = self.tableView.cellForRow(at: index2) as! ContentDescriptionTableViewCell
            self.descriptionText = cell2.descriptionTextView.text ?? ""
            
            
            if self.name != "" && self.name != " " {
                ProgressHUD.show("Loading")
                self.uploadImage()
                
                let id = self.generateRandomModelID(length: 20)
                
                self.db.collection("models").document(id).setData([
                    "creatorId" : Auth.auth().currentUser?.uid ?? "",
                    "likes" : 0,
                    "comments" : 0,
                    "name" : self.name,
                    "description" : self.descriptionText,
                    "category" : "art",
                    "id" : id,
                    "isPublic" : true,
                    "date" : Date(),
                    "modelName" : "",
                    "productLink" : "",
                    "scale" : 1,
                    "prompt": "",
                    "price" : self.price,
                    "thumbnail" : StorageManager.thumbnailRandomID,
                    "size" : 0,
                ])
                
                let docRef2 = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
                docRef2.updateData([
                    "uploadedContentCount": FieldValue.increment(Int64(1))
                ])
                
                ProgressHUD.dismiss()
                let defaults = UserDefaults.standard
                
            //    defaults.set("\(self.modelUid ?? "")", forKey: "modelUid")
                defaults.set(true, forKey: "showCreationSuccess")
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                //have success message in LaunchVC - saying its in Library or Profile
            } else {
                self.nameAlert()
                return
            }
            
        } else {
                self.createAccountAlert()
                return
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
    
    var activeTextField = UITextField()

       // Assign the newly active text field to your activeTextField variable
       func textFieldDidBeginEditing(_ textField: UITextField) {

            self.activeTextField = textField
       }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

//        if activeTextField == usernameTextField {
//            if textField.text?.isEmpty == false {
//               checkUsername(field: textField.text!) { (success) in
//                    if success == true {
//                        print("Username is taken")
//                        // Perform some action
//                        self.signUpBtn.isEnabled = false
//                        self.signUpBtn.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 242/255, alpha: 1.0)
//                        self.signUpBtn.setTitleColor(UIColor.darkGray, for: .normal)
//                    } else {
//                        print("Username is not taken")
//                        // Perform some action
//                        self.signUpBtn.isEnabled = true
//                        self.signUpBtn.backgroundColor = UIColor(red: 66/255, green: 126/255, blue: 250/255, alpha: 1.0)
//                        self.signUpBtn.setTitleColor(UIColor.white, for: .normal)
//                    }
//                }
//            }
//        }

    }

    @objc func dismissKeyboard() {
      //  searchBar.isHidden = true
        view.endEditing(true)
    }
    
    @IBAction func priceAlert(_ sender: Any) {
        let alertController = UIAlertController(title: "Pricing", message: "This is the amount you decide to sell your created content for on Blueprint's Marketplace. Whenever a user purchases this content, you'll earn the set amount of credits.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
           

        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func publicAlert(_ sender: Any) {
        let alertController = UIAlertController(title: "Blueprint Marketplace", message: "Making your content public allows it to be shown on Blueprint's Marketplace for other users to find and use in their designs. Making it private, means that only you can see it within your profile.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
           

        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func nameAlert(){
        let alertController = UIAlertController(title: "Name Your Work", message: "This is the name that other users will see on the Markteplace or on your Profile.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (_) in
           

        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadContentAction(_ sender: Any) {
        if Auth.auth().currentUser != nil{
            FirestoreManager.getUser(Auth.auth().currentUser?.uid ?? "") { user in
                
                if user?.points ?? 0 < 10 {
                    self.buyPointsAlert()
                } else {
                    // EXCHANGE POINTS, SAVE CONTENT TO PROFILE, UPLOAD CONTENT TO MARKETPLACE
                }
            }} else {
                self.createAccountAlert()
            }
    }
    
    func createAccountAlert(){
        let alertController = UIAlertController(title: "Create Blueprint Account", message: "To save and upload generated content to Blueprint's Marketplace, you must first create an account.", preferredStyle: .alert)
        let purchaseAction = UIAlertAction(title: "Sign Up", style: .default, handler: { (_) in
           // GO TO PURCHASE POINTS VC -- DO NOT LOSE GENERATED CONTENT
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var next = storyboard.instantiateViewController(withIdentifier: "CreateAccountVC") as! CreateAccountViewController
            //next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        })
       
        alertController.addAction(purchaseAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func buyPointsAlert() {
        let alertController = UIAlertController(title: "Not Enough Points :/", message: "To save and upload generated content to Blueprint's Marketplace, it requires 10 points per piece of content. You can add points to your account now.", preferredStyle: .alert)
        let purchaseAction = UIAlertAction(title: "Purchase", style: .default, handler: { (_) in
           // GO TO PURCHASE POINTS VC -- DO NOT LOSE GENERATED CONTENT
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            var next = storyboard.instantiateViewController(withIdentifier: "PurchasePointsVC") as! PurchasePointsViewController
            next.modalPresentationStyle = .fullScreen
            self.present(next, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        })
       
        alertController.addAction(purchaseAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Optional"
            textView.textColor = UIColor.lightGray
        } else {
//            if self.modelBtn.backgroundColor == .systemBlue || self.imageBtn.backgroundColor == .systemBlue {
//                self.createBtn.backgroundColor = .tintColor
//            } else {
//                self.createBtn.backgroundColor = UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1)
//            }
        }
    
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }

   // contentImageCell
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GeneratedContentImageTableViewCell.identifier, for: indexPath) as? GeneratedContentImageTableViewCell else {
                return UITableViewCell()
            }
           // let cell = tableView.dequeueReusableCell(withIdentifier: "contentImageCell", for: indexPath)
            cell.configureImage()
            tableView.rowHeight = 160
              return cell
          }
          if indexPath.row == 1 {
              guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentNameTableViewCell.identifier, for: indexPath) as? ContentNameTableViewCell else {
                  return UITableViewCell()
              }
              tableView.rowHeight = 96
            //  name = cell.nameTextField.text ?? ""
                return cell
          }
           if indexPath.row == 2 {
               guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentPromptTableViewCell.identifier, for: indexPath) as? ContentPromptTableViewCell else {
                   return UITableViewCell()
               }
               tableView.rowHeight = 96
                 return cell
           }
        if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentDescriptionTableViewCell.identifier, for: indexPath) as? ContentDescriptionTableViewCell else {
                return UITableViewCell()
            }
            tableView.rowHeight = 126
              return cell
        }
        if indexPath.row == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentPublicTableViewCell.identifier, for: indexPath) as? ContentPublicTableViewCell else {
                return UITableViewCell()
            }
            tableView.rowHeight = 60
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.publicAlert))
            cell.infoImageView.addGestureRecognizer(tap)
            return cell
        }
        if indexPath.row == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentPriceTableViewCell.identifier, for: indexPath) as? ContentPriceTableViewCell else {
                return UITableViewCell()
            }
            tableView.rowHeight = 60
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.priceAlert))
            cell.infoImageView.addGestureRecognizer(tap)
            
            let text = cell.priceTextField.text
          //  price = Int(text ?? "")!
            
            return cell
        }
        
        if indexPath.row == 6 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UploadContentTableViewCell.identifier, for: indexPath) as? UploadContentTableViewCell else {
                return UITableViewCell()
            }
          //  let cell = tableView.dequeueReusableCell(withIdentifier: "saveContentCell", for: indexPath)
            tableView.rowHeight = 70
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.uploadContent))
            cell.uploadButton.addGestureRecognizer(tap)
            return cell
        }

         return UITableViewCell()
    }
}
