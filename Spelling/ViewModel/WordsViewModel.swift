//
//  WordsViewModel.swift
//  Spelling
//
//  Created by  g01dt00th on 02.02.2021.
//

import SwiftUI

final class WordsViewModel: ObservableObject {
    @Published var userName: String = "" {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: "userName")
        }
    }
    
    @Published var rightWordsCount = 0 {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: "rightWordsCount")
        }
    }
    
    init() {
        if let userName = UserDefaults.standard.value(forKey: "userName") as? String {
            self.userName = userName
        }
        
        if let count = UserDefaults.standard.value(forKey: "rightWordsCount") as? Int {
            self.rightWordsCount = count
        }
    }
}
