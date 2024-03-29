//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Isacco Bosio on 04/02/24.
//

import SwiftUI

struct FlagImage: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
    }
}

struct GameTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold())
            .foregroundStyle(.white)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctUnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var givenAnswers = 0
    @State private var showingResetAlert = false
    
    let MAX_ANSWERS = 4
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the flag")
                    .modifier(GameTitle())
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctUnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(flag: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: \(score). You have \(MAX_ANSWERS - givenAnswers) more attempt\(MAX_ANSWERS - givenAnswers > 1 ? "s" : "").")
        }
        .alert("Try again!", isPresented: $showingResetAlert) {
            Button("Reset game", action: resetGame)
        } message: {
            Text("Nice try. Your final score is: \(score).")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctUnswer {
            scoreTitle = "That's correct!"
            score += 1
        } else {
            scoreTitle = "Oops... Wrong answer. You tapped on \(countries[number]) flag"
        }
        
        givenAnswers += 1
        if givenAnswers >= MAX_ANSWERS {
            showingResetAlert = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctUnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        askQuestion()
        givenAnswers = 0
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
