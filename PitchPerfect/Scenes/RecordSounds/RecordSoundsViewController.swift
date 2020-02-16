//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Razee Hussein-Jamal on 2/7/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
   // var audioRecorder: AVAudioRecorder!

    var recordService = RecordService(session: AVAudioSession.sharedInstance())
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
        
    // MARK: PlayingState (raw values correspond to sender tags)
    enum PlayingState { case playing, notPlaying }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordService.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureUI(false)
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(true)
        recordService.perform(action: .record)
    }

    @IBAction func stopRecording(_ sender: Any) {
        configureUI(false)
        
        recordService.perform(action: .stop)
        recordService.getAudioRecordingUrl { (url) in
            guard let url = url else {
                print("recording was not successful")
                return
            }
            self.performSegue(withIdentifier: "stopRecording", sender: url)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func configureUI(_ recordingState: Bool) {
        recordingLabel.text = recordingState ? "Recording in Progress": "Tap to Record"
        stopRecordingButton.isEnabled = recordingState
        recordButton.isEnabled = !recordingState
    }
}

