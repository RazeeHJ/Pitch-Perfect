//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Razee Hussein-Jamal on 2/12/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var dariusButton: UIButton!
    @IBOutlet weak var diakoButton: UIButton!
    @IBOutlet weak var kateButton: UIButton!
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb, darius, diako, kate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configureUI(.notPlaying)
    }
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
        switch (ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        case .darius:
            playSound(rate: 0.3, pitch: -1000, echo: false, reverb: true)
        case .diako:
            playSound(rate: 0.16, pitch: 200, echo: true, reverb: false)
        case .kate:
            playSound(rate: 0.4, pitch: -500, echo: false, reverb: false)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }
}
