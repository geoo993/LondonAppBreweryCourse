//
//  HitListViewController.swift
//  MusicHitList
//
//  Created by GEORGE QUENTIN on 06/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
// https://www.raywenderlich.com/173972/getting-started-with-core-data-tutorial-2
// https://stackoverflow.com/questions/41243007/how-to-include-nspersistentcontainer-in-appdelegate-swift-using-swift-3-0-in-xco
// https://cocoacasts.com/building-the-perfect-core-data-stack-with-nspersistentcontainer/
// https://cocoacasts.com/how-to-delete-every-record-of-a-core-data-entity
// https://stackoverflow.com/questions/39920792/deleting-all-data-in-a-core-data-entity-in-swift-3
// https://stackoverflow.com/questions/29542001/audio-playback-progress-as-uislider-in-swift

import UIKit
import CoreData
import AVFoundation
import AppCore

class HitListViewController: UIViewController, AVAudioPlayerDelegate {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MusicHitList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    var audioPlayer : AVAudioPlayer!
    var displayLink : CADisplayLink!
    var artists: [NSManagedObject] = []
    var activeCell : SongTableViewCell!
    var songToPlay : Song = .none {
        didSet {
            let artists = Song.artist(ofSong: songToPlay)
            saveArtist(name: artists)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func addName(_ sender: UIBarButtonItem) {
        showAlertController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Best Hits"
        tableView.register(UINib(nibName: "SongTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "songsTableCell")
        //tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchArtist()
        //deleteAllRecords()
    }
    
    func stopSong() {
        if audioPlayer != nil {
            audioPlayer.stop()
            audioPlayer = nil
            activeCell = nil
            displayLink.invalidate()
        }
    }
    
    func playSong ( ofCell cell: SongTableViewCell) {
        stopSong()
        guard let songURL = Bundle.main.url(forResource: cell.song.rawValue, withExtension: "mp3") else { 
            print("Could not find audio file")
            return 
        }
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: songURL)
            //audioPlayer.numberOfLoops = -1 // play indefinitely
            audioPlayer.prepareToPlay()
            audioPlayer.delegate = self
            audioPlayer.play()
            activeCell = cell
            displayLink = CADisplayLink(target: self, 
                                        selector: #selector(updateCellSlider) )
            displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        } catch {
            print("Could not play audio ", error)
            stopSong()
        }
    }
    
    @objc func updateCellSlider() {
        updateCellProgressBar(interval: audioPlayer.currentTime, maxValue: audioPlayer.duration)
    }

    func showAlertController() {
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Songs", 
                                                message: "Pick your fav song of the year", 
                                                preferredStyle: .alert)
        // Create the actions
        let action1 = UIAlertAction(title: "Unforgetable", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.songToPlay = .unforgetable
        }
        let action2 = UIAlertAction(title: "Sign Of The Times", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.songToPlay = .signOfTheTimes
        }
        let action3 = UIAlertAction(title: "Ordinary Love", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.songToPlay = .ordinaryLove
        }
        let action4 = UIAlertAction(title: "Millionaire", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.songToPlay = .millionaire
        }
        let action5 = UIAlertAction(title: "Mi Ente", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.songToPlay = .miEnte
        }
        let action6 = UIAlertAction(title: "Fell It Still", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.songToPlay = .fellItStill
        }
        let action7 = UIAlertAction(title: "The Greatest", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.songToPlay = .theGreatest
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        // Add the actions
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        alertController.addAction(action4)
        alertController.addAction(action5)
        alertController.addAction(action6)
        alertController.addAction(action7)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}


extension HitListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func updateCellProgressBar (interval: TimeInterval, maxValue : TimeInterval) {
        if let cell = activeCell {
            let progress = Float(interval / maxValue)
            cell.progressView.setProgress(progress, animated: true)
        }
    }
    
    func deselectCells() {
        for row in 0..<artists.count {
            let indexPath = IndexPath(row: row, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) as? SongTableViewCell else { return }
            cell.playAudioImageView.isHidden = false
            cell.stopAudioImageView.isHidden = true
            cell.progressView.progress = 0
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func selectRow(cell: SongTableViewCell, indexPath : IndexPath) {
        deselectCells()
        if cell.playAudioImageView.isHidden {
            stopSong()
        }else {
            playSong(ofCell: cell)
        }
        cell.playAudioImageView.isHidden = !(cell.playAudioImageView.isHidden)
        cell.stopAudioImageView.isHidden = !(cell.stopAudioImageView.isHidden)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "songsTableCell", 
                                     for: indexPath) as? SongTableViewCell,
                let artist = artists[indexPath.row].value(forKeyPath: "name") as? String {
                cell.song = Song.song(ofArtist: artist)
                cell.playAudioImageView.isHidden = false
                cell.stopAudioImageView.isHidden = true
                cell.progressView.progress = 0
                
                let lastIndex = (artists.count - 1)
                if indexPath.row == lastIndex {
                    selectRow(cell: cell, indexPath: indexPath)
                }
                return cell
            }
            
            return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SongTableViewCell
        selectRow(cell: cell, indexPath: indexPath)
    }
    
}

extension HitListViewController {
    
    func saveArtist(name: String) {
        
        // 1
        let managedContext = persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Artists",
                                                in: managedContext)!

        let artist = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        // 3
        artist.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
            self.artists.append(artist)
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchArtist() {
        //1
        let managedContext = persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Artists")
        
        //3
        do {
            artists = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllRecords() {
        //1
        let context = persistentContainer.viewContext
        
        //2
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Artists")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        //3
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error deleting records in data model")
        }
        
    }
    
}
