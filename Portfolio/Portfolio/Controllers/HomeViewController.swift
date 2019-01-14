//
//  HomeViewController.swift
//  Onboard
//
//  Created by GEORGE QUENTIN on 12/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//
// https://github.com/vimeo/VimeoNetworking
// https://github.com/superm0/HCVimeoVideoExtractor
// https://developer.vimeo.com/api/authentication
// https://developer.vimeo.com/apps/
// https://github.com/vimeo/VimeoNetworking/blob/develop/VimeoNetworkingExample-iOS/VimeoNetworkingExample-iOS/MasterViewController.swift
// https://developer.vimeo.com/api/reference

import UIKit
import AppCore
import SVProgressHUD
import VimeoNetworking
import SafariServices

class HomeViewController: UICollectionViewController {
    
    var clientIdentifyier: String { return "677bb4892ac8aea6c80f5f86ed5ecd4a8b60cca8" }
    var clientSecrets: String { return  "Zh02I4XbdsPY6TdK4L5beCLK2fRDAehe4K1Jh0qwdPwV3CJEVBzanW8CQ1a1XHdWzYq0NP9yqkG3C6r2FX3g5JF2fPFsr8j8fgSNibZO5QVIHbemmkYnDiZseBevMp1O"
    }
    var accessToken: String { return "807dd39c7ee28d430d7ec8d50ca77f75" }
    public var keyChainservice: String = ""
    
