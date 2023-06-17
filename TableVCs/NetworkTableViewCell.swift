//
//  NetworkTableViewCell.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 9/19/22.
//

import UIKit

class NetworkTableViewCell: UITableViewCell {
    
    var user: User!
    var network: Blueprint!
    
    static let identifier = "NetworkTableViewCell"
    
    
    private let nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 56, y: 16, width: 230, height: 23))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let privateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "lock.fill")
        return imageView
    }()
    
    let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "info.circle")
        return imageView
    }()
    
    let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.image = UIImage(systemName: "checkmark")
        return imageView
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

        contentView.addSubview(nameLabel)
        contentView.addSubview(infoImageView)
        contentView.addSubview(checkmarkImageView)
        contentView.addSubview(privateImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        privateImageView.image = nil
        infoImageView.image = nil
        nameLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        privateImageView.frame = CGRect(x: (UIScreen.main.bounds.width - 78), y: 17.5, width: 20, height: 20)
        infoImageView.frame = CGRect(x: (UIScreen.main.bounds.width - 45), y: 15, width: 25, height: 25)
        checkmarkImageView.frame = CGRect(x: 14, y: 17, width: 25, height: 22)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with networkId: String) {
        FirestoreManager.getBlueprint(networkId) { network in
            self.nameLabel.text = network?.name
            self.infoImageView.image = UIImage(systemName: "info.circle")
            if (network?.visibility == "public") {
                self.privateImageView.isHidden = true
            } else {
                self.privateImageView.isHidden = false
            }
            //if connected - show checkmark
        }
    }

}
