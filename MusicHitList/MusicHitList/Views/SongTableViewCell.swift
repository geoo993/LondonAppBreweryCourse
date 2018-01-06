//
//  SongTableViewCell.swift
//  MusicHitList
//
//  Created by GEORGE QUENTIN on 06/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit

class SongTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var playAudioImageView: UIImageView!
    @IBOutlet weak var stopAudioImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var song : Song = .none {
        didSet {
            songLabel?.text = song.rawValue
            artistLabel?.text = Song.artist(ofSong: song)
        }
    }
    
    
}
