//
//  MusicDataModel.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/10.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import PKHUD

class MusicModel {
    
    var userID: String?
    var userName: String?
    var userIcon: String?
    
    var likeArtist: String?
    var likeMusic: String?
    var likePreviewUrl: String?
    var likeArtistImage: String?
    var trackViewURL: String?
    
    var key: String! = ""
    
    var musicRef: DatabaseReference!
    
    
    init(userID: String, userName: String, userIcon: String, likeArtist: String, likeMusic: String, likePreviewUrl: String, likeArtistImage: String,trackViewURL: String) {
        
        self.userID = userID
        self.userName = userName
        self.userIcon = userIcon
        self.likeArtist = likeArtist
        self.likeMusic = likeMusic
        self.likePreviewUrl = likePreviewUrl
        self.likeArtistImage = likeArtistImage
        self.trackViewURL = trackViewURL
        
        self.musicRef = Database.database().reference().child("Users").child(userID).childByAutoId()
        
    }
    init(snapShot: DataSnapshot) {
        
        musicRef = snapShot.ref
        
        if let value = snapShot.value as? [String: Any] {
            
            likeArtist = value["likeArtist"] as? String
            likeMusic = value["likeMusic"] as? String
            likePreviewUrl = value["likePreviewUrl"] as? String
            likeArtistImage = value["likeArtistImage"] as? String
            userName = value["userName"] as? String
            userID = value["userID"] as? String
            userIcon = value["userIcon"] as? String
            trackViewURL = value["trackViewUrl"] as? String
            
        }
    }
    public func convertToDictionaly() -> NSDictionary{
        
        return["userID": userID,"userName": userName,"userIcon": userIcon,"likeArtist": likeArtist, "likeMusic": likeMusic, "likePreviewUrl": likePreviewUrl, "likeArtistImage": likeArtistImage, "trackViewUrl": trackViewURL]
        
    }
    public func saveMusicData(){
        
        musicRef.setValue(convertToDictionaly())
        
    }
    
}
