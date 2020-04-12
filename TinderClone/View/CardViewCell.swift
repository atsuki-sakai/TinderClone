//
//  CardViewCell.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/10.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import VerticalCardSwiper

class CardViewCell: CardCell {
    
    @IBOutlet weak var artWorkImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var musicTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        artWorkImageView.layer.borderColor = UIColor.black.cgColor
        artWorkImageView.layer.borderWidth = 5
        
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    public func setBackGroundColor() {
        
        //arc4random()でランダムに数字を生成
        let randomRed: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        
        self.backgroundColor = UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    //CardCellのlayerを変更する。
    override func layoutSubviews() {
        
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
        super.layoutSubviews()
        
    }
    

    
}
