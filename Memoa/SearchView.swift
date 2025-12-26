//
//  SearchView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

struct SearchView: View {
    @Environment(DiaryStore.self) private var store
    @State private var searchText = ""
    
    var filteredEntries: [DiaryEntry] {
        if searchText.isEmpty {
            return store.sortedEntries
        } else {
            return store.sortedEntries.filter { entry in
                entry.title.localizedCaseInsensitiveContains(searchText) ||
                entry.content.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredEntries) { entry in
                    NavigationLink(destination: EntryDetailView(entry: entry)) {
                        EntryRowView(entry: entry)
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchText, prompt: "Search entries...")
            .overlay {
                if filteredEntries.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environment(DiaryStore())
}
