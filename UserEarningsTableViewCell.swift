//
//  UserEarningsTableViewCell.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 12/6/22.
//

import UIKit

class UserEarningsTableViewCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var lastMonthEarningsLabel: UILabel!
    @IBOutlet weak var earningsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headingLabel.text = "Total earnings"
        earningsLabel.text = "2,456"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
