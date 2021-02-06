//
//  OnboardingView.swift
//  Spelling
//
//  Created by  g01dt00th on 02.02.2021.
//

import SwiftUI
import Combine

struct OnboardingView: View {
    @ObservedObject var viewModel: WordsViewModel
    @ObservedObject var speakModel: SpeakModel
    @State private var userName = ""
    
    
    var body: some View {
        VStack {
            if speakModel.speechStatus == .didFinish {
                TextField("Твое имя", text: $userName, onCommit: {
                    viewModel.userName = userName
                    speakModel.speakText(text: "Приятно познакомиться, \(viewModel.userName)")
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .padding()
                
            } else {
                Image(systemName: "waveform.path.badge.plus")
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .padding()
                
                Button("print status") {
                    print(speakModel.speechStatus)
                }
            }
        }
        .onAppear(perform: speakGreeting)
    }
    
    func speakGreeting() {
        speakModel.speakText(text: "Привет, давай знакомиться! Как тебя зовут?")
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: WordsViewModel(), speakModel: SpeakModel())
    }
}
