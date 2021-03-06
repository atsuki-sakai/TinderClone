//
//  OtherCollectionViewCell.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/13.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import SDWebImage

class OtherCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var otherView: UIImageView!
    @IBOutlet weak var otherNameLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.cornerRadius = 12
       
        
    }
    func toFields(user: UserModel){
        
        self.otherView.sd_setImage(with: URL(string: user.userIcon), completed: nil)
        self.otherNameLabel.text = user.userName
        self.otherNameLabel.adjustsFontSizeToFitWidth = true
        
        self.otherNameLabel.textColor = UIColor.white
        
    }

}
