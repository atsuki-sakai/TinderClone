//
//  MyListViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/11.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseDatabase
import PKHUD

class MyListViewController: UIViewController {
    
    //MARK: IBOutlets Vars
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userListLabel: UILabel!
    
    //MARK: Vars
    var userID: String?
    var userData: UserModel?
    var likeMusics = [MusicModel]()
    var musicRef = Database.database().reference().child("Users")
    
    var player: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserID()
        getUserData()
        
        fetchMyMusiList()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MyMusicViewCell", bundle: nil), forCellWithReuseIdentifier: "CustomCell")
        collectionView.allowsSelection = true
        collectionView.reloadData()
        
    }
    //MARK: Helpers
    fileprivate func fetchMyMusiList(){
        
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
                self.collectionView.reloadData()
                
            }
            print("success Fetch")
            HUD.hide()
        }
    }
    fileprivate func getUserID(){
        
        HUD.dimsBackground = false
        HUD.show(.progress)
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
//MARK: CollectionView Delegate
extension MyListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return likeMusics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let myListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? MyMusicViewCell else {
            
            print("customCell Error")
            return MyMusicViewCell()
            
        }
        //再生ボタンの作成
        let playButton = PlayMusicButton()
        
        playButton.translatesAutoresizingMaskIntoConstraints = false
        myListCell.addSubview(playButton)
        
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playButton.bottomAnchor.constraint(equalTo: myListCell.bottomAnchor, constant: 10).isActive = true
        playButton.centerXAnchor.constraint(equalTo: myListCell.centerXAnchor, constant: 0).isActive = true
        
//        playButton.setImage(UIImage(named: "play"), for: .normal)
        
        playButton.addTarget(self, action: #selector(MyListViewController.musicPlay(_:)), for: .touchUpInside)
        //MARK:　要学習
        playButton.params["value"] = indexPath.row
        
        myListCell.backgroundColor = UIColor.opaqueSeparator
        let music = likeMusics[indexPath.row]
        myListCell.toLabel(musicModel: music)
        
        return myListCell
    }
    @objc func musicPlay(_ sender: PlayMusicButton){
        
        player.stop()
        
        //Poin *IndexPathをparamsに入れたものを、渡す
        let indexNumber: Int = sender.params["value"] as! Int
        
        let MusicUrlString = likeMusics[indexNumber].likePreviewUrl
        let url = URL(string: MusicUrlString!)
        print(url!)
        
        downloadMusic(url: url!)
    }
    
    fileprivate func downloadMusic(url: URL) {
        
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
            
            print("response : \(response)")
            self.play(url: url!)
            
        })
        
        //closureで値取得されるまではここが呼ばれる
        downloadTask.resume()
        
    }
    fileprivate func play(url: URL){
        
        do{
            
            self.player = try AVAudioPlayer(contentsOf: url)
            //再生準備をする = prepareToPlay()
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            
        }catch let error as NSError{
           
            print(error.localizedDescription)
            
        }
    }
    
}

//
////MARK: URLSessionDownload Delegate
//extension MyListViewController: URLSessionDownloadDelegate {
//
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        <#code#>
//    }
//
//
//}
