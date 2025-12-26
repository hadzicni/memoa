//
//  MemoaApp.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

@main
struct MemoaApp: App {
    @State private var diaryStore = DiaryStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(diaryStore)
        }
    }
}
