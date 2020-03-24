//
//  ProfileInputViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/23.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase

class ProfileInputViewController: UIViewController {
    
    //MARK: IBOutlet Vars
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var birthDayPicker: UIDatePicker!
    @IBOutlet weak var birthDayTextField: UITextField!
    @IBOutlet weak var genderSegmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    
    //MARK: Helpers
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
}

extension ProfileInputViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
}
