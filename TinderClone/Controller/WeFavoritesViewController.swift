//
//  WeFavoritesViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/12.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import FirebaseDatabase

class WeFavoritesViewController: UIViewController {

    //MARK: IBOutlets Vars
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Vars
    var weFavoritsList = [MusicModel]()
    var favoritesRef = Database.database().reference().child("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "tableViewCell", bundle: nil), forCellReuseIdentifier: "favoriteCell")
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = UITableView.automaticDimension
        getFavoritesLists()
        
        self.tableView.reloadData()

    }
    //MARK: Helpers
    fileprivate func getFavoritesLists(){
        
        favoritesRef.observe(.value) { (snapShot) in
            
            print("snapShot : \(snapShot)")
            for snap in snapShot.children {
                
                print("snap : \(snap)")
                let data = MusicModel(snapShot: snap as! DataSnapshot)
                
                print("data : \(data)")
                self.weFavoritsList.insert(data, at: 0)
            }
            self.tableView.reloadData()
            print("success weFavoritesLists")
        }
        
    }

}

extension WeFavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weFavoritsList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let favoriteCell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as? TableViewCell else {
            
            print("tableViewCell Error")
            return TableViewCell()
        }
        
        favoriteCell.accessoryView = UIImageView(image: UIImage(named: "arrowshape.turn.up.right"))
        
        let favoriteData = weFavoritsList[indexPath.row]
        
        favoriteCell.toFields(musicModel: favoriteData)
        
        return favoriteCell
    }
    
    
    
}
