//
//  PointsViewController.swift
//  DecorateYourRoom
//
//  Created by Nijel Hunt on 9/4/22.
//  Copyright © 2022 Placenote. All rights reserved.
//

import UIKit
import FirebaseAuth

class PointsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var circleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var circleWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var circleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var circularProgressView: CircularView!
    @IBOutlet weak var userPointsLabel: UILabel!
    @IBOutlet weak var tierPointsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        reloadData()
        view.overrideUserInterfaceStyle = .light
        circularProgressView.trackClr = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1.0)// .lightGray
        circularProgressView.progressClr = UIColor(red: 236/255, green: 198/255, blue: 69/255, alpha: 1.0) //.systemYellow
       // view.addSubview(circularProgressView)
        // Do any additional setup after loading the view.
    }
    
    func reloadData(){
        FirestoreManager.getUser(Auth.auth().currentUser!.uid) { user in
          //  self.userPointsLabel.text = "\(user?.points ?? 0)"
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let points = user?.points ?? 0
            self.userPointsLabel.text = numberFormatter.string(from: points as NSNumber)

            if user?.points ?? 0 < 500 {
                self.tierPointsLabel.text = "of 500 pts"
                let fraction = (Double(points) / 500.0)
                self.circularProgressView.setProgressWithAnimation(duration: 1.25, value: Float(fraction))
            } else if user?.points ?? 0 > 500 && user?.points ?? 0 < 1500 {
                self.tierPointsLabel.text = "of 1,500 pts"
                let fraction = (Double(points) / 1500.0)
                self.circularProgressView.setProgressWithAnimation(duration: 1.25, value: Float(fraction))
            } else if user?.points ?? 0 > 1500 && user?.points ?? 0 < 5000 {
                self.tierPointsLabel.text = "of 5,000 pts"
                let fraction = (Double(points) / 5000.0)
                self.circularProgressView.setProgressWithAnimation(duration: 1.25, value: Float(fraction))
            } else if user?.points ?? 0 > 5000 && user?.points ?? 0 < 10000 {
                self.tierPointsLabel.text = "of 10,000 pts"
                let fraction = (Double(points) / 10000.0)
                self.circularProgressView.setProgressWithAnimation(duration: 1.25, value: Float(fraction))
            } else if user?.points ?? 0 > 10000 && user?.points ?? 0 < 25000 {
                self.tierPointsLabel.text = "of 25,000 pts"
                self.circleHeightConstraint.constant = 260
                self.circleWidthConstraint.constant = 260
                let fraction = (Double(points) / 25000.0)
                self.circularProgressView.setProgressWithAnimation(duration: 1.25, value: Float(fraction))
            } else if user?.points ?? 0 > 25000 && user?.points ?? 0 < 50000 {
                self.tierPointsLabel.text = "of 50,000 pts"
                self.circleHeightConstraint.constant = 260
                self.circleWidthConstraint.constant = 260
                let fraction = (Double(points) / 50000.0)
                print("\(fraction) is fraction")
                self.circularProgressView.setProgressWithAnimation(duration: 1, value: 0.5)
            } else  if user?.points ?? 0 > 50000 {
                self.tierPointsLabel.text = "of 100,000 pts"
                self.circleHeightConstraint.constant = 260
                self.circleWidthConstraint.constant = 260
                let fraction = (Double(points) / 100000.0)
                print("\(fraction) is fraction")
                self.circularProgressView.setProgressWithAnimation(duration: 1.25, value: Float(fraction))
                
            }
        }
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
    
}
