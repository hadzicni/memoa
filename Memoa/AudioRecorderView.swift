//
//  AudioRecorderView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

struct AudioRecorderView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var audioRecorder: AudioRecorder
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Spacer()
                
                // Recording indicator
                ZStack {
                    Circle()
                        .fill(audioRecorder.isRecording ? Color.red.opacity(0.2) : Color.gray.opacity(0.2))
                        .frame(width: 200, height: 200)
                    
                    Image(systemName: "waveform")
                        .font(.system(size: 80))
                        .foregroundStyle(audioRecorder.isRecording ? .red : .gray)
                }
                
                // Timer
                Text(formatTime(audioRecorder.recordingTime))
                    .font(.system(size: 48, weight: .light, design: .monospaced))
                    .foregroundStyle(audioRecorder.isRecording ? .red : .primary)
                
                Spacer()
                
                // Controls
                HStack(spacing: 60) {
                    if audioRecorder.audioData != nil {
                        Button {
                            audioRecorder.clearRecording()
                        } label: {
                            VStack {
                                Image(systemName: "trash.fill")
                                    .font(.system(size: 30))
                                Text("Delete")
                                    .font(.caption)
                            }
                            .foregroundStyle(.red)
                        }
                    }
                    
                    Button {
                        if audioRecorder.isRecording {
                            audioRecorder.stopRecording()
                        } else if audioRecorder.audioData == nil {
                            audioRecorder.startRecording()
                        }
                    } label: {
                        ZStack {
                            Circle()
                                .fill(audioRecorder.isRecording ? .red : .blue)
                                .frame(width: 80, height: 80)
                            
                            if audioRecorder.isRecording {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.white)
                                    .frame(width: 30, height: 30)
                            } else {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 30, height: 30)
                            }
                        }
                    }
                    
                    if audioRecorder.audioData != nil {
                        Button {
                            dismiss()
                        } label: {
                            VStack {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 30))
                                Text("Done")
                                    .font(.caption)
                            }
                            .foregroundStyle(.green)
                        }
                    }
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Record Audio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if audioRecorder.isRecording {
                            audioRecorder.stopRecording()
                            audioRecorder.clearRecording()
                        }
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 10)
        return String(format: "%02d:%02d.%01d", minutes, seconds, milliseconds)
    }
}

#Preview {
    AudioRecorderView(audioRecorder: AudioRecorder())
}
