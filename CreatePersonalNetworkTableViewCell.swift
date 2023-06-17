//
//  CreatePersonalNetworkTableViewCell.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 10/4/22.
//

import UIKit

class CreatePersonalNetworkTableViewCell: UITableViewCell {

    static let identifier = "CreatePersonalNetworkTableViewCell"
    
    
    private let label: UILabel = {
        let label = UILabel(frame: CGRect(x: 56, y: 16, width: 230, height: 23))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .label
        label.text = "Create Personal Blueprint"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
//        if UITraitCollection.current.userInterfaceStyle == .light {
//            backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 244/255, alpha: 1.0)
//            contentView.backgroundColor = UIColor(red: 241/255, green: 244/255, blue: 244/255, alpha: 1.0)
//        } else {
//            backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
//            contentView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1.0)
//        }
        accessoryType = .disclosureIndicator
        contentView.addSubview(label)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
      //  label.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
