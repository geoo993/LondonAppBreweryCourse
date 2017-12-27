//
//  ViewController.swift
//  Xylophone
//
//  Created by GEORGE QUENTIN on 27/12/2017.
//  Copyright © 2017 Geo Games. All rights reserved.
//

import UIKit
import AVFoundation
import AppCore

/*
 Easy Piano step-by-step: Frere Jacques or Brother John
 
 Frè-re   Jacques,  Frè-re  Jacques
 
 C – D – E – C          C – D – E – C
 
 1 –  2 – 3 -1        1 – 2 – 3 – 1
 
 
 Dor – mez    vous?   dor-mez  vous?
 
 E – F –  G         E  – F  – G
 
 3 – 4 –  5         3 – 4  – 5
 
 
 So – nnez  les ma – ti – nes ,
 
 G  –  A  – G      F  – E – C
 
 4 – 5 – 4         3  –  2 – 1
 
 
 So – nnez les ma -ti – nes ,
 
 G  –   A  –  G      F –  E  –  C
 
 4  –  5  –  4      3  –  2  –  1
 
 
 Ding, dang, dong!    (repeat)
 
 C  –   G  –   C
 
 1   – (L2)-  1
 
 
 */

public enum SoundError : Error {
    case soundError
    case audioProblem
}

public class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    var audioPlayer : AVAudioPlayer!
    @IBOutlet weak var cNote : UIButton!
    @IBOutlet weak var dNote : UIButton!
    @IBOutlet weak var eNote : UIButton!
    @IBOutlet weak var fNote : UIButton!
    @IBOutlet weak var gNote : UIButton!
    @IBOutlet weak var aNote : UIButton!
    @IBOutlet weak var bNote : UIButton!
    @IBOutlet weak var c2Note : UIButton!
    
    var errorCaught : SoundError?
    var soundNames : [String] {
        return ["note1", "note2", "note3", "note4", "note5", "note6", "note7", "note8"]
    }
    var notes : [UIButton] {
        return [cNote, dNote, eNote, fNote, gNote, aNote, bNote, c2Note]
    }
    
    @IBAction func notePressed ( _ sender : UIButton ) {
        noteSelected(noteTag: sender.tag)
    }
    
    func noteSelected(noteTag : Int) {
        let xylophoneSoundURL = Bundle.main.url(forResource: soundNames[noteTag - 1], withExtension: "wav")!
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: xylophoneSoundURL)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            errorCaught = (error as! SoundError)
            errorCaught = .soundError
            audioPlayer = nil
        }
        
        for note in notes {
            note.addBorder(borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 0)
        }
        
        let note = notes[noteTag - 1]
        note.addBorder(borderColor: UIColor.gray, borderWidth: 5, cornerRadius: 0)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

}

