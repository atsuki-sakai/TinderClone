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
import PKHUD

class ProfileViewController: UIViewController {

    //MARK: IBOutlet Vars
    @IBOutlet weak var iconView: CircleImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: Vars
    var userProfile:UserModel?
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userValidate()
        getProfile()
        
    }
    //MARK: IBActions
    fileprivate func userValidate(){
        
        if UserDefaults.standard.object(forKey: "userID") != nil {
            
            userID = UserDefaults.standard.object(forKey: "userID") as! String
            
        }
    }
    @IBAction func editProfileTaped(_ sender: Any) {
        
        let userData: UserModel = userProfile!
        
        performSegue(withIdentifier: "edit", sender: userData)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit" {
            
            let editVC = segue.destination as? EditViewController
            
            editVC?.userProfile = sender as? UserModel
        }
    }
    @IBAction func signOutButton(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            
            let startVC = self.storyboard?.instantiateViewController(withIdentifier: "start") as! StartViewController
            
            UserDefaults.standard.removeObject(forKey: "userID")
            
            self.present(startVC, animated: true, completion: nil)
            
            
        }catch{
            print("signOut error")
            let startVC = self.storyboard?.instantiateViewController(withIdentifier: "start") as! StartViewController
            
            self.present(startVC, animated: true, completion: nil)

        }
        
    }
    //MARK: Helpers
    
    private func profileFieldsSetUp(){
        
        iconView.sd_setImage(with: URL(string:userProfile!.userIcon), completed: nil)
        userNameLabel.text = userProfile!.userName
        genderLabel.text = userProfile!.userGender
        ageLabel.text = String(userProfile!.userAge)
        descriptionLabel.text = userProfile!.Description ?? "未入力"
        
    }
    private func getProfile(){
        
        HUD.dimsBackground = true
        HUD.show(.progress)
        let ref = Database.database().reference().child("UsersProfile")
        
        ref.child(userID).observe(.value) { (snapShot) in
            
            self.userProfile = UserModel(snapShot: snapShot)
            
            self.profileFieldsSetUp()
            
            HUD.hide()
        }
    }
    
}
