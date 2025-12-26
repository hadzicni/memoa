//
//  SettingsView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

enum AppearanceMode: String, CaseIterable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct SettingsView: View {
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system
    @Environment(DiaryStore.self) private var store
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $appearanceMode) {
                        ForEach(AppearanceMode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Statistics") {
                    HStack {
                        Text("Total Entries")
                        Spacer()
                        Text("\(store.entries.count)")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Most Common Mood")
                        Spacer()
                        if let mood = mostCommonMood {
                            HStack(spacing: 4) {
                                Text(mood.rawValue)
                                Text(mood.name)
                                    .foregroundStyle(.secondary)
                            }
                        } else {
                            Text("—")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Data") {
                    Button("Export Entries", systemImage: "square.and.arrow.up") {
                        // Future: Export functionality
                    }
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
    
    private var mostCommonMood: DiaryEntry.Mood? {
        guard !store.entries.isEmpty else { return nil }
        
        let moodCounts = Dictionary(grouping: store.entries, by: { $0.mood })
            .mapValues { $0.count }
        
        return moodCounts.max(by: { $0.value < $1.value })?.key
    }
}

#Preview {
    SettingsView()
        .environment(DiaryStore())
}