    var videos: [VimeoVideo] = []
    {
        didSet
        {
            DispatchQueue.main.async {
                print(self.videos.count)
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVimeo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController?.isCollapsed ?? true
        super.viewWillAppear(animated)
        
        // Show the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Hide the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupVimeo() {
        let appConfiguration = AppConfiguration(
            clientIdentifier: clientIdentifyier,
            clientSecret: clientSecrets,
            scopes: [.Public, .Private, .Interact], keychainService: keyChainservice)
        
        
        let vimeoClient = VimeoClient(appConfiguration: appConfiguration) { (vimeoSessionManager) -> VimeoSessionManager in
            return vimeoSessionManager
        }
        
        let authenticationController = AuthenticationController(client: vimeoClient, appConfiguration: appConfiguration) { (vimeoSessionManager) -> VimeoSessionManager in
            
            return vimeoSessionManager
        }
        //credentialsGrant(vimeoClient: vimeoClient, authenticationController: authenticationController)
        authWithAccessToken(vimeoClient: vimeoClient, authenticationController: authenticationController)
    }
    
    func fetchVimeoVideoData(urlString: String, completion: @escaping ((VimeoVideo?) -> Void) ) {
        let url = URL(string: urlString)! //"https://vimeo.com/301307525"
        VimeoVideoExtractor.fetchVideoURLFrom(url: url, completion: { ( video, error)  in
            if let err = error {
                print("Error = \(err.localizedDescription)")
                completion(nil)
                return
            }
            completion(video)
        })
        
    }
    
    func credentialsGrant(vimeoClient: VimeoClient, authenticationController: AuthenticationController) {
        authenticationController.clientCredentialsGrant { [weak self] result in
            guard let strongSelf = self else
            {
                return
            }
            
            switch result {
            case .success(let account):
                print("Successfully authenticated with account: \(account), \(account.isAuthenticatedWithUser())")
                //strongSelf.auth(authenticationController: authenticationController, account: account)
                //strongSelf.setupAccountObservation(vimeoClient: vimeoClient, account: account)
            case .failure(let error):
                print("error authenticating: \(error)")
            }
        }
        
        
    }

    func authWithAccessToken(vimeoClient: VimeoClient, authenticationController: AuthenticationController) {
        SVProgressHUD.show()
        authenticationController.accessToken(token: accessToken) { [weak self] result in
            guard let strongSelf = self else
            {
                return
            }
            switch result
            {
            case .success(let account):
                print("authenticated successfully: \(account), \(account.isAuthenticatedWithUser())")
                strongSelf.setupAccountObservation(vimeoClient: vimeoClient, account: account)
            case .failure(let error):
                SVProgressHUD.dismiss()
                print("failure authenticating: \(error)")
            }
        }
        
    }
    
    // MARK: - Setup
    
    private func setupAccountObservation(vimeoClient: VimeoClient, account: VIMAccount)
    {
       
        let request: Request<[VIMVideo]>
        if vimeoClient.currentAccount?.isAuthenticatedWithUser() == true
        {
            print("Choosing my videos")
            request = Request<[VIMVideo]>(path: "/me/videos")
        }
        else
        {
            print("Choosing staff pics")
            request = Request<[VIMVideo]>(path: "/channels/staffpicks/videos")
        }
        
        let _ = vimeoClient.request(request) { [weak self] result in
            
            guard let strongSelf = self else
            {
                return
            }
            
            switch result
            {
            case .success(let response):
                
                SVProgressHUD.dismiss()
                
                strongSelf.convertToVimeoVideo(model: response.model)
                strongSelf.checkNextPage(vimeoClient: vimeoClient, response: response)
               
            case .failure(let error):
                SVProgressHUD.dismiss()
                let title = "Video Request Failed"
                let message = "\(request.path) could not be loaded: \(error.localizedDescription)"
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                strongSelf.present(alert, animated: true, completion: nil)
            }
        }
        self.updateNavigationBar(account: account, request: request)
    }
    
    func checkNextPage(vimeoClient: VimeoClient, response: Response<[VIMVideo]>) {
        if let nextPageRequest = response.nextPageRequest
        {
            print("starting next page request")
            
            let _ = vimeoClient.request(nextPageRequest) { [weak self] result in
                
                guard let strongSelf = self else
                {
                    return
                }
                
                if case .success(let response) = result
                {
                    print("next page request completed!")
                    strongSelf.convertToVimeoVideo(model: response.model)
                    strongSelf.checkNextPage(vimeoClient: vimeoClient, response: response)
                    //strongSelf.videos.append(contentsOf: response.model)
                    //strongSelf.collectionView.reloadData()
                }
            }
        }
    }
    
    func convertToVimeoVideo(model: [VIMVideo]) {
        for video in model {
            if let link = video.link {
                fetchVimeoVideoData(urlString: link, completion: { video in
                    
                    guard let vid = video else {
                        print("Invalid video object")
                        return
                    }
                    
                    self.videos.append(vid)
                    
                    //print("Title = \(vid.title), url = \(vid.videoURL), thumbnail = \(vid.thumbnailURL)",
                    //    "id = \(vid.profileID), name = \(vid.profileName), profile url = \(vid.profileUrl)",
                    //    "profile image = \(vid.profileImage)")
                    
                })
            }
        }
    }
    
    private func updateNavigationBar(account: VIMAccount, request: Request<[VIMVideo]>) {
        self.navigationItem.title = account.user?.name
        if account.isAuthenticatedWithUser() == true
        {
            //self.authenticationButton?.title = "Log Out"
        }
        else
        {
            //self.authenticationButton?.title = "Log In"
        }
    }
    
    func openWeb(with url: URL?) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }
    
    func openSafariVC(with url: URL?) {
        // https://www.youtube.com/watch?v=gnjXbR2eNDE
        if let url = url {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
   
}

//MARK: UICollectionViewDataSource
extension HomeViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vimeoCell", for: indexPath as IndexPath) as? VimeoCell {
            configureCell(cell: cell, forItemAt: indexPath)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func configureCell(cell: VimeoCell, forItemAt indexPath: IndexPath) {
        let vimeoVideo = self.videos[indexPath.row]
        if let thumbnail = vimeoVideo.thumbnailURL[Portfolio.VimeoThumbnailQuality.QualityBase] {
            cell.thumbnailImageView.loadImageUsingUrlString(with: thumbnail.absoluteString)
        }
        cell.titleLabel.text = vimeoVideo.title//videoTitle(thumbnailIndex: indexPath.row)
    }
 
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "vimeoCell", for: indexPath) as UICollectionReusableView
        return view
    }
    
}

//MARK: UICollectionViewDelegate
extension HomeViewController {
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vimeoVideo = self.videos[indexPath.row]
        if vimeoVideo.videoURL.keys.contains(VimeoVideoQuality.Quality1080p) {
            openSafariVC(with: vimeoVideo.videoURL[VimeoVideoQuality.Quality1080p])
        } else if vimeoVideo.videoURL.keys.contains(VimeoVideoQuality.Quality720p) {
            openSafariVC(with: vimeoVideo.videoURL[VimeoVideoQuality.Quality720p])
        } else if vimeoVideo.videoURL.keys.contains(VimeoVideoQuality.Quality640p) {
            openSafariVC(with: vimeoVideo.videoURL[VimeoVideoQuality.Quality640p])
        } else if vimeoVideo.videoURL.keys.contains(VimeoVideoQuality.Quality540p) {
            openSafariVC(with: vimeoVideo.videoURL[VimeoVideoQuality.Quality540p])
        } else {
            openSafariVC(with: vimeoVideo.videoURL[VimeoVideoQuality.Quality360p])
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}
