//
//  SpeakModel.swift
//  Spelling
//
//  Created by  g01dt00th on 02.02.2021.
//

import Foundation
import AVFoundation

final class SpeakModel: NSObject, AVSpeechSynthesizerDelegate, ObservableObject {
    
    enum SpeechStatus {
        case didStart, didPause, didFinish, didContinue, didCancel
    }
    
    @Published var speechStatus: SpeechStatus = .didPause
    @Published var wasGreeted = false
    @Published var lastSpeaked = ""
    
    var synth: AVSpeechSynthesizer!
    
    override init() {
        super.init()
        self.synth = AVSpeechSynthesizer()
        self.synth.delegate = self
    }
    
    func speakText(text: String) {
        if speechStatus == .didFinish || speechStatus == .didCancel || speechStatus == .didPause {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "ru")
            synth.speak(utterance)
            DispatchQueue.main.async {
                self.lastSpeaked = text
            }
        } 
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        self.speechStatus = .didCancel
//        print("cancel")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        self.speechStatus = .didContinue
//        print("continue")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.speechStatus = .didFinish
//        print("finish")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        self.speechStatus = .didPause
//        print("pause")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.speechStatus = .didStart
//        print("start")
    }
}
