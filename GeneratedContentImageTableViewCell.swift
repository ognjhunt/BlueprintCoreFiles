//
//  GeneratedContentImageTableViewCell.swift
//  Indoor Blueprint
//
//  Created by Nijel Hunt on 12/14/22.
//

import UIKit

class GeneratedContentImageTableViewCell: UITableViewCell {

    static let identifier = "contentImageCell"
    
    var image1 : UIImage?
    
    let vc = ComposeArtworkViewController()
    
    let contentImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 20, y: 16, width: 128, height: 128))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
       
        contentView.addSubview(contentImageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    

    func loadImage() {
         guard let data = UserDefaults.standard.data(forKey: "image") else { return }
         let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
         image1 = UIImage(data: decoded)
         self.contentImageView.image = image1
    }

    public func configureImage() {
        loadImage()
       // image1 = vc.generatedImage
//        self.contentImageView.image = image1
    }
}
