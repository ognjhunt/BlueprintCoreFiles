//
//  UploadModelTableViewController.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 5/8/22.
//  Copyright © 2022 Placenote. All rights reserved.
//

import UIKit
import ProgressHUD

class UploadModelTableViewController: UITableViewController, UIDocumentPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var pricingTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var accessibilitySwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var uploadImgView: UIView!
    @IBOutlet weak var uploadModelView: UIView!
    
    //var usdzModel = ""
    var category = ""
    var modelName = ""
    var name = ""
    var scale = 1
    var size = 5
    var thumbnail = ""
    var model = "" //for storage
    var image = "" //for storage
    
    var itemCategories = ["Animals & Pets", "Architecture", "Art & Abstract", "Cars & Vehicles", "Characters & Creatures", "Cultural Heritage & History", "Electronics & Gadgets", "Fashion & Style", "Food & Drink", "Furniture & Home", "Nature & Plants", "News & Politics", "People", "Places & Travel", "Science & Technology", "Sports & Fitness", "Weapons & Military"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        nameTextField.delegate = self
        nameTextField.tag = 0
        urlTextField.tag = 1
        urlTextField.delegate = self
        descriptionTextView.tag = 2
        descriptionTextView.delegate = self
        pricingTextField.tag = 3
        pricingTextField.delegate = self
        let uploadModelTap = UITapGestureRecognizer(target: self, action: #selector(uploadModel(_:)))
        uploadModelView.addGestureRecognizer(uploadModelTap)
        
        let uploadImgTap = UITapGestureRecognizer(target: self, action: #selector(uploadImg(_:)))
        uploadImgView.addGestureRecognizer(uploadImgTap)
    }
    
    @IBAction func categoryAction(_ sender: Any) {
        if categoryTableView.isHidden {
            animate(toogle: true, type: categoryBtn)
           // lineView.isHidden = false
            
        } else {
            animate(toogle: false, type: categoryBtn)
           // lineView.isHidden = true
        }
    }
    
    
    @objc func uploadModel(_ sender: UITapGestureRecognizer){
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.pixar.universal-scene-description-mobile"], in: .import)
        documentPicker.delegate = self
        
        documentPicker.modalPresentationStyle = .overCurrentContext
        documentPicker.popoverPresentationController?.sourceView = self.view
       // documentPicker.popoverPresentationController?.sourceRect = self.view.bounds
        
        DispatchQueue.main.async {
            self.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    var didTap: Bool?
    
    @objc func uploadImg(_ sender: UITapGestureRecognizer){
//        let picker = UIImagePickerController()
//       picker.sourceType = .photoLibrary
//       //picker.allowsEditing = true
//       picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
//       self.present(picker, animated: true, completion: nil)
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
       // picker.mediaTypes = ["public.movie"]
        picker.delegate = self
        present(picker, animated: true) {
            self.didTap = false
        }
    }
    
    func animate(toogle: Bool, type: UIButton) {
        
        if type == categoryBtn {
            
            if toogle {
                UIView.animate(withDuration: 0.3) {
                    self.categoryTableView.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.categoryTableView.isHidden = true
                }
            }
        } else {
            if toogle {
                UIView.animate(withDuration: 0.3) {
                    //   self.lbl.isHidden = false
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    //  self.lbl.isHidden = true
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        self.dismissKeyboard()
        return false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    @IBAction func continueAction(_ sender: Any) {
        var dict = Dictionary<String, Any>()
        
//        if let itemCategory = categoryBtn.titleLabel?.text, !itemCategory.isEmpty {
//            print(itemCategory)
//            dict["category"] = itemCategory
//        }
//
//        if let modelName = categoryBtn.titleLabel?.text, !itemCategory.isEmpty {
//            print(itemCategory)
//            dict["modelName"] = modelName
//        }
//
//        if let name = categoryBtn.titleLabel?.text, !itemCategory.isEmpty {
//            print(itemCategory)
//            dict["name"] = name
//        }
//
//        if let scale = categoryBtn.titleLabel?.text, !itemCategory.isEmpty {
//            print(itemCategory)
//            dict["scale"] = scale
//        }
//
//        if let size = categoryBtn.titleLabel?.text, !itemCategory.isEmpty {
//            print(itemCategory)
//            dict["size"] = size
//        }
//
//        if let thumbnail = categoryBtn.titleLabel?.text, !itemCategory.isEmpty {
//            print(itemCategory)
//            dict["thumbnail"] = thumbnail
//        }
//
//
//        ProgressHUD.show()
//        Api.Model.saveModelProfile(dict: dict, onSuccess: {
//            if let img = self.image {
//                StorageService.savePhotoProfile(image: img, uid: Api.User.currentUserId, onSuccess: {
//                    ProgressHUD.showSuccess()
//                }) { (errorMessage) in
//                    ProgressHUD.showError(errorMessage)
//                }
//            } else {
//                ProgressHUD.showSuccess()
//            }
//
//        }) { (errorMessage) in
//            ProgressHUD.showError(errorMessage)
//        }}
//    //        if user.needs != nil || user.skills != nil || user.companySummary != nil{
//    //            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
//    //            let companyTypeVC = storyboard.instantiateViewController(withIdentifier: IDENTIFER_SETTINGS) as! SettingsTableViewController
//    //            self.navigationController?.pushViewController(companyTypeVC, animated: true)
//    //        } else {
//    if navigationController == nil {
//        (UIApplication.shared.delegate as! AppDelegate).configurePricingPlanViewController()
//    } else {
//        self.navigationController?.popViewController(animated: true)
//        //            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
//        //            let dealVC = storyboard.instantiateViewController(withIdentifier: IDENTIFER_SETTINGS) as! SettingsTableViewController
//        //
//        //            self.navigationController?.pushViewController(dealVC, animated: true)
//    }
//    //  }
//    //if changing in settings, go back to settingsVC
//    ProgressHUD.dismiss()
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if tableView == categoryTableView {
            return 1
        }
        return 8
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        if tableView == categoryTableView {
//            return itemCategories.count
//        }
        if section == 7 {
            return 2
        }
        return 1
    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if tableView == categoryTableView{
//            let cell = categoryTableView.dequeueReusableCell(withIdentifier: IDENTIFIER_ITEM_CATEGORY_TYPE, for: indexPath)
//            cell.textLabel?.text = itemCategories[indexPath.row]
//            return cell
//        }
//        if indexPath.row == 0 {
//              tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UploadModelCell")
//              let cell = tableView.dequeueReusableCell(withIdentifier: "UploadModelCell", for: indexPath)
//
//              tableView.rowHeight = 405
//              return cell
//          }
//        if indexPath.row == 1 {
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NameItemCell")
//              let cell = tableView.dequeueReusableCell(withIdentifier: "NameItemCell", for: indexPath)
//
//              tableView.rowHeight = 142
//              return cell
//          }
//          if indexPath.row == 2 {
//              tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UploadImageCell")
//              let cell = tableView.dequeueReusableCell(withIdentifier: "UploadImageCell", for: indexPath)
//              tableView.rowHeight = 352
//              return cell
//          }
//       if indexPath.row == 3 {
//           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "URLCell")
//           let cell = tableView.dequeueReusableCell(withIdentifier: "URLCell", for: indexPath)
//           tableView.rowHeight = 142
//           return cell
//       }
//        if indexPath.row == 4 {
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCategoryCell")
//              let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCategoryCell", for: indexPath)
//
//             tableView.rowHeight = 377
//              return cell
//          }
//        if indexPath.row == 5 {
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AccessibilityCell")
//              let cell = tableView.dequeueReusableCell(withIdentifier: "AccessibilityCell", for: indexPath)
//
//              tableView.rowHeight = 138
//              return cell
//          }
//          if indexPath.row == 6 {
//              tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemDescriptionCell")
//              let cell = tableView.dequeueReusableCell(withIdentifier: "ItemDescriptionCell", for: indexPath)
//              tableView.rowHeight = 230
//              return cell
//          }
//       if indexPath.row == 7 {
//           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemPricingCell")
//           let cell = tableView.dequeueReusableCell(withIdentifier: "ItemPricingCell", for: indexPath)
//           tableView.rowHeight = 155
//           return cell
//       }
//        if indexPath.row == 8 {
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContinueCell")
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ContinueCell", for: indexPath)
//            tableView.rowHeight = 70
//            return cell
//        }
//        return UITableViewCell()
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryBtn.setTitle("\(itemCategories[indexPath.row])", for: .normal)
        animate(toogle: false, type: categoryBtn)
        //lineView.isHidden = true
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        readFile(url)
    }
    
    
    func showFilePickerForLoadingScan() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["com.apple.arobject"], in: .import)
        documentPicker.delegate = self
        
        documentPicker.modalPresentationStyle = .overCurrentContext
     //   documentPicker.popoverPresentationController?.barButtonItem = mergeScanButton
        
        DispatchQueue.main.async {
            self.present(documentPicker, animated: true, completion: nil)
        }
    }
    
    func readFile(_ url: URL) {
        if url.pathExtension == "arobject" {
     //       loadReferenceObjectToMerge(from: url)
        } else if url.pathExtension == "usdz" {
      //      modelURL = url
        }
    }



}
