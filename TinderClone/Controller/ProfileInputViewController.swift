//
//  ProfileInputViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/23.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import Photos
import PKHUD

class ProfileInputViewController: UIViewController {
    
    //MARK: IBOutlet Vars
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var CreateButton: CustomButton!
    
    //MARK: Vars
    var UserIcon:UIImage? = UIImage()
    var userIconString:String = ""
    var UserName:String = ""
    var UserAge:Int = Int()
    var UserGender:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpIconViewI()
        getPermissionToAlbum()
        
        guard Auth.auth().currentUser != nil else{
            
            dismiss(animated: true, completion: nil)
            return
        }
        
    }
    @IBAction func userIconViewTaped(_ sender: Any) {
        
        DeviceVive(Type: "error")
        AlbumOpen()
        
    }
    @IBAction func CreateButtonTaped(_ sender: Any) {
        
        DeviceVive(Type: "success")
        if completedProfileField(){
            
            guard let userAge = Int(ageTextField.text!) else{
                
                DeviceVive(Type: "error")
                present(cautionAlert(title: "AgeField Error", Message: "年齢は数値で入力してください。"), animated: true, completion: nil)
                return
            }
            
            let ref = Database.database().reference(fromURL: "https://tinderclone-ca88c.firebaseio.com/")
            let storage = Storage.storage().reference(forURL: "gs://tinderclone-ca88c.appspot.com")
            
            let key = ref.childByAutoId().key
            let imageRef = storage.child("UserProfiles").child("\(key!).jpeg")
            
            let imageData:Data = (userIconView.image?.jpegData(compressionQuality: 0.01))!
            
            HUD.dimsBackground = true
            HUD.show(.progress)
            
            
            let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                
                imageRef.downloadURL { (url, error) in
                    
                    self.userIconString = url!.absoluteString
                    self.UserName = self.userNameTextField.text!
                    self.UserAge = Int(self.ageTextField.text!)!
                    self.UserGender = self.judgeGender()
                    
                    let userModel = UserModel(uuid: Auth.auth().currentUser!.uid, userName: self.UserName, userIcon: self.userIconString, userAge: self.UserAge, userGender: self.UserGender)
                   
                    userModel.saveUserToFirebase()
                    
                    HUD.hide()
                }
            }
            uploadTask.resume()
            
        }else{
            DeviceVive(Type: "error")
            present(cautionAlert(title: "error", Message: "入力してください。"), animated: true, completion: nil)
            return
        }
       
    }
    //MARK: Helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    private func getPermissionToAlbum(){
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch (status){
                
            case .notDetermined:
                return
            case .restricted:
                return
            case .denied:
                return
            case .authorized:
                print("許可を得ました。")
            @unknown default:
                return
            }
        }
    }
    private func completedProfileField() -> Bool{
        
        return (userNameTextField.text != "" && ageTextField.text != "")
        
    }
    private func judgeGender() -> String{
        
        var gender = ""
        
        switch (genderSegmented.selectedSegmentIndex){
            
        case 0:
            gender = "Men"
        case 1:
            gender = "Women"
        case 2:
            gender = "TransGender"
        default:
            gender = "Men"
        }
        
        return gender
    }
    private func DeviceVive(Type:String){
        
        let generator = UINotificationFeedbackGenerator()
        
        if Type == "error"{
            generator.notificationOccurred(.error)
        }else if Type == "success"{
            generator.notificationOccurred(.success)
        }else{
            generator.notificationOccurred(.success)
        }
    }
    private func setUpIconViewI(){
        
        userIconView.layer.masksToBounds = false
        userIconView.layer.cornerRadius = userIconView.frame.height/2
        userIconView.layer.borderColor = UIColor.systemGray.cgColor
        userIconView.layer.borderWidth = 2
        userIconView.clipsToBounds = true
    }
}
//textFieldDelegate
extension ProfileInputViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
}
extension ProfileInputViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func AlbumOpen(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            
            let albumPicker = UIImagePickerController()
            
            albumPicker.delegate = self
            albumPicker.allowsEditing = true
            albumPicker.sourceType = sourceType
            
            present(albumPicker, animated: true, completion: nil)
            
        }else{
            present(cautionAlert(title: "Error", Message: "アルバムを開けません。"), animated: true, completion: nil)
            return
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectImage = info[.editedImage] as? UIImage{
        
            userIconView.image = selectImage
            
            picker.dismiss(animated: true, completion: nil)
            return
            
        }
    }
    
}
