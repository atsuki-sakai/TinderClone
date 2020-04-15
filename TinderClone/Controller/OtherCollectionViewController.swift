//
//  OtherCollectionViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/13.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase

class OtherCollectionViewController: UICollectionViewController {
    
    
    var userID: String?
    var userDatas = [UserModel]()
    var userRef = Database.database().reference().child("UsersProfile")
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let numberOfCell: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "OtherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "otherCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        print("OtherCOllectionVC")
        getUserID()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserData()
    }
    fileprivate func getUserID(){
        
        if userID == nil {
            
            if UserDefaults.standard.object(forKey: "userID") != nil {
                
                self.userID = UserDefaults.standard.object(forKey: "userID") as? String
                
            }else{
                
                print("userDefaults Error")
            }
        }
        
    }
    fileprivate func getUserData(){
       
        userDatas.removeAll()
        print("userDatasCount :\(self.userDatas.count)")
        userRef.observe(.value) { (snapShot) in
            
            for snap in snapShot.children {
                
                let userData = UserModel(snapShot: snap as! DataSnapshot)
                
                self.userDatas.insert(userData, at: 0)
                print("userdatasCount",self.userDatas.count)
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return userDatas.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let otherCell = collectionView.dequeueReusableCell(withReuseIdentifier: "otherCell", for: indexPath) as! OtherCollectionViewCell
    
        let user = userDatas[indexPath.row]
        
        
        
        otherCell.toFields(user: user)
    
        return otherCell
    }

}

extension OtherCollectionViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let paddingSpance = sectionInsets.left * (numberOfCell + 1)
        let availableWidth = view.frame.width - paddingSpance
        let widthPerCell = availableWidth / numberOfCell
        
        return CGSize(width: widthPerCell, height: widthPerCell)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
        
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let userID = userDatas[indexPath.row].userId
        let userName = userDatas[indexPath.row].userName
        let userdata: [String] = [userID,userName]
        
        performSegue(withIdentifier: "otherList", sender: userdata)
        
        print("tap cell")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "otherList" {
            
            let otherListVC = segue.destination as! OtherListViewController
            
            otherListVC.userdata = sender as? [String]
            
        }else{
            print("segue Error")
        }
        
    }
}
