//
//  MyListViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/11.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import PKHUD


class MyListViewController: UIViewController {
    
    //MARK: IBOutlets Vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userListLabel: UILabel!
    
    //MARK: Vars
    var userID: String?
    var userData: UserModel?
    var likeMusics = [MusicModel]()
    var musicRef = Database.database().reference().child("Users")
    
    var player = AVAudioPlayer()
    var flag: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserID()
        getUserData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "myListCell")
        
        fetchMyMusiList()
        tableView.reloadData()
        
    }
    //MARK: Helpers
    fileprivate func fetchMyMusiList(){
        
        HUD.show(.progress)
        likeMusics.removeAll()
        musicRef.child(userID!).observe(.value) { (_snapShot) in
            
            print("_snapShot :",_snapShot)
            
            for snapShot in _snapShot.children {
                
                print("snapShot :",snapShot)
                let snap = snapShot as! DataSnapshot
                print("snap :",snap)
                let musicData = MusicModel(snapShot: snap)
                
                print("musicData :",musicData)
                //後ろではなく、先頭に追加されていく
                self.likeMusics.insert(musicData, at: 0)
                self.tableView.reloadData()
                
            }
            print("success Fetch")
            HUD.hide()
        }
    }
    fileprivate func getUserID(){
        
        HUD.dimsBackground = false
        if UserDefaults.standard.object(forKey: "userID") != nil {
            
            userID = UserDefaults.standard.object(forKey: "userID") as? String
            
        }else{
            print("userID Error")
        }
        
    }
    fileprivate func getUserData(){
        
        let ref = Database.database().reference().child("UsersProfile")
        ref.child(userID!).observe(.value) { (snapShot) in
            
            self.userData = UserModel(snapShot: snapShot)
            self.userListLabel.text = "\(self.userData!.userName)'s List"
        }
    }
    

}
//MARK: UITableView Delegate
extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return likeMusics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let myListCell = tableView.dequeueReusableCell(withIdentifier: "myListCell", for: indexPath) as? MyListTableViewCell else {
            
            print("MyListCell Error")
            return MyListTableViewCell()
        }
        
        let playButton = PlayMusicButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        myListCell.addSubview(playButton)
            
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.trailingAnchor.constraint(equalTo: myListCell.View.trailingAnchor, constant: -20).isActive = true
        playButton.centerYAnchor.constraint(equalTo: myListCell.centerYAnchor).isActive = true
        playButton.backgroundColor = UIColor.systemGreen
        
        playButton.addTarget(self, action: #selector(MyListViewController.musicPlay(_:)), for: .touchUpInside)
        //MARK:　要学習
        playButton.params["value"] = indexPath.row
            
        myListCell.backgroundColor = UIColor.systemTeal
        let music = likeMusics[indexPath.row]
        myListCell.toFields(musicModel: music)
       
        return myListCell
    }
    @objc func musicPlay(_ sender: PlayMusicButton) {
        
        player.stop()
        let indexNumber = sender.params["value"] as! Int
        guard let urlString = likeMusics[indexNumber].likePreviewUrl else {
            print("url String Error")
            return
        }
        let url = URL(string: urlString)
        
        if flag == true {
            
            downloadMusic(url: url!)
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = UIColor.systemRed
            flag = false
            
        }else if flag == false {
            
            player.stop()
            sender.setTitle("Start", for: .normal)
            sender.backgroundColor = UIColor.systemGreen
            flag = true
            
        }
    }
    func downloadMusic(url: URL) {
        
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
            
            do{
                
                self.play(url: url!)
            
            }catch let error {
                
                print(error.localizedDescription)
            }
        })
        
        downloadTask.resume()
        
    }
    func play(url: URL){
        
        self.player = try! AVAudioPlayer(contentsOf: url)
        self.player.prepareToPlay()
        self.player.volume = 1.0
        self.player.play()

    }
    
    
    
}


//MARK: URLSessionDownload Delegate
extension MyListViewController: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("complete Download")
    }


}
