//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Jean-Marc Kampol Mieville on 5/23/2559 BE.
//  Copyright © 2559 Jean-Marc Kampol Mieville. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    

    @IBAction func RecordAudio(sender: AnyObject) {
        print("record the button")
        configureRecordingButtons(isRecording: true)
        /*
        recordingLabel.text = "Recording in progress..."
        recordingLabel.textColor = UIColor.red
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
 */
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func StopRecordAudio(sender: AnyObject) {
        print("stop recording the audio")
        configureRecordingButtons(isRecording: false)
        /*
        recordingLabel.text = "Tap to Record"
        recordingLabel.textColor = UIColor.gray
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
 */
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    func configureRecordingButtons(isRecording: Bool){
        recordingLabel.text = isRecording ? "Recording in progress" : "Tap to record"
        recordButton.isEnabled = isRecording ? false : true
        recordingLabel.textColor = isRecording ? UIColor.red : UIColor.gray
        stopRecordingButton.isEnabled = isRecording ? true : false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")
        stopRecordingButton.isEnabled = false
    }
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("AVAudioRecorder finished saving recording")
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
        } else {
            print("Saving of recording failed")
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}
