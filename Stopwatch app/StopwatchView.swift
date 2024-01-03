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
    @State private var savedTime = ""
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text(elapsedTime)
                .font(.largeTitle)
                .padding()

            HStack {
                Button(action: startStopTimer) {
                    Text(isRunning ? "Stop" : "Start")
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(isRunning ? Color.red : Color.green)
                        .cornerRadius(15)
                }

                Button(action: resetTimer) {
                    Text("Reset")
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
            }

            VStack {
                Button(action: saveTime) {
                    Text("Save Time")
                        .foregroundColor(.white)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Color.orange)
                        .cornerRadius(15)
                }

                if !savedTime.isEmpty {
                    Text("Saved Time: \(savedTime)")
                        .font(.headline)
                        .padding()
                }
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
        savedTime = elapsedTime // Save the current elapsed time
    }

    func resetTimer() {
        timer?.invalidate()
        isRunning = false
        elapsedTime = "00:00:00"
        savedTime = "" // Clear the saved time as well
    }

    func formatTime(_ totalSeconds: TimeInterval) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
    }
}

