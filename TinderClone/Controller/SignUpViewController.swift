//
//  ViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/23.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class SignUpViewController: UIViewController {
    
    //MARK: IBOutlet Vars
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passWordTextField: UITextField!
    @IBOutlet weak var brarView: UIView!
    
    //MARK: Vars
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passWordTextField.delegate = self
        
    }
    //MARK: IBActions
    @IBAction func signUpButtonTaped(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if emailTextField.text != "" && passWordTextField.text != ""{
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passWordTextField.text!) { (authResult, error) in
                
                if let error = error {
                    
                    self.present(cautionAlert(title: "Error", Message: error.localizedDescription), animated: true, completion: nil)
                    self.emailTextField.text = ""
                    self.passWordTextField.text = ""
                    return
                }
                //User情報を保持する
                UserDefaults.standard.set(authResult!.user.uid, forKey: "userID")
                //animationを入れる
                self.setUpAniamtion()
                self.animationView.play { (finished) in
                    if finished == true{
                        self.performSegue(withIdentifier: "profileVC", sender: nil)
                    }
                }
            }
            
        }else{
            
            self.present(cautionAlert(title: "Error", Message: "入力してください。"), animated: true, completion: nil)
            
            self.emailTextField.text = ""
            self.passWordTextField.text = ""
            
        }
        
    }
    //MARK: Helpers
    
    private func setUpAniamtion(){
        
        let animation = Animation.named("success")
        animationView.animation = animation
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.height, height:     self.view.frame.width)
        animationView.loopMode = .playOnce
        animationView.contentMode = .scaleAspectFit
        self.view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        animationView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
}
//MARK: TextField Delegate
extension SignUpViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
}

