//
//  ViewController.swift
//  AdditionTesterFun
//
//  Created by Brian Wilson on 2/21/17.
//  Copyright © 2017 GetRunGo. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var num1: UILabel!
    @IBOutlet weak var num2: UILabel!
    @IBOutlet weak var answer: UILabel!
    @IBOutlet weak var checkMark: UIImageView!
    
    let defaults = UserDefaults.standard
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var translatedString = ""
    //private var answerString = ""
    
    private var answerString: String = "" {
        willSet {
           // print("answerString is now: \(newValue)")
        }
        
        didSet {
           // print("answerString was: \(oldValue)")
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        shuffleArray()
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            
            switch authStatus {
            case .authorized:
                break
                //okay to record
            case .denied:
                break
                //not okay to record
            case .restricted:
                break
            //not okay to record
            case .notDetermined:
                break
                //not okay to record
            }
            
//            OperationQueue.main.addOperation() {
//                //self.textView.text = textView.text
//            }
        }
        
        createProblem()
    }
    
    
    func createProblem() {
        checkMark.isHidden = true
        answer.text = ""
        var maxNum = 0
        let places: String = defaults.string(forKey: "Places")!
        switch places {
        case "ones":
            maxNum = 9
        //print("Ones")
        case "tens":
            maxNum = 99
        //print("Tens")
        case "hundreds":
            maxNum = 999
        //print("Hundreds")
        default:
            break
        }
        
        num1.text = String(arc4random_uniform(UInt32(maxNum)))
        num2.text = String(arc4random_uniform(UInt32(maxNum)))
        answerString = String(Int(num1.text!)! + Int(num2.text!)!)
        
        startRecording()
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
            print("audioSession properties weren't set because of an error")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        guard let inputNode = audioEngine.inputNode else {
            fatalError("Audio Engine has no input mode")
        }
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAuidoBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            if result != nil {
    
                if (result?.isFinal)! {
                    self.translatedString = (result?.bestTranscription.formattedString)!
                    self.convertSpeech()
                    self.checkAnswer()
                    isFinal = true
                }
            }
            
            if self.audioEngine.isRunning {
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
            }
 
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
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
            print("audioEngine couldn't start because of an error")
        }
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //okay to record
        } else {
            //don't record
        }
    }


    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        createProblem()
    }
    
    @IBAction func btnHomeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func checkAnswer() {
        if let actualAnswer = Int(answerString) {
            if let userAnswer = Int(answer.text!) {
                if actualAnswer == userAnswer {
                    answer.textColor = UIColor.init(red: 16/255, green: 199/255, blue: 42/255, alpha: 1.0)
                    //checkMark.isHidden = false
                    print("YES!!")
                } else {
                    answer.textColor = UIColor.red
                }
            }
        }
    }
    
    func convertSpeech() {
        if Int(translatedString) == nil { //If it's not an integer...
            print("ts = ", translatedString)
            switch translatedString {
            case "One":
                answer.text = "1"
            case "Two", "To", "Do":
                answer.text = "2"
            case "Three", "Through", "Siri":
                answer.text = "3"
            case "Four", "For":
                answer.text = "4"
            case "Five":
                answer.text = "5"
            case "Six":
                answer.text = "6"
            case "Seven":
                answer.text = "7"
            case "Eight", "Hey", "A":
                answer.text = "8"
            case "Nine", "No", "Known":
                answer.text = "9"
            case "Mine", "Mont", "Fine":
                answer.text = "9"
            case "Ten", "Town":
                answer.text = "10"
            default:
                answer.text = "0"
            }
        } else {
            answer.text = translatedString
        }
    }
    
    func shuffleArray() {
        var temp = [Int]()
        
        for i in 1...10 {
            temp.append(i)
        }
        
        let count = temp.count
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if i != j {
            swap(&temp[i], &temp[j])
            }
        }
        
        print(temp)
    }

}

