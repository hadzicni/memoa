//
//  EntriesListView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

struct EntriesListView: View {
    @Environment(DiaryStore.self) private var store
    @State private var showingAddEntry = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.sortedEntries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        EntryRowView(entry: entry)
                    }
                }
                .onDelete(perform: deleteEntries)
            }
            .navigationTitle("My Diary")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEntry = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEntry) {
                AddEntryView()
            }
            .overlay {
                if store.entries.isEmpty {
                    ContentUnavailableView(
                        "No Entries Yet",
                        systemImage: "book.closed",
                        description: Text("Start your journaling journey by adding your first entry")
                    )
                }
            }
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            let entry = store.sortedEntries[index]
            store.deleteEntry(entry)
        }
    }
}

struct EntryRowView: View {
    let entry: DiaryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.title)
                    .font(.headline)
                Spacer()
                HStack(spacing: 8) {
                    if entry.photoData?.isEmpty == false {
                        Image(systemName: "photo.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    if entry.audioData != nil {
                        Image(systemName: "mic.fill")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Text(entry.mood.rawValue)
                        .font(.title3)
                }
            }

            Text(entry.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EntriesListView()
        .environment(DiaryStore())
}
