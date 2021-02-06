//
//  SpellingApp.swift
//  Spelling
//
//  Created by  g01dt00th on 01.02.2021.
//

import SwiftUI

@main
struct SpellingApp: App {
    @StateObject private var viewModel = WordsViewModel()
    @StateObject private var speakModel = SpeakModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel, speakModel: speakModel)
        }
    }
}
