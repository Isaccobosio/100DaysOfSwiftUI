//
//  ContentView.swift
//  BetterRest
//
//  Created by Isacco Bosio on 05/02/24.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var idealBedTime = ""
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Please enter time" , selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .onChange(of: wakeUp) { _ in
                            calculateBedTime()
                        }
                }
                
                Section("Desired amount of sleep") {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                        .onChange(of: sleepAmount) { _ in
                            calculateBedTime()
                        }
                }
                
                Section("Daily coffee intake") {
                    Picker("Amount of coffee cups", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) { cupNum in
                            Text("^[\(cupNum) cup](inflect: true)")
                        }
                    }
                    .pickerStyle(.automatic)
                    .onChange(of: coffeeAmount) { _ in
                        calculateBedTime()
                    }
                }
                
                if idealBedTime != "" {
                    Section() {
                        VStack(alignment: .leading) {
                            Text("Your ideal bedtime is")
                                .font(.headline)
                            Text(idealBedTime)
                                .font(.largeTitle)
                        }
                        .padding(.vertical)
                    }
                } else {
                    Section() {
                        VStack(alignment: .leading) {
                            Text("Change your parameters to calculate your bedtime")
                                .font(.headline)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("BetterRest")
            .onAppear() {
                calculateBedTime()
            }
        }
    }
    
    func calculateBedTime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            idealBedTime = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            idealBedTime = "There was an error calcualting your bed time"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
