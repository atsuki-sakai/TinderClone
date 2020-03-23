//
//  Alert.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/23.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import Foundation
import UIKit


public func cautionAlert(title:String,Message:String) -> UIAlertController{
    
    let alertVC = UIAlertController(title: title, message: Message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    
    alertVC.addAction(okAction)
    
    return alertVC

}
