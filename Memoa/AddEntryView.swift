//
//  AddEntryView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI
import PhotosUI

struct AddEntryView: View {
    @Environment(DiaryStore.self) private var store
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var content = ""
    @State private var selectedMood: DiaryEntry.Mood = .neutral
    @State private var date = Date()
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoData: [Data] = []
    @State private var audioRecorder = AudioRecorder()
    @State private var showingAudioRecorder = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Entry Details") {
                    TextField("Title", text: $title)

                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }

                Section("Mood") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(DiaryEntry.Mood.allCases, id: \.self) { mood in
                            Button(action: {
                                selectedMood = mood
                            }) {
                                VStack(spacing: 4) {
                                    Text(mood.rawValue)
                                        .font(.system(size: 32))
                                    Text(mood.name)
                                        .font(.caption)
                                        .foregroundStyle(.primary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedMood == mood ? Color.accentColor.opacity(0.2) : Color(.systemGray6))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedMood == mood ? Color.accentColor : Color.clear, lineWidth: 2)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Your Thoughts") {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }

                Section("Attachments") {
                    PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 5, matching: .images) {
                        Label("Add Photos", systemImage: "photo.on.rectangle")
                    }
                    .onChange(of: selectedPhotos) { _, newValue in
                        Task {
                            photoData.removeAll()
                            for item in newValue {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    photoData.append(data)
                                }
                            }
                        }
                    }

                    if !photoData.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(photoData.enumerated()), id: \.offset) { index, data in
                                    if let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .overlay(alignment: .topTrailing) {
                                                Button {
                                                    photoData.remove(at: index)
                                                    selectedPhotos.remove(at: index)
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundStyle(.white)
                                                        .background(Circle().fill(.black.opacity(0.6)))
                                                }
                                                .padding(4)
                                            }
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }

                    Button {
                        showingAudioRecorder = true
                    } label: {
                        HStack {
                            Label("Add Audio", systemImage: "mic.fill")
                            if audioRecorder.audioData != nil {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
            .sheet(isPresented: $showingAudioRecorder) {
                AudioRecorderView(audioRecorder: audioRecorder)
            }
        }
    }

    private func saveEntry() {
        let entry = DiaryEntry(
            title: title,
            content: content,
            date: date,
            mood: selectedMood,
            photoData: photoData.isEmpty ? nil : photoData,
            audioData: audioRecorder.audioData,
            audioDuration: audioRecorder.audioData != nil ? audioRecorder.recordingTime : nil
        )
        store.addEntry(entry)
        dismiss()
    }
}

#Preview {
    AddEntryView()
        .environment(DiaryStore())
}
