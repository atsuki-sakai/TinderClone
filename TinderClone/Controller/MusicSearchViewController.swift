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
import VerticalCardSwiper
import DTGradientButton
import AVFoundation

class MusicSearchViewController: UIViewController {

    //MARK: IBOutle Vars
    @IBOutlet weak var nosearchImageView: UIImageView!
    @IBOutlet weak var searchingLabel: UILabel!
    @IBOutlet weak var searchButton: CustomButton!
    //VerticalCardSwiperはUIViewを継承
    @IBOutlet weak var cardSwipeView: VerticalCardSwiper!
    
    //MARK: Vars
    var userProfile: UserModel?
    var userID: String?
    
    var imageStrings = [String]()
    var previewURLs = [String]()
    var artistNames = [String]()
    var musicNames = [String]()
    var trackViewUrls = [String]()
    
    var player = AVAudioPlayer()
    var playFlag: Bool = true
    
    //お気に入りを入れる配列
    var likeImageStrings = [String]()
    var likePreviewURLs = [String]()
    var likeArtistNames = [String]()
    var likeMusicNames = [String]()
    var likeTrackViewUrls = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardSwipeView.delegate = self
        cardSwipeView.datasource = self
        
        cardSwipeView.register(nib: UINib(nibName: "CardViewCell", bundle: nil), forCellWithReuseIdentifier: "cardCell")
        
