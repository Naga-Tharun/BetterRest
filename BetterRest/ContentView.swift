//
//  ContentView.swift
//  BetterRest
//
//  Created by Naga Tharun Makkena on 27/06/23.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
//    @State private var showingAlert = false
    
    var Bedtime: String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hours = (components.hour ?? 0) * 60 * 60
            let minutes = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hours+minutes), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = (wakeUp - prediction.actualSleep).formatted(date: .omitted, time: .shortened)
            
            return sleepTime;
//            alertTitle = "Your ideal sleep is..."
//            alertMessage = "\(sleepTime.formatted(date: .omitted, time: .shortened))"
            
        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//
            return "Sorry, there was a problem calculating your bedtime."
        }
//        showingAlert = true
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(.wheel)
                }
                
                Section {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section {
//                    Text("Daily coffee intake")
//                        .font(.headline)
                    
//                    Stepper(coffeeAmount==1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                    
                    Picker(selection: $coffeeAmount, label: Text("Daily coffee intake").font(.headline)) {
                        ForEach(1..<21) {
                            Text($0==1 ? "1 cup" : "\($0) cups")
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section {
                    Text("Recommended Bed Time \(Bedtime)")
                        .font(.headline)
                    
                    
                    
                }
            }
//            .alert(alertTitle, isPresented: $showingAlert) {
//                Button("OK") { }
//            } message: {
//                Text(alertMessage)
//            }
            
            .navigationTitle("BetterRest")
//            .toolbar {
//                Button("Calculate", action: calculateBedtime)
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
