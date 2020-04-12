//
//  CustomButton.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/23.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    //@IBInspectable でStoryBoard上からも変更が可能
    @IBInspectable var borderWidth:CGFloat = 2
    @IBInspectable var backGroundColor:UIColor = UIColor.black
    @IBInspectable var borderColor:UIColor = UIColor.white
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        layerInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layerInit()
    }
    
    internal func layerInit(){
        
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
        self.layer.borderWidth = borderWidth
        self.clipsToBounds = true
        self.backgroundColor = backgroundColor
        self.layer.borderColor = borderColor.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.7
    }
    
}

class PlayMusicButton: UIButton {
    
    var params: Dictionary<String, Any>
    
    override init(frame: CGRect) {
        
        self.params = [:]
        super.init(frame: frame)
        //superで継承する前に呼ぶ
        setUpLayer()
    }
    required init?(coder aDecoder: NSCoder) {
        
        self.params = [:]
        super.init(coder: aDecoder)
        
        self.setUpLayer()
    }
    
    internal func setUpLayer(){
        
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
        self.titleLabel?.textColor = UIColor.darkGray
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.setTitle("Play", for: .normal)
        
    }
}

