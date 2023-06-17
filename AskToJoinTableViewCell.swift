//
//  AskToJoinTableViewCell.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 10/4/22.
//

import UIKit

class AskToJoinTableViewCell: UITableViewCell {

    static let identifier = "AskToJoinTableViewCell"
    
    
    private let askLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 16, y: 15, width: 157, height: 20))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .label
        label.text = "Ask to Join Networks"
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: UIScreen.main.bounds.width - 99.5, y: 14.5, width: 46, height: 21))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .darkGray
        label.text = "Notify"
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
        contentView.addSubview(askLabel)
        contentView.addSubview(statusLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //askLabel.text = nil
   //     statusLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
