//
//  NetworkSettingsTableViewController.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 11/28/20.
//  Copyright © 2020 Placenote. All rights reserved.
//

import UIKit
//import GoogleMaps
import FirebaseFirestore
import CoreLocation
import FirebaseAuth

class NetworkSettingsTableViewController: UITableViewController {
    
  //  var networkID = "tjE4kKQsr2ddaphZ2XMi"
    var network: Blueprint!
    var isPublic = true
//    var isCurrentlyConnected : Bool?
    var locationManager: CLLocationManager!
    var user: User!
    private let networkUid     : String = ""
    
    var blueprintUid  : String! //      : String
    var modelName = ""
    var model           : Model!
    
    let db = Firestore.firestore()

    @IBOutlet weak var networkPasswordLabel: UILabel!
    @IBOutlet weak var networkDateLabel: UILabel!
    @IBOutlet weak var networkLocationLabel: UILabel!
    @IBOutlet weak var networkSizeLabel: UILabel!
    @IBOutlet weak var networkIDLabel: UILabel!
    @IBOutlet weak var networkNameLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    

    
    internal static func instantiate(with blueprintId: String) -> NetworkSettingsTableViewController {
        let vc = UIStoryboard(name: "Networks", bundle: nil).instantiateViewController(withIdentifier: "NetworkSettingsVC") as! NetworkSettingsTableViewController
        vc.blueprintUid = blueprintId
        return vc
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
  //      reloadData()
    }
    
    func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        
      // 1
//      let geocoder = GMSGeocoder()
//        
//      // 2
//      geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
//        guard let address = response?.firstResult(), let lines = address.lines else {
//          return
//        }
//          
//        // 3
//   //     self.addressLabel.text = lines.joined(separator: "\n")
//          print(lines.joined(separator: "\n"))
//          print("is lines joined")
//          
//          self.networkLocationLabel.text = "\(address.thoroughfare ?? "")"
//        // 4
////        UIView.animate(withDuration: 0.25) {
////          self.view.layoutIfNeeded()
////        }
//      }
    }
    
    var hostId = ""
    
    func reloadData() {
        FirestoreManager.getBlueprint(blueprintUid) { network in
            self.navigationController?.title = network?.name
            //  self.hostNameLabel.text = network?.host
            self.networkNameLabel.text = network?.name
            self.networkLocationLabel.text = "\(self.reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: (network?.latitude ?? 0) , longitude: (network?.longitude ?? 0))))"
            //   self.networkLocationLabel.text = "\(network?.latitude ?? 0), \(network?.longitude ?? 0)"
            self.networkSizeLabel.text = "\(network?.size ?? 0) MB"
            self.networkIDLabel.text = network?.id
            self.networkPasswordLabel.text = network?.password
            self.hostId = network?.creatorId ?? ""
            
            // Step 1: Retrieve the style document from Firestore
            let styleRef = self.db.collection("blueprints").document(self.blueprintUid)
            styleRef.getDocument { (snapshot, error) in
                guard let document = snapshot else {
                    print("Failed to fetch blueprint document: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                // Retrieve the date field as a Timestamp and convert it to a Date
                if let timestamp = document.data()?["date"] as? Timestamp {
                    print("Timestamp value:", timestamp.dateValue())

                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "MMM dd, yyyy"
                    let date = dateFormatterPrint.string(from: timestamp.dateValue())
                    self.networkDateLabel.text = date
                }
            }

                
                if network?.visibility == "public" {
                    self.isPublic = true
                } else {
                    self.isPublic = false
                }
                if network?.creatorId != nil || network?.creatorId != ""{
                    FirestoreManager.getUser(network?.creatorId ?? "1zMDe5Raoee3At3jjFdjVVRqbIt2") { user in
                        let name = user?.name
                        let username = user?.username
                        if name != nil || name != "" {
                            self.hostNameLabel.text = name
                        } else {
                            self.hostNameLabel.text = username
                        }
                    }
                }
            }
            
        }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
           // FirestoreManager.getNetwork(networkID) { network in
              //  if self.isPublic == true {
              //      return 6
            //    } else {
                    return 7
             //   }
            } else if section == 1 {
                return 0
            //return 2
        } else if section == 3 {
            return 2
        }
        
        else {
            return 1
        }
    }
    
    func deleteNetwork(){
        self.db.collection("blueprints").document(self.blueprintUid).delete()
    }
    
    func forgetNetwork(){
        let docRef = self.db.collection("users").document(Auth.auth().currentUser?.uid ?? "")

        docRef.updateData([
            "historyNetworkIDs": FieldValue.arrayRemove(["\(self.blueprintUid)"])
        ])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let user = self.hostId
            let vc = UserProfileViewController.instantiate(with: user) //(user:user)
            let navVC = UINavigationController(rootViewController: vc)
           // var next = UserProfileViewController.instantiate(with: user)
             navVC.modalPresentationStyle = .fullScreen
          //  self.navigationController?.pushViewController(next, animated: true)
            present(navVC, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            let blueprint = self.blueprintUid ?? ""
            let vc = NetworkNameTableViewController.instantiate(with: blueprint) //(user:user)
            let navVC = UINavigationController(rootViewController: vc)
           // var next = UserProfileViewController.instantiate(with: user)
            //navVC.modalPresentationStyle = .fullScreen
          //  self.navigationController?.pushViewController(next, animated: true)
            present(navVC, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 6 {
            let blueprint = self.blueprintUid ?? ""
            let vc = NetworkPasswordTableViewController.instantiate(with: blueprint) //(user:user)
            let navVC = UINavigationController(rootViewController: vc)
           // var next = UserProfileViewController.instantiate(with: user)
          //   navVC.modalPresentationStyle = .fullScreen
          //  self.navigationController?.pushViewController(next, animated: true)
            present(navVC, animated: true)
        }
        if indexPath.section == 3 && indexPath.row == 0 {
            FirestoreManager.getBlueprint(blueprintUid) { network in
                if network?.creatorId == Auth.auth().currentUser?.uid {
                    let alertController = UIAlertController(title: "Delete This Network?", message: "Once you choose to delete a saved Network, it will be removed forever.", preferredStyle: .alert)
                    let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
                        //delete network
//                        db.collection("networks").document(networkID).delete { err in
//
//                            if let err = err {
//                                print("ERROR - deleteAccount \(currentUserUid): \(err.localizedDescription)")
//                                return completion(false)
//                            }
//
//                        }
                        self.deleteNetwork()
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                        //self.showAllUI()
                    })
                    alertController.addAction(deleteAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "Forget This Network?", message: "Once you choose to forget a saved Network, you will not automatically connect to this Network anymore.", preferredStyle: .alert)
                    let forgetAction = UIAlertAction(title: "Forget", style: .default, handler: { (_) in
                        //forget network
                        self.forgetNetwork()
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                        //self.showAllUI()
                    })
                    alertController.addAction(forgetAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    



//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            if indexPath.row == 0 {
//
//            }
//
//        }
//    }
}
