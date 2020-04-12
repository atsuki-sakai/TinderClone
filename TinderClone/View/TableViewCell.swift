//
//  TableViewCell.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/12.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import SDWebImage

class TableViewCell: UITableViewCell {

    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    public func toFields(musicModel: MusicModel){
        
        self.userIconView.sd_setImage(with: URL(string: musicModel.userIcon!), placeholderImage: UIImage(named: "noimage"), options: .continueInBackground, context: nil)
        self.userNameLabel.text = musicModel.userName!
        
    }
    
}
