//
//  EditViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/14.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import PKHUD

class EditViewController: UIViewController {
    
    
    @IBOutlet weak var userIconView: CircleImageView!
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var DescriptionTextView: UITextView!
    
    
    var userProfile: UserModel?
    var databaseRef = Database.database().reference(fromURL: "https://tinderclone-ca88c.firebaseio.com/")
    var storageRef = Storage.storage().reference(forURL: "gs://tinderclone-ca88c.appspot.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userIconView.sd_setImage(with: URL(string: userProfile!.userIcon), completed: nil)
        userNameLabel.text = userProfile!.userName
        ageLabel.text = String(userProfile!.userAge)
        genderSegmented.selectedSegmentIndex = genderConvertInt(Gender: userProfile!.userGender)
        DescriptionTextView.text = userProfile?.Description
        
    }
    @IBAction func userIConViewTaped(_ sender: Any) {
        
        showAlert()
        
    }
    @IBAction func changeButtonTaped(_ sender: Any) {
        
        HUD.dimsBackground = true
        HUD.show(.progress)
        let key = databaseRef.child(userProfile!.userId).key
        
        let imageRef = storageRef.child("UsersProfile").child("\(key!).jpeg")
        imageRef.delete { (error) in
            
            print("imageRef Delete Error")
        }
        
        let newImage: Data = (userIconView.image?.jpegData(compressionQuality: 0.01))!
        
        let uploadTask = imageRef.putData(newImage, metadata: nil) { (metadata, error) in
           
            imageRef.downloadURL { (url, error) in
                
                let newIcon: String = url!.absoluteString
                let newName: String = self.userNameLabel.text!
                
                guard let userAge = Int(self.ageLabel.text!) else{
                    
                    self.present(cautionAlert(title: "AgeField Error", Message: "年齢は数値で入力してください。"), animated: true, completion: nil)
                    return
                }
                let newAge: Int = userAge
                let newGender = self.convertGender()
                let newDescription = self.DescriptionTextView.text
                
                let newProfile = UserModel(uuid: self.userProfile!.userId, userName: self.userProfile!.userName, userIcon: newIcon, userAge: newAge, userGender: newGender, Description: newDescription ?? "No Description")
                
                newProfile.saveUserToFirebase()
                HUD.hide()

            }
        }
        uploadTask.resume()
        //画面を戻る
        dismiss(animated: true, completion: nil)
        
    }
    fileprivate func convertGender() -> String {
        
        switch genderSegmented.selectedSegmentIndex {
            
            case 0:
                return "Men"
            case 1:
                return "Women"
            case 2:
                return "TransGender"
            default:
                return "Men"
        }
    }
    fileprivate func showAlert(){
        
        let alertVC = UIAlertController(title: "Iconを変更します。", message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (alertResults) in
            
            self.openCamera()
            
        }
        let albumAction = UIAlertAction(title: "Album", style: .default) { (alertResults) in
            
            self.openAlbum()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(albumAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
        
    }
    fileprivate func genderConvertInt(Gender: String) -> Int {
        
        switch Gender{
            
        case "Men":
            return 0
        case "Women":
            return 1
        case "TransGender":
            return 2
        default:
            return 1
        }
    }

}
extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera(){
        
        let sourceType: UIImagePickerController.SourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let cameraPicker = UIImagePickerController()
            
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            
            present(cameraPicker, animated: true, completion: nil)
            
        }
        
    }
    func openAlbum(){
        
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let albumPicker = UIImagePickerController()
            
            albumPicker.allowsEditing = true
            albumPicker.sourceType = sourceType
            albumPicker.delegate = self
            
            present(albumPicker, animated: true, completion: nil)
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {
            
            print("Picker DidFinish Error")
            return
        }
        userIconView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}
