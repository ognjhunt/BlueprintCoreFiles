//
//  PromoViewController.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 9/7/22.
//  Copyright © 2022 Placenote. All rights reserved.
//

import UIKit

class PromoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var promoImageView: UIImageView!
    @IBOutlet weak var inviteLabel: UILabel!
    @IBOutlet weak var earnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.overrideUserInterfaceStyle = .light
        // Do any additional setup after loading the view.
    }
    

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "howToEarnCell", for: indexPath)

            tableView.rowHeight = 180
              return cell
          }
          if indexPath.row == 1 {
              let cell = tableView.dequeueReusableCell(withIdentifier: "howToUseCell", for: indexPath)
              tableView.rowHeight = 180
            //  print("most popular cell returned")
              return cell
          }
           if indexPath.row == 2 {
               let cell = tableView.dequeueReusableCell(withIdentifier: "otherBenefitsCell", for: indexPath)
               tableView.rowHeight = 180
               return cell
           }

         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    @IBAction func shareAction(_ sender: Any) {
        if let name = URL(string: "https://apps.apple.com/us/app/tiktok/id835599320"), !name.absoluteString.isEmpty {
          let objectsToShare = [name]
          let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
          self.present(activityVC, animated: true, completion: nil)
        } else {
          // show alert for not available
            print("impossible")
        }
    }
    
    @IBAction func inviteAction(_ sender: Any) {
        
    }
    
}
