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

typealias recordCallback = ((URL?) -> Void)

// MARK: RecordService 

class RecordService: NSObject {
    private var recordCallback: ((URL?) -> Void)?
    let session: AVAudioSession
    var audioRecorder: AVAudioRecorder!
    var filePath: URL?
    
    init(session: AVAudioSession) {
        self.session = AVAudioSession.sharedInstance()
    }
    
    func configure() {
           configureFileDirectory()
           configureAV()
    }
    
    func getAudioRecordingUrl(completion: @escaping ((URL?) -> Void)) {
        self.recordCallback = completion
    }

    private func configureFileDirectory() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = PlistUtil.getPlistValue(from: .WavFile) ?? ""
        let pathArray = [dirPath, recordingName]
       
        filePath = URL(string: pathArray.joined(separator: "/"))
    }
    
    private func configureAV() {
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
    }
}

extension RecordService: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.recordCallback?(audioRecorder.url)
        } else {
            self.recordCallback?(nil)
        }
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
