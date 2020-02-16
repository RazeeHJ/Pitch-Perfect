//
//  Player.swift
//  PitchPerfect
//
//  Created by Razee Hussein-Jamal on 2/16/20.
//  Copyright © 2020 Razee Hussein-Jamal. All rights reserved.
//

import AVFoundation

enum action {
    case record
    case stop
}

protocol Record {
    func perform(action: action)
}

typealias callback = ((URL?) -> Void)
typealias recordCallback = ((URL?) -> Void)

// MARK: RecordService 

class RecordService: NSObject, AVAudioRecorderDelegate {
    let session: AVAudioSession
    var audioRecorder: AVAudioRecorder!
    var filePath: URL?
    
    private var recordCallback: ((URL?) -> Void)?

    
    init(session: AVAudioSession) {
        self.session = AVAudioSession.sharedInstance()
    }
    
    func getAudioRecordingUrl(completion: @escaping ((URL?) -> Void)) {
        self.recordCallback = completion
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.recordCallback?(audioRecorder.url)
        } else {
            self.recordCallback?(nil)
        }
    }
    
    func configure() {
        configureFileDirectory()
        configureAV()
    }
    
    private func configureFileDirectory() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        filePath = URL(string: pathArray.joined(separator: "/"))
    }
    
    private func configureAV() {
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
}

extension RecordService: Record {
    func perform(action: action) {
        switch action {
        case .record:
            audioRecorder.record()
        case .stop:
            audioRecorder.stop()
        }
    }
}
