//
//  MyListTableViewCell.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/13.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import SDWebImage

class MyListTableViewCell: UITableViewCell {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var musicTitleLabel: UILabel!
    @IBOutlet weak var View: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.artistNameLabel.textColor = UIColor.white
        self.musicTitleLabel.textColor = UIColor.white
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        self.View.layer.cornerRadius = 12
        self.View.backgroundColor = UIColor.systemTeal
        
    }
    internal func toFields(musicModel: MusicModel) {
        
        self.artistImageView.sd_setImage(with: URL(string: musicModel.likeArtistImage!), placeholderImage: UIImage(named: "noimage"), options: .continueInBackground, context: nil)
        
        self.artistNameLabel.text = musicModel.likeArtist!
        self.musicTitleLabel.text = musicModel.likeMusic!
        
    }
    
}
