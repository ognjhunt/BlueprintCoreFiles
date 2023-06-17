//
//  StyleTableViewCell.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 5/29/23.
//

import UIKit
import FirebaseAuth

class StyleTableViewCell: UITableViewCell {

    var user: User!
    var style: Style!
    
    static let identifier = "StyleTableViewCell"
    
    
    let styleImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let nameLabel1: UILabel = {
        let label = UILabel(frame: CGRect(x: 13, y: 104, width: 115, height: 17))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    
    let styleImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    private let nameLabel2: UILabel = {
        let label = UILabel(frame: CGRect(x: 157, y: 104, width: 115, height: 17))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    let styleImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 7
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    private let nameLabel3: UILabel = {
        let label = UILabel(frame: CGRect(x: 296.5, y: 104, width: 115, height: 17))
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    let lockImageView1: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
      //  imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.backgroundColor = .clear
    //    imageView.tintColor = .clear

        imageView.tintColor = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 0.9)
        return imageView
    }()
    
    let lockImageView2: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
      //  imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.backgroundColor = .clear
       // imageView.tintColor = .clear

        imageView.tintColor = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 0.9)
        return imageView
    }()
    
    let lockImageView3: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.backgroundColor = .clear
  //      imageView.tintColor = .clear

        imageView.tintColor = UIColor(red: 53/255, green: 53/255, blue: 53/255, alpha: 0.9)
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
        
        selectionStyle = .none

        contentView.addSubview(styleImageView1)
        contentView.addSubview(nameLabel1)
        contentView.addSubview(styleImageView2)
        contentView.addSubview(nameLabel2)
        contentView.addSubview(styleImageView3)
        contentView.addSubview(nameLabel3)
        contentView.addSubview(lockImageView1)
        contentView.addSubview(lockImageView2)
        contentView.addSubview(lockImageView3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        styleImageView1.frame = CGRect(x: 8, y: 8, width: (UIScreen.main.bounds.width / 3) - 13, height: 90)
        lockImageView1.frame = CGRect(x: styleImageView1.frame.midX - 25, y: styleImageView1.frame.minY + 20, width: 50, height: 50)

        nameLabel1.frame = CGRect(x: styleImageView1.frame.minX, y: 104, width: 120, height: 17)
        nameLabel1.textAlignment = .center
        
        styleImageView2.frame = CGRect(x: styleImageView1.frame.maxX + 11.5, y: 8, width: (UIScreen.main.bounds.width / 3) - 13, height: 90)
        lockImageView2.frame = CGRect(x: styleImageView2.frame.midX - 25, y: styleImageView2.frame.minY + 20, width: 50, height: 50)

        nameLabel2.frame = CGRect(x: styleImageView2.frame.minX, y: 104, width: 115, height: 17)
        
        nameLabel2.textAlignment = .center

        styleImageView3.frame = CGRect(x: styleImageView2.frame.maxX + 11.5, y: 8, width: (UIScreen.main.bounds.width / 3) - 13, height: 90)
        lockImageView3.frame = CGRect(x: styleImageView3.frame.midX - 25, y: styleImageView3.frame.minY + 20, width: 50, height: 50)

        nameLabel3.frame = CGRect(x: styleImageView3.frame.minX, y: 104, width: 115, height: 17)
        nameLabel3.textAlignment = .center

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure(with name: String, isFirstFiveUnlocked: Bool) {
        FirestoreManager.getStyle(name) { style in
            self.nameLabel1.text = style?.name
            
            let thumbnailName = style?.thumbnail
            StorageManager.getModelThumbnail(thumbnailName ?? "") { image in
                self.styleImageView1.image = image
            }
            
            if isFirstFiveUnlocked || Auth.auth().currentUser != nil {
                self.lockImageView1.isHidden = true
            } else {
                self.lockImageView1.isHidden = false
            }
        }
    }

    public func configure2(with name: String, isFirstFiveUnlocked: Bool) {
        FirestoreManager.getStyle(name) { style in
            self.nameLabel2.text = style?.name
            
            let thumbnailName = style?.thumbnail
            StorageManager.getModelThumbnail(thumbnailName ?? "") { image in
                self.styleImageView2.image = image
            }
            
            if isFirstFiveUnlocked || Auth.auth().currentUser != nil {
                self.lockImageView2.isHidden = true
            } else {
                self.lockImageView2.isHidden = false
            }
        }
    }

    public func configure3(with name: String, isFirstFiveUnlocked: Bool) {
        FirestoreManager.getStyle(name) { style in
            self.nameLabel3.text = style?.name
            
            let thumbnailName = style?.thumbnail
            StorageManager.getModelThumbnail(thumbnailName ?? "") { image in
                self.styleImageView3.image = image
            }
            
            if isFirstFiveUnlocked || Auth.auth().currentUser != nil {
                self.lockImageView3.isHidden = true
            } else {
                self.lockImageView3.isHidden = false
            }
        }
    }


}
