//
//  ContentView.swift
//  UnitConversion
//
//  Created by Isacco Bosio on 03/02/24.
//

import SwiftUI

struct Unit: Hashable {
    var unit: String
    var conversionRate: Double
}

let METER = Unit(unit: "meters", conversionRate: 1.0)
let KILOMETER = Unit(unit: "kilometers", conversionRate: 1000.0)
let YARDS = Unit(unit: "yards", conversionRate: 0.9144)
let MILE = Unit(unit: "miles", conversionRate: 1609.34)

struct ContentView: View {
    @State private var inputValue = 1.0
    @State private var inputUnit = METER
    @State private var outputUnit = MILE
    
    var unitsList: [Unit] = [METER, KILOMETER, YARDS, MILE]
    
    var outputValue: Double {
        let inputValueInMeters = inputUnit.conversionRate * inputValue;
        let outputValue = inputValueInMeters / outputUnit.conversionRate;
        return outputValue
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Convert") {
                    TextField("Input value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("Available conversions", selection: $inputUnit) {
                        ForEach(unitsList, id: \.self) {
                            Text($0.unit)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Convert to") {
                    Picker("Available conversions", selection: $outputUnit) {
                        ForEach(unitsList, id: \.self) {
                            Text($0.unit)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text("\(outputValue)")
                }
            }
            .navigationTitle("Unit conversion")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
