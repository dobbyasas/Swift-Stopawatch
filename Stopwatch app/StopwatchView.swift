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
    @State private var elapsedTime = "00:00:00"
    @State private var savedTimes: [String] = []
    @State private var timer: Timer?

    var body: some View {
        ZStack {
            // Plain white background
            Color.white.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer() // Pushes all content to the middle
                
                Text(elapsedTime)
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

                // Display saved times
                ScrollView {
                    VStack {
                        ForEach(savedTimes, id: \.self) { time in
                            Text(time)
                                .font(.headline)
                                .padding()
                        }
                    }
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
            isRunning = false
        } else {
            startTime = Date()
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                let currentTime = Date()
                let difference = currentTime.timeIntervalSince(self.startTime)
                self.elapsedTime = self.formatTime(difference)
            }
        }
    }

    func saveTime() {
        savedTimes.append(elapsedTime)
    }

    func resetTimer() {
        timer?.invalidate()
        isRunning = false
        elapsedTime = "00:00:00"
        savedTimes.removeAll()
    }

    func formatTime(_ totalSeconds: TimeInterval) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
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
