//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Isacco Bosio on 04/02/24.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .font(.title)
            .tint(.orange)
    }
}

struct ContentView: View {
    let choices = ["Rock", "Paper", "Scissors"]
    let choicesAsEmoji = ["🪨", "📄", "✂️"]
    let winChoice = ["Paper", "Scissors", "Rock"]
    
    @State private var appPick = Int.random(in: 0...2)
    @State private var score = 0
    @State private var userShouldWin = Bool.random()
    
    var body: some View {
        VStack {
            Text("Score \(score)")
                .font(.headline.bold())
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("App picked \(choicesAsEmoji[appPick])")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                VStack {
                    Text("Beat the app")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                    
                    Text("\(userShouldWin ? "winning" : "losing") this round")
                        .font(.title)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundColor(userShouldWin ? .green : .red)
                }
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                ForEach(choices, id: \.self) { choice in
                    Button {
                        onUserPick(choice)
                    } label: {
                        Text("\(choicesAsEmoji[choices.firstIndex(of: choice) ?? 0])")
                                .frame(maxWidth: .infinity)
                    }
                    .modifier(ButtonModifier())
                }
            }
            .padding()
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func onUserPick(_ userPick: String) {
        let userWon = userPick == winChoice[appPick]
        let userPickTheSame = userPick == choices[appPick]
        
        if userShouldWin && userWon && !userPickTheSame {
            score += 1
        } else if !userShouldWin && !userWon && !userPickTheSame{
            score += 1
        }
        
        appPick = Int.random(in: 0...2)
        userShouldWin.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
