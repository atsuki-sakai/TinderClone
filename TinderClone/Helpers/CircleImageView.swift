//
//  CircleImageView.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/24.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import Foundation
import UIKit

class CircleImageView:UIImageView{
    
    @IBInspectable var borderColor:UIColor = UIColor.systemGray
    @IBInspectable var borderWidth:CGFloat = 2
    
    
    override var image: UIImage?{
        
        willSet{
            
            layer.masksToBounds = false
            clipsToBounds = true
            layer.cornerRadius = frame.height/2
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
            layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
            layer.shadowColor = UIColor.lightGray.cgColor
            layer.shadowRadius = 2
            layer.shadowOpacity = 1
            contentMode = .scaleToFill
            
        }
    }
    
}
