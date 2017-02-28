//
//  TestViewController.swift
//  LearningToSpeakAlphabets
//
//  Created by Sanika Kulkarni on 2/21/17.
//  Copyright © 2017 Sanika Kulkarni. All rights reserved.
//

import UIKit
import Speech


//This class tests the speech of kids
class TestViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var startrecobutton: UIButton!
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var microphoneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        startrecobutton.backgroundColor = UIColor.black
        startrecobutton.layer.borderWidth = 1.0
        startrecobutton.layer.borderColor = UIColor(white: 0.0, alpha: borderAlpha).cgColor
        startrecobutton.layer.cornerRadius = cornerRadius
        
        
        textBox.text = "Click Start Recording ..."
        textBox.textColor = UIColor.black
        
        microphoneButton.isEnabled = false
        
        speechRecognizer.delegate = self
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            }
            
            OperationQueue.main.addOperation() {
                self.microphoneButton.isEnabled = isButtonEnabled
            }
        }
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio engine has no input node")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textBox.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.microphoneButton.isEnabled = true
                
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textBox.text = "Say something, I'm listening!"
        
    }

    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            microphoneButton.isEnabled = true
        } else {
            microphoneButton.isEnabled = false
        }
    }
    
    @IBAction func record(_ sender: Any) {
        textBox.textColor = UIColor.black
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            microphoneButton.isEnabled = false
            microphoneButton.setImage(UIImage(named:"Start-Recording.png"), for: UIControlState.normal)
            let theString = self.textBox.text.lowercased()
            let fullNameArr = theString.characters.split{$0 == " "}.map(String.init)
            if fullNameArr.count ==  1 {
                var check = false
                for char in "abcdefghijklmnopqrstuvwxyz".characters {
                    if fullNameArr[0][fullNameArr[0].startIndex] == char  {
                        let alert = UIAlertController(title: "Perfect", message: "Good job!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        check = true
                        break
                    }
                }
                if check == false{
                    let alert = UIAlertController(title: "Oops", message: "Keep Trying!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            else if fullNameArr.count == 3 {
                var check = false
                for char in "abcdefghijklmnopqrstuvwxyz".characters {
                    if fullNameArr[0][fullNameArr[0].startIndex] == char  && fullNameArr[2][fullNameArr[2].startIndex] == char{
                        let alert = UIAlertController(title: "Perfect", message: "Good job!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        check = true
                        break
                    }
                }
                if check == false {
                    let alert = UIAlertController(title: "Oops", message: "Keep Trying!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

            }
            else {
                let alert = UIAlertController(title: "Awesome", message: "Keep Trying!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

            
        } else {
            startRecording()
            microphoneButton.setImage(UIImage(named:"Stop-Recording.png"), for: UIControlState.normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
