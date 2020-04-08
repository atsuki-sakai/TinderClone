//
//  MusicSearchViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/29.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PKHUD
import DTGradientButton
import Firebase

class MusicSearchViewController: UIViewController {

    //MARK: IBOutle Vars
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchActionButton: UIButton!
    
    //MARK: Vars
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchTextField.delegate = self
        CustomButton()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userValidate()
        
    }
    @IBAction func searchButtontaped(_ sender: Any) {
        
       
        
    }
    //MARK: Helpers
    fileprivate func userValidate(){
        
        if UserDefaults.standard.object(forKey: "userID") != nil {
            
            print(UserDefaults.standard.object(forKey: "userID") as! String)
    
        }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let startVC = storyboard.instantiateViewController(withIdentifier: "start") as! StartViewController
            
            startVC.modalPresentationStyle = .fullScreen
            self.present(startVC, animated: true, completion: nil)
        }
    }
    private func CustomButton(){
        
        searchActionButton.layer.masksToBounds = false
        searchActionButton.clipsToBounds = true
        searchActionButton.layer.cornerRadius = searchActionButton.frame.height/4
        searchActionButton.layer.borderColor = UIColor.darkGray.cgColor
        searchActionButton.layer.borderWidth = 2
        searchActionButton.setGradientBackgroundColors([UIColor(hex: "#FAFFAD"),UIColor(hex: "#C1FFC1")], direction: .toTopRight, for: .normal)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
}
//MARK: TextField Delegate
extension MusicSearchViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
}
