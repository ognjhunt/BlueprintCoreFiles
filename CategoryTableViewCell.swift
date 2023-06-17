//
//  CategoryTableViewCell.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 5/31/23.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    static let identifier = "CategoryTableViewCell"
    
    
    let categoryImageView1: UIImageView = {
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
    
    
    let categoryImageView2: UIImageView = {
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
    
    let categoryImageView3: UIImageView = {
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

        contentView.addSubview(categoryImageView1)
        contentView.addSubview(nameLabel1)
        contentView.addSubview(categoryImageView2)
        contentView.addSubview(nameLabel2)
        contentView.addSubview(categoryImageView3)
        contentView.addSubview(nameLabel3)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImageView1.image = nil
        nameLabel1.text = nil
        
        categoryImageView2.image = nil
        nameLabel2.text = nil
        
        categoryImageView3.image = nil
        nameLabel3.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        categoryImageView1.frame = CGRect(x: 8, y: 8, width: (UIScreen.main.bounds.width / 3) - 13, height: 90)
       
        nameLabel1.frame = CGRect(x: categoryImageView1.frame.minX, y: 104, width: 120, height: 17)
        nameLabel1.textAlignment = .center
        
        categoryImageView2.frame = CGRect(x: categoryImageView1.frame.maxX + 11.5, y: 8, width: (UIScreen.main.bounds.width / 3) - 13, height: 90)
        nameLabel2.frame = CGRect(x: categoryImageView2.frame.minX, y: 104, width: 115, height: 17)
        
        nameLabel2.textAlignment = .center

        categoryImageView3.frame = CGRect(x: categoryImageView2.frame.maxX + 11.5, y: 8, width: (UIScreen.main.bounds.width / 3) - 13, height: 90)

        nameLabel3.frame = CGRect(x: categoryImageView3.frame.minX, y: 104, width: 115, height: 17)
        nameLabel3.textAlignment = .center

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configure() {
            //let id = model?.id
            self.nameLabel1.text = "Colors"
             self.categoryImageView1.image = UIImage(named: "lbluegradient")
            
    }
    
    public func configure2() {
        self.nameLabel2.text = "Materials"
         self.categoryImageView2.image = UIImage(named: "wood")
    }
    
    public func configure3() {
        self.nameLabel3.text = "Designs"
         self.categoryImageView3.image = UIImage(named: "sistineimg")
    }

}
