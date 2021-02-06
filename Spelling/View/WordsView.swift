//
//  WordsView.swift
//  Spelling
//
//  Created by  g01dt00th on 03.02.2021.
//

import SwiftUI
import Combine

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.largeTitle)
            .padding(10)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}

struct WordsView: View {
    @ObservedObject var viewModel: WordsViewModel
    @ObservedObject var speakModel: SpeakModel
    @Environment(\.presentationMode) var presentationMode
    let wordModel = WordsModel()
    @State private var input = ""
    @State private var output = [""]
    @State private var word = [""]

    
    var body: some View {
        VStack {
         
            Text(output == word ? "Правильно" : "Неправильно")
                .font(.title)
                .lineLimit(1)
                .foregroundColor(output != word ? Color.red.opacity(Double(output.count / word.count)) : .green )
                
            
            HStack(spacing: 1) {
                ForEach(output.indices, id: \.self) { index in
                    Text(output[index])
                        .font(.system(size: 40))
                        .bold()
                        .italic()
                        .foregroundColor(output[index] == word[index] ? .green : .red)
                }
            }.frame(maxWidth: .infinity)
            
            TextField("Напиши слово", text: $input, onCommit: nextWord)
                .textFieldStyle(OvalTextFieldStyle())
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding()
                .onAppear(perform: {
                    let word = wordModel.getWord()
                    speakModel.speakText(text: word)
                    self.word = word.map{ String($0)}
                    
                })


            
            Button("Назад") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.title2)
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 10)
            
            Button("Повторить слово") {
                speakModel.speakText(text: word.reduce("",+))
                print(word.reduce("",+))
            }
            .font(.title2)
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 10)
            
            Button("Drop UD") {
                UserDefaults.standard.removeObject(forKey: "userName")
                viewModel.userName = ""
            }
            .font(.title2)
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            .shadow(radius: 10)
            
        }
        .frame(maxHeight: .infinity)
        .background(Color.yellow.ignoresSafeArea(.all))
        .onChange(of: input, perform: check)
        .onReceive(speakModel.$speechStatus, perform: checkLastSpeaked)

    }
    
    func checkLastSpeaked(_ value: Published<SpeakModel.SpeechStatus>.Publisher.Output) {
        let word = self.word.reduce("", +)
        if speakModel.lastSpeaked != word && !word.isEmpty {
            speakModel.speakText(text: "Правильно, следующее слово")
            speakModel.speakText(text: word)
        }
    }
    
    func nextWord() {
        if output == word {
            let queue = OperationQueue()
            queue.addOperation {
                speakModel.speakText(text: "Правильно, следующее слово")
            }
            queue.waitUntilAllOperationsAreFinished()
            
            input.removeAll()
            output.removeAll()
            word = wordModel.getWord().map{ String($0) }
            speakModel.speakText(text: word.reduce("",+))
            
        } else {
            
            speakModel.speakText(text: "Неправильно, повторяю слово")
            speakModel.speakText(text: word.reduce("",+))
            
        }
    }
    
    func check(_ value: String) {
        if value.count == word.count {
            output = value.map{ String($0)}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: nextWord)
            
        }
        if value.count > word.count {
            input.removeLast()
            output = input.map { String($0) }
        } else {
            output = value.map{ String($0)}
        }
    }
}

struct WordsView_Previews: PreviewProvider {
    static var previews: some View {
        WordsView(viewModel: WordsViewModel(), speakModel: SpeakModel())
    }
}
