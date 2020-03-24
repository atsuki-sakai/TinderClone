//
//  UserModel.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/24.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import Foundation
import Firebase

class UserModel{
    
    var userName:String = ""
    var userIcon:String = ""
    var userAge:Int = Int()
    var userGender:String = ""
    var userId:String = ""
    var ref:DatabaseReference!
    
    //保存用
    init(uuid:String,userName:String,userIcon:String!,userAge:Int,userGender:String) {
        
        self.userName = userName
        self.userIcon = userIcon
        self.userAge = userAge
        self.userGender = userGender
        self.userId = uuid
        self.ref = Database.database().reference().child("UserProfile").child(uuid)
        
    }
    //取得用
    init(snapShot:DataSnapshot) {
        
        ref = snapShot.ref
        
        if let value = snapShot.value as? [String:Any]{
            
            userName = value["userName"] as! String
            userIcon = value["userIcon"] as! String
            userAge = value["userAge"] as! Int
            userGender = value["userGender"] as! String
            userId = value["userId"] as! String
 
        }
    }
    public func toContents() -> [String:Any] {
        
        return ["userName":userName,"userIcon":userIcon,"userAge":userAge,"userGender":userGender,"userId":userId]
        
    }
    public func saveUserToFirebase(){
        
        ref.setValue(toContents())
        
    }
    
}


