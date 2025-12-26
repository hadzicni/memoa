//
//  TabView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("appearanceMode") private var appearanceMode: AppearanceMode = .system

    var body: some View {
        SwiftUI.TabView {
            SwiftUI.Tab("Entries", systemImage: "book.fill") {
                EntriesListView()
            }

            SwiftUI.Tab("Calendar", systemImage: "calendar") {
                CalendarView()
            }

            SwiftUI.Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
            }

            SwiftUI.Tab("Settings", systemImage: "gearshape.fill") {
                SettingsView()
            }
        }
        .preferredColorScheme(appearanceMode.colorScheme)
    }
}
