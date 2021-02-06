//
//  WordsListView.swift
//  Spelling
//
//  Created by  g01dt00th on 06.02.2021.
//

import SwiftUI

struct WordsListView: View {
    let words = WordsModel().words
    @State private var sections = [String]()
    

    
    var body: some View {
        List {
            ForEach(sections, id: \.self) { char in
                Section(header: Text(char)) {
                    ForEach(selectWordsFromFirstLetter(letter: char), id: \.self) { word in
                        Text(word)
                    }
                }
            }
            Section {
                Text("Всего слов: \(words.count)")
                    .foregroundColor(.secondary)
            }
        }
        .onAppear(perform: generateSections)
        .navigationTitle("Список слов")
    }
    
    func generateSections() {
        sections = Array(Set(words.map{String($0.first!)})).sorted()
    }
    
    func selectWordsFromFirstLetter(letter: String) -> [String] {
        words.filter({ (word) -> Bool in
            String(word.first!) == letter
        })
    }
    
}

struct WordsListView_Previews: PreviewProvider {
    static var previews: some View {
        WordsListView()
    }
}
