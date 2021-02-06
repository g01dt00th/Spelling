//
//  ContentView.swift
//  Spelling
//
//  Created by  g01dt00th on 01.02.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WordsViewModel
    @ObservedObject var speakModel: SpeakModel
    
    var body: some View {
        if viewModel.userName.isEmpty {
            OnboardingView(viewModel: viewModel, speakModel: speakModel)
        } else {
            NavigationView {
                ScrollView {
                    NavigationLink(
                        destination: WordsView(viewModel: viewModel, speakModel: speakModel),
                        label: {
                            Text("Вперед!")
                                .font(.largeTitle)
                                .bold()
                                .italic()
                        })
                        .padding()
                        .disabled(speakModel.speechStatus != .didFinish)
                    NavigationLink(
                        destination: WordsListView(),
                        label: {
                            Text("Список слов")
                                .font(.largeTitle)
                                .bold()
                                .italic()
                        })
                }
                .navigationTitle("Привет, \(viewModel.userName)!")
                .onAppear(perform: speakGreeting)
            }
        }
    }
    
    func speakGreeting() {
        if !speakModel.wasGreeted {
        speakModel.speakText(text: "Привет, \(viewModel.userName)! Давай начнем!")
            speakModel.wasGreeted.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WordsViewModel(), speakModel: SpeakModel())
    }
}
