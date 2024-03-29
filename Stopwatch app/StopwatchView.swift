//
//  StopwatchView.swift
//  Stopwatch app
//
//  Created by Kryštof Svejkovký on 03.01.2024.
//

import SwiftUI

struct StopwatchView: View {
    @State private var startTime = Date()
    @State private var isRunning = false
    @State private var accumulatedTime: TimeInterval = 0
    @State private var savedTimes: [String] = []
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer() // Pushes all content to the middle
                
                Text(formatTime(accumulatedTime))
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)

                HStack {
                    Button(action: startStopTimer) {
                        Text(isRunning ? "Stop" : "Start")
                            .foregroundColor(.white)
                            .padding()
                            .background(isRunning ? Color.red : Color.green)
                            .cornerRadius(15)
                    }

                    Button(action: resetTimer) {
                        Text("Reset")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                }

                Button(action: saveTime) {
                    Text("Save Time")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(15)
                }

                List {
                    ForEach(savedTimes, id: \.self) { time in
                        Text(time)
                            .font(.headline)
                    }
                    .onDelete(perform: deleteTime)
                }

                Button("Delete All Saved Times") {
                    deleteAllSavedTimes()
                }
                .foregroundColor(.red)
                .padding()

                Spacer() // Pushes all content to the middle
            }
        }
    }

    func startStopTimer() {
        if isRunning {
            timer?.invalidate()
            accumulatedTime += Date().timeIntervalSince(startTime)
            isRunning = false
        } else {
            startTime = Date()
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                let currentTime = Date()
                self.accumulatedTime += currentTime.timeIntervalSince(self.startTime)
                self.startTime = currentTime // Update start time for the next tick
            }
        }
    }

    func saveTime() {
        let timeString = formatTime(accumulatedTime)
        savedTimes.insert(timeString, at: 0) // Insert new time at the top of the list
    }

    func resetTimer() {
        timer?.invalidate()
        isRunning = false
        accumulatedTime = 0
    }

    func formatTime(_ totalSeconds: TimeInterval) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

    func deleteTime(at offsets: IndexSet) {
        savedTimes.remove(atOffsets: offsets)
    }

    func deleteAllSavedTimes() {
        savedTimes.removeAll()
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
    }
}