        cardSwipeView.reloadData()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        userValidate()
        
    }
    @IBAction func searchButtonTaped(_ sender: Any) {
        
        searchAlert()
        
    }
    //MARK: Helpers
    private func getProfile(){
        
        let ref = Database.database().reference().child("UsersProfile")
        
        ref.child(userID!).observe(.value) { (snapShot) in
            
            self.userProfile = UserModel(snapShot: snapShot)
            
        }
    }
    fileprivate func userValidate(){
        
        if UserDefaults.standard.object(forKey: "userID") != nil {
            
            print(UserDefaults.standard.object(forKey: "userID") as! String)
            
            userID = UserDefaults.standard.object(forKey: "userID") as? String
            
            getProfile()
        
    
        }else{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let startVC = storyboard.instantiateViewController(withIdentifier: "start") as! StartViewController
            
            startVC.modalPresentationStyle = .fullScreen
            self.present(startVC, animated: true, completion: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    fileprivate func startParse(_ keyword: String){
        
        HUD.dimsBackground = true
        HUD.show(.progress)
        
        imageStrings.removeAll()
        previewURLs.removeAll()
        artistNames.removeAll()
        musicNames.removeAll()
        
        let urlString = "https://itunes.apple.com/search?term=\(keyword)&country=jp"
        
        convertJsonToURL(url: urlString) { (json) in
            
            var resultConut: Int = json["resultCount"].int!
            
            for i in 0 ..< resultConut {
                
                var artWorkURL = json["results"][i]["artworkUrl60"].string
                let previewUrl = json["results"][i]["previewUrl"].string ?? "No Data"
                let artistName = json["results"][i]["artistName"].string ?? "No Data"
                let trackViewUrl = json["results"][i]["trackViewUrl"].string ?? "No Data"
                let musicName = json["results"][i]["trackCensoredName"].string ?? "No Data"
                
                print("artworkURL\(i)番目 : \(artWorkURL!)")
                print("previewURL\(i)番目 : \(previewUrl)")
                print("artistName\(i)番目 : \(artistName)")
                print("trackViewUrl\(i)番目 : \(trackViewUrl)")
                print("musicName\(i)番目 : \(musicName)")
                
                
                if let range = artWorkURL?.range(of: "60x60bb"){
                    //画像のサイズを大きくして取得
                    artWorkURL?.replaceSubrange(range, with: "320x320bb")
                }
                
                self.imageStrings.append(artWorkURL!)
                self.previewURLs.append(previewUrl)
                self.artistNames.append(artistName)
                self.musicNames.append(musicName)
                self.trackViewUrls.append(trackViewUrl)
                
                if self.musicNames.count == resultConut {
                    
                    //遷移
                    print("Alamofire Success")
                    print("artistNamesCount : \(self.artistNames.count)")
                    
                    self.cardSwipeView.reloadData()
                    self.searchingLabel.isHidden = true
                    self.nosearchImageView.isHidden = true
                    HUD.hide()
                    
                }
            }
            
        }
        
    }
    fileprivate func searchAlert(){
        
        print("alert 1 ")
        
        let searchAlert = UIAlertController(title: "SearchMusic", message: nil, preferredStyle: .alert)
        
        searchAlert.addTextField { (textField) in
            
            textField.placeholder  = "MusicTitle"
            
        }
        let searchAction = UIAlertAction(title: "Done", style: .default) { (alertAction) in
            
            //検索開始
            
            guard let textField = searchAlert.textFields?.first else{
                print("no field")
                return
            }
            
            if textField.text == ""{
                textField.text = "No Text"
            }
            self.startParse(textField.text!)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        searchAlert.addAction(searchAction)
        searchAlert.addAction(cancelAction)
        
        self.present(searchAlert, animated: true, completion: nil)
        
    }
    fileprivate func convertJsonToURL(url: String, completion: @escaping(JSON) -> Void){
        
        //keywordを検索可能な状態に変換する。
        let Url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        AF.request(Url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            
            switch (response.result){
                
            case .success:
                
                let json:JSON = JSON(response.data as Any)
                
                completion(json)
                
            case .failure(let error):
                
                print(error.localizedDescription)
                return
            }
        }
        
    }
    public func randomBackgroundColor() -> UIColor {
        
        //arc4random()でランダムに数字を生成
        let randomRed: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomGreen: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        let randomBlue: CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
}
//MARK: TextField Delegate
extension MusicSearchViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
}
//MARK: Vertical Swiper Delegate
extension MusicSearchViewController: VerticalCardSwiperDelegate, VerticalCardSwiperDatasource {
    
    
    func numberOfCards(verticalCardSwiperView: VerticalCardSwiperView) -> Int {
        
        return artistNames.count
    }
    
    func cardForItemAt(verticalCardSwiperView: VerticalCardSwiperView, cardForItemAt index: Int) -> CardCell {
        
        guard let cardCell = verticalCardSwiperView.dequeueReusableCell(withReuseIdentifier: "cardCell", for: index) as? CardViewCell else{
            
            print("cardCell Error")
            return CardCell()
            
        }
        //これでcardForItemとwillSwiperのindexNumberが一致、予想通りの動きとなる
        let indexNumber = index + 1
        print("cardForItem index : \(indexNumber)")
        
        //verticalSwipeViewの背景色 cardSwipeViewではない事に注意
        verticalCardSwiperView.backgroundColor = UIColor.darkGray
        cardCell.backgroundColor = randomBackgroundColor()
        
        cardCell.artistNameLabel.text = artistNames[indexNumber]
        cardCell.artistNameLabel.textColor = UIColor.white
        cardCell.artistNameLabel.adjustsFontSizeToFitWidth = true
        
        cardCell.musicTitleLabel.text = musicNames[indexNumber]
        cardCell.musicTitleLabel.textColor = UIColor.white
        cardCell.musicTitleLabel.adjustsFontSizeToFitWidth = true
        
        cardCell.artWorkImageView.sd_setImage(with: URL(string: imageStrings[indexNumber])) { (image, error, _, _) in
            
            cardCell.artWorkImageView.setNeedsLayout()
            
        }
        cardCell.artWorkImageView.clipsToBounds = true
        cardCell.artWorkImageView.layer.masksToBounds = false
        cardCell.artWorkImageView.layer.shadowColor = UIColor.darkGray.cgColor
        cardCell.artWorkImageView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        cardCell.artWorkImageView.layer.shadowRadius = 4
        cardCell.artWorkImageView.layer.shadowOpacity = 0.8
        
        let playButton = PlayMusicButton()
        playButton.translatesAutoresizingMaskIntoConstraints = false
        cardCell.addSubview(playButton)
        
        playButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        playButton.centerXAnchor.constraint(equalTo: cardCell.centerXAnchor).isActive = true
        playButton.bottomAnchor.constraint(equalTo: cardCell.bottomAnchor, constant: -20).isActive = true
        
        playButton.backgroundColor = UIColor.systemGreen
        
        playButton.params["value"] = indexNumber
        playButton.addTarget(self, action: #selector(MusicSearchViewController.musicPlayAction(_:)), for: .touchUpInside)
        
        return cardCell
    }
    @objc func musicPlayAction(_ sender: PlayMusicButton){
        
       
        if playFlag == true {
            
            player.stop()
            let indexNumber: Int = sender.params["value"] as! Int
            let url = URL(string: previewURLs[indexNumber])
            
            downloadMusic(url: url!)
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = UIColor.systemRed
            playFlag = false
            
        }else if playFlag == false {
            
            player.stop()
            sender.setTitle("Start", for: .normal)
            sender.backgroundColor = UIColor.systemGreen
            playFlag = true
            
        }
        
    }
    fileprivate func downloadMusic(url: URL) {
        
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: { (url, response, error) in
            
            self.musicPlay(url: url!)
            
            
        })
        
        downloadTask.resume()
    }
    
    
    fileprivate func musicPlay(url: URL) {
        
        do{
            
            self.player = try AVAudioPlayer(contentsOf: url)
            
            self.player.prepareToPlay()
            self.player.volume = 1.0
            self.player.play()
            
        }catch let error as NSError {
            
            print(error.localizedDescription)
        }
    }
    //swipeした時の処理
    func didSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        
        let indexNumber: Int = index
        print("didSwipe index : \(indexNumber)")
        //right swipe method
        HUD.show(.success)
        if swipeDirection == .Right {
            
            likeMusicNames.append(musicNames[indexNumber])
            likeArtistNames.append(artistNames[indexNumber])
            likePreviewURLs.append(previewURLs[indexNumber])
            likeImageStrings.append(imageStrings[indexNumber])
            likeTrackViewUrls.append(trackViewUrls[indexNumber])
            
                
            let musicData = MusicModel(userID: userProfile!.userId, userName: userProfile!.userName,userIcon: userProfile!.userIcon ,likeArtist: artistNames[indexNumber], likeMusic: musicNames[indexNumber], likePreviewUrl: previewURLs[indexNumber], likeArtistImage: imageStrings[indexNumber], trackViewURL: trackViewUrls[indexNumber])
            
            musicData.saveMusicData()
                
                
        }
        
        HUD.hide()
       
        
    }
    func willSwipeCardAway(card: CardCell, index: Int, swipeDirection: SwipeDirection) {
        
        let indexNumber = index
        print("WillSwipe index \(indexNumber)")
        
        artistNames.remove(at: indexNumber)
        musicNames.remove(at: indexNumber)
        previewURLs.remove(at: indexNumber)
        imageStrings.remove(at: indexNumber)
        trackViewUrls.remove(at: indexNumber)
        
    }
    //MARK: Helpers
    fileprivate func likesCount() -> Bool{
        
        return true
    }

}

extension MusicSearchViewController: URLSessionDownloadDelegate {

    //var downloadTask: URLSessionDownloadTaskの完了後に呼ばれる。
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("complete Dowwnload")
    }


}
