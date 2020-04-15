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

class EditViewController: UIViewController{
    
    @IBOutlet weak var userIconView: CircleImageView!
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var DescriptionTextView: UITextView! {
        
        didSet{
            
            DescriptionTextView.layer.masksToBounds = false
            DescriptionTextView.clipsToBounds = true
            DescriptionTextView.layer.cornerRadius = 12
            DescriptionTextView.layer.borderWidth = 4
            DescriptionTextView.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var baseView: UIView!
    
    var userProfile: UserModel?
    var databaseRef = Database.database().reference(fromURL: "https://tinderclone-ca88c.firebaseio.com/")
    var storageRef = Storage.storage().reference(forURL: "gs://tinderclone-ca88c.appspot.com")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DescriptionTextView.delegate = self
        userNameLabel.delegate = self
        
        userIconView.sd_setImage(with: URL(string: userProfile!.userIcon), completed: nil)
        userNameLabel.text = userProfile!.userName
        DescriptionTextView.text = userProfile?.Description
        
        configureObserver()
            
    }
    fileprivate func configureObserver(){
    
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
     
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        print("remove NotificationCenter")
        
    }
    @objc func keyboardWillShow(_ notification: NSNotification){
        
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        baseView.frame.origin.y = self.view.frame.height - keyboardFrame.height - baseView.frame.height
        
      
    }
    @objc func keyboardWillHide(_ notification: NSNotification){
        
        //193px
        
        let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        baseView.frame.origin.y = self.view.frame.height - 193 - baseView.frame.height
        
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            
                return
                
        }
        
        UIView.animate(withDuration: duration) {
            
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
            
        }
        
  
    }
    @IBAction func backButtonTaped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
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
            
            print("imageRef Delete")
        }
        
        let newImage: Data = (userIconView.image?.jpegData(compressionQuality: 0.01))!
        
        let uploadTask = imageRef.putData(newImage, metadata: nil) { (metadata, error) in
           
            imageRef.downloadURL { (url, error) in
                
                let newIcon: String = url!.absoluteString
                let newName: String = self.userNameLabel.text!
                let newDescription = self.DescriptionTextView.text
                
                let newProfile = UserModel(uuid: self.userProfile!.userId, userName: newName, userIcon: newIcon, userAge: self.userProfile!.userAge, userGender: self.userProfile!.userGender, Description: newDescription ?? "No Description")
                
                newProfile.saveUserToFirebase()
                HUD.hide()

            }
        }
        uploadTask.resume()
        //画面を戻る
        dismiss(animated: true, completion: nil)
        
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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(self.DescriptionTextView.isFirstResponder) {
            
            self.DescriptionTextView.resignFirstResponder()
            
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
extension EditViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
}
