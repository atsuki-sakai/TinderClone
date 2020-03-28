//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/29.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {

    //MARK: IBOutlet Vars
    @IBOutlet weak var iconView: CircleImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: Vars
    var Icon:String!
    var Name:String!
    var Gender:String!
    var Age:String!
    var Description:String?
    var userProfile:UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uservalidate()
        getProfile()
        
    }
    //MARK: IBActions
    @IBAction func signOutButtonTaped(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
        }
        catch{
            performSegue(withIdentifier: "login", sender: nil)
            return
        }
    }
    @IBAction func profileEditbuttonTaped(_ sender: Any) {
        
        //profileEditing
        
    }
    //MARK: Helpers
    private func uservalidate(){
        
        if Auth.auth().currentUser == nil {
            
            performSegue(withIdentifier: "login", sender: nil)
            return
        }
        return
    }
    private func profileFieldsSetUp(){
        
        iconView.sd_setImage(with: URL(string:userProfile!.userIcon), completed: nil)
        userNameLabel.text = userProfile!.userName
        genderLabel.text = userProfile!.userGender
        ageLabel.text = String(userProfile!.userAge)
        descriptionLabel.text = userProfile!.Description ?? "未入力"
        
    }
    private func getProfile(){
        
        let ref = Database.database().reference().child("UsersProfile")
        
        ref.child(Auth.auth().currentUser!.uid).observe(.value) { (snapShot) in
            
            self.userProfile = UserModel(snapShot: snapShot)
            
            print("userName",self.userProfile?.userName)
            
            self.profileFieldsSetUp()
        }
    }
    
}
