//
// RecordSoundViewController.swift
//  PitchPerfect
//
//  Created by Reham on 23/10/2018.
//  Copyright © 2018 Reham. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
   
    //MARK: Variables
    var audioRecorder: AVAudioRecorder!
    
    //MARK: Outlets
    @IBOutlet weak var startRecoredingButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRecordingUI(state: false)
    }
    
    // Record audio button pressed
    @IBAction func recordAudio(_ sender: Any) {
        // configureing the UI
        configureRecordingUI(state: true)
        
        // Recording Audio
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
     
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // Stop recording button pressed
    @IBAction func stopRecording(_ sender: Any) {
        // Configureing the UI
        configureRecordingUI(state: false)
        
        // Recording Audio
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: - Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
             performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    // Show PlaySoundsViewController and send recorded audio URL
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "stopRecording" else { return }
        guard let playSoundsVC = segue.destination as? PlaySoundsViewController else { return }
        guard let recordedAudioURL = sender as? URL else { return }
        playSoundsVC.recordedAudioURL = recordedAudioURL
    }
    
    // Configureing the UI
    func configureRecordingUI(state: Bool){
        recordingLabel.text = state ? "Recording in Progress" : "Tap to record"
        stopRecordingButton.isEnabled = state
        startRecoredingButton.isEnabled = !state
    }
}

