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
        GeometryReader { geometry in
            ZStack {
                // Diagonal split background
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                    path.closeSubpath()
                }
                .fill(Color.gray)

                Path { path in
                    path.move(to: CGPoint(x: geometry.size.width, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: 0, y: geometry.size.height))
                    path.closeSubpath()
                }
                .fill(Color.white)
                .offset(y: -30)

                // Overlay with blur effect
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .blur(radius: 20)
                    .edgesIgnoringSafeArea(.all)

                // Stopwatch UI elements
                VStack {
                    Text(elapsedTime)
                        .font(.largeTitle)
                        .foregroundColor(.black) // Ensuring the text is visible
                        .padding()
                        .background(Color.white.opacity(0.5)) // Semi-transparent background for better visibility
                        .cornerRadius(10)
                        .padding(.top, geometry.safeAreaInsets.top)

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

                    Button(action: saveTime) {
                        Text("Save Time")
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            .background(Color.orange)
                            .cornerRadius(15)
                    }

                    // Display all saved times
                    ScrollView {
                        ForEach(savedTimes, id: \.self) { time in
                            Text(time)
                                .font(.headline)
                                .padding()
                        }
                    }

                    Button("Delete All Saved Times") {
                        deleteAllSavedTimes()
                    }
                    .foregroundColor(.red)
                    .padding()

                    Spacer() // Pushes everything up
                }
                .offset(y: -30) // Adjust this value as needed
            }
        }
        .edgesIgnoringSafeArea(.all)
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
        savedTimes.append(elapsedTime) // Append the current elapsed time to the array
    }

    func resetTimer() {
        timer?.invalidate()
        isRunning = false
        elapsedTime = "00:00:00"
        savedTimes = [] // Optionally reset the saved times when the timer is reset
    }

    func formatTime(_ totalSeconds: TimeInterval) -> String {
        let hours = Int(totalSeconds) / 3600
        let minutes = Int(totalSeconds) / 60 % 60
        let seconds = Int(totalSeconds) % 60
        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }

    func deleteAllSavedTimes() {
        savedTimes.removeAll() // Clear the saved times array
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
    }
}

