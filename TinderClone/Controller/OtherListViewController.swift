//
//  OtherListViewController.swift
//  TinderClone
//
//  Created by 酒井専冴 on 2020/04/13.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class OtherListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var userdata: [String]?
    var otherMusicLists = [MusicModel]()
    var musicRef: DatabaseReference = Database.database().reference().child("Users")
    var player = AVAudioPlayer()
    var playFlag: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "myListCell")
        
        
        getOtherMusics(userID: userdata![0])
        userNameLabel.text = "\(userdata![1])'s List"
        // Do any additional setup after loading the view.
    }
    fileprivate func getOtherMusics(userID: String){
        
        musicRef.child(userID).observe(.value) { (snapShot) in
            
            self.otherMusicLists.removeAll()
            
            for snap in snapShot.children {
                
                let otherMusic = MusicModel(snapShot: snap as! DataSnapshot)
                
                self.otherMusicLists.insert(otherMusic, at: 0)
                
            }
            self.tableView.reloadData()
        }
        
    }

}
extension OtherListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherMusicLists.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let otherCell = tableView.dequeueReusableCell(withIdentifier: "myListCell", for: indexPath) as? MyListTableViewCell else {
            
            print("Cell Error")
            return MyListTableViewCell()
        }
        
        let otherMusic = otherMusicLists[indexPath.row]
        
        otherCell.toFields(musicModel: otherMusic)
        
        let playButton = PlayMusicButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        otherCell.addSubview(playButton)
        
        playButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.trailingAnchor.constraint(equalTo: otherCell.View.trailingAnchor, constant: -20).isActive = true
        playButton.centerYAnchor.constraint(equalTo: otherCell.centerYAnchor).isActive = true
        playButton.backgroundColor = UIColor.systemGreen
        playButton.setTitle("Play", for: .normal)
        
        playButton.params["value"] = indexPath.row
        
        playButton.addTarget(self, action: #selector(OtherListViewController.playMusic(_:)), for: .touchUpInside)
        
        return otherCell
    }
    @objc func playMusic(_ sender: PlayMusicButton){
        
        
        let index: Int = sender.params["value"] as! Int
        let previewURL = otherMusicLists[index].likePreviewUrl
        let url = URL(string: previewURL!)
        
        player.stop()
        
        if playFlag == true{
            
            downloader(url: url!)
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = UIColor.systemRed
            
            playFlag = false
        }else{
            
            self.player.stop()
            sender.setTitle("Start", for: .normal)
            sender.backgroundColor = UIColor.systemGreen
            
            playFlag = true
        }
    }
    func downloader(url: URL){
        
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
            
            do{
                
                self.player = try AVAudioPlayer(contentsOf: url!)
                self.player.prepareToPlay()
                self.player.volume = 1.0
                self.player.play()
                
            }catch let error {
                
                print(error.localizedDescription)
            }
        })
        downloadTask.resume()
        
    }
    
}
extension OtherListViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("DownloadTask Completed")
        
    }
    
}
