//
//  HomeViewController.swift
//  Onboard
//
//  Created by GEORGE QUENTIN on 12/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//
// https://github.com/vimeo/VimeoNetworking
// https://github.com/superm0/HCVimeoVideoExtractor

import UIKit
import AppCore

class HomeViewController: UICollectionViewController {
    
    let clientIdentifyier = "677bb4892ac8aea6c80f5f86ed5ecd4a8b60cca8"
    let clientSecrets = "Zh02I4XbdsPY6TdK4L5beCLK2fRDAehe4K1Jh0qwdPwV3CJEVBzanW8CQ1a1XHdWzYq0NP9yqkG3C6r2FX3g5JF2fPFsr8j8fgSNibZO5QVIHbemmkYnDiZseBevMp1O"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://vimeo.com/301307525")!
        VimeoVideoExtractor
        .fetchVideoURLFrom(url: url, completion: { ( video: VimeoVideo?, error:Error?) -> Void in
            if let err = error {
                print("Error = \(err.localizedDescription)")
                return
            }
            
            guard let vid = video else {
                print("Invalid video object")
                return
            }
            
            print("Title = \(vid.title), url = \(vid.videoURL), thumbnail = \(vid.thumbnailURL)")
            /*
            if let videoURL = vid.videoURL[.Quality1080p] {
                let player = AVPlayer(url: videoURL)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true) {
                    player.play()
                }
            }
            */
        })
        
    }
   
    func thumbnailImage(thumbnailIndex: Int) -> UIImage {
        //thumbnailImageView.loadImageUsingUrlString(urlSring: thumbnail)
        return UIImage()
    }
    
    func videoTitle(thumbnailIndex: Int) -> String {
        //thumbnailImageView.loadImageUsingUrlString(urlSring: thumbnail)
        return "Hello"
    }
    
//    func setupThumbnailImage(thumbnail: String) {
//        //thumbnailImageView.loadImageUsingUrlString(urlSring: thumbnail)
//    }
    
    /*
    let thumbnailImageView: UIImageView = {
        let imageView: UIImageView()
        imageView.image = UIImage(named: "imageName")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    */
}

//MARK: UICollectionViewDataSource
extension HomeViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vimeoCell", for: indexPath as IndexPath) as? VimeoCell {
            configureCell(cell: cell, forItemAt: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func configureCell(cell: VimeoCell, forItemAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.black
        cell.thumbnailImageView.image = thumbnailImage(thumbnailIndex: indexPath.row)
        cell.titleLabel.text = videoTitle(thumbnailIndex: indexPath.row)
    }
 
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "vimeoCell", for: indexPath) as UICollectionReusableView
        return view
    }
    
}

//MARK: UICollectionViewDelegate
extension HomeViewController {
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10); //UIEdgeInsetsMake(topMargin, left, bottom, right);
    }
}
