//
//  StartViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/03/29.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    //MARK: IBOutlet Vars
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.removeObject(forKey: "userID")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK: IBActions
    @IBAction func loginButtonTaped(_ sender: Any) {
        
        performSegue(withIdentifier: "login", sender: nil)
        
    }
    @IBAction func signUpButtonTaped(_ sender: Any) {
        
        performSegue(withIdentifier: "signup", sender: nil)
        
    }
    
}
