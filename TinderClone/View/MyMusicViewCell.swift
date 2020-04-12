//
//  MyMusicViewCell.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/11.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import SDWebImage

class MyMusicViewCell: UICollectionViewCell {

    //MARK: IBOutlets Vars
    @IBOutlet weak var MusicImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var musicTitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 10
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        self.clipsToBounds = true
        
        super.layoutSubviews()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    public func toLabel(musicModel: MusicModel){
        
        MusicImageView.sd_setImage(with: URL(string: musicModel.likeArtistImage!), placeholderImage: UIImage(named: "noimage"), options: .continueInBackground, context: nil)
        artistNameLabel.text = musicModel.likeArtist!
        artistNameLabel.adjustsFontSizeToFitWidth = true
        musicTitleLabel.text = musicModel.likeMusic!
        
    }

}
