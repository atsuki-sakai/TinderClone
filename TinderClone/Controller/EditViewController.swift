//
//  EditViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/29.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase

class EditViewController: UIViewController {
    
    //MARK: IBOutlet Vars
    @IBOutlet weak var iconView: CircleImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegemented: UISegmentedControl!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var descriptionView: UITextView!
    
    //MARK: Vars
    var profileRef:DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileRef = Database.database().reference().child("UserProfile")
        

    }
    //MARK: IBActions
    @IBAction func ChangeProfileButtonTaped(_ sender: Any) {
        
        present(cautionAlert(title: "確認", Message: "Profileを変更します。"), animated: true,completion: nil)
        
        //iconの変更方法を考える
    //storageから削除した上で新たにStorageとdatabaseに保存する。
        
        dismiss(animated: true, completion: nil)
        
        
    }
    //MARK: Helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}
extension EditViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
}
