//
//  DiaryStore.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import Foundation

@Observable
class DiaryStore {
    var entries: [DiaryEntry] = [] {
        didSet {
            save()
        }
    }

    private let saveKey = "DiaryEntries"

    init() {
        load()
    }

    func addEntry(_ entry: DiaryEntry) {
        entries.append(entry)
    }

    func updateEntry(_ entry: DiaryEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        }
    }

    func deleteEntry(_ entry: DiaryEntry) {
        entries.removeAll { $0.id == entry.id }
    }

    var sortedEntries: [DiaryEntry] {
        entries.sorted { $0.date > $1.date }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([DiaryEntry].self, from: data) {
            entries = decoded
        }
    }
}
