//
//  EntryDetailView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

struct EntryDetailView: View {
    @Environment(DiaryStore.self) private var store
    let entry: DiaryEntry
    
    @State private var isEditing = false
    @State private var editedTitle: String
    @State private var editedContent: String
    @State private var editedMood: DiaryEntry.Mood
    @State private var audioPlayer = AudioPlayer()
    
    init(entry: DiaryEntry) {
        self.entry = entry
        _editedTitle = State(initialValue: entry.title)
        _editedContent = State(initialValue: entry.content)
        _editedMood = State(initialValue: entry.mood)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        if isEditing {
                            TextField("Title", text: $editedTitle)
                                .font(.title)
                                .bold()
                        } else {
                            Text(entry.title)
                                .font(.title)
                                .bold()
                        }
                        
                        Text(entry.date.formatted(date: .long, time: .shortened))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    if isEditing {
                        Picker("Mood", selection: $editedMood) {
                            ForEach(DiaryEntry.Mood.allCases, id: \.self) { mood in
                                Text(mood.rawValue).tag(mood)
                            }
                        }
                        .pickerStyle(.menu)
                    } else {
                        VStack {
                            Text(entry.mood.rawValue)
                                .font(.system(size: 50))
                            Text(entry.mood.name)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Divider()
                
                // Photos
                if let photoData = entry.photoData, !photoData.isEmpty, !isEditing {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(Array(photoData.enumerated()), id: \.offset) { _, data in
                                if let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                }
                
                // Audio Player
                if let audioData = entry.audioData, !isEditing {
                    VStack(spacing: 12) {
                        HStack {
                            Button {
                                if audioPlayer.isPlaying {
                                    audioPlayer.pause()
                                } else {
                                    audioPlayer.play()
                                }
                            } label: {
                                Image(systemName: audioPlayer.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                    .font(.system(size: 50))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(formatTime(audioPlayer.currentTime))
                                    .font(.system(.body, design: .monospaced))
                                    .foregroundStyle(.secondary)
                                
                                ProgressView(value: audioPlayer.currentTime, total: audioPlayer.duration)
                                    .tint(.blue)
                                
                                Text(formatTime(audioPlayer.duration))
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundStyle(.tertiary)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    .onAppear {
                        audioPlayer.loadAudio(data: audioData)
                    }
                }
                
                // Content
                if isEditing {
                    TextEditor(text: $editedContent)
                        .frame(minHeight: 300)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                } else {
                    Text(entry.content)
                        .font(.body)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        saveChanges()
                    }
                    isEditing.toggle()
                }
            }
        }
    }
    
    private func saveChanges() {
        var updatedEntry = entry
        updatedEntry.title = editedTitle
        updatedEntry.content = editedContent
        updatedEntry.mood = editedMood
        store.updateEntry(updatedEntry)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

#Preview {
    NavigationStack {
        EntryDetailView(entry: DiaryEntry(
            title: "A Great Day",
            content: "Today was amazing! I went for a walk in the park and enjoyed the beautiful weather. The sun was shining and I felt really peaceful.",
            date: Date(),
            mood: .happy
        ))
    }
    .environment(DiaryStore())
}
