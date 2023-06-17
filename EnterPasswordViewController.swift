//
//  EnterPasswordViewController.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 10/4/22.
//

import UIKit

class EnterPasswordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    

    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var networkPasswordLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinAction(_ sender: Any) {
    }
    
    @IBAction func cancelAction(_ sender: Any) {
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EnterPasswordCell", for: indexPath)
            
                tableView.rowHeight = 60
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
