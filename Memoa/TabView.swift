//
//  TabView.swift
//  Memoa
//
//  Created by Nikola Hadzic on 26.12.2025.
//

import SwiftUI

struct TabView: View {
    @State private var searchText = ""

    var body: some View {
        SwiftUI.TabView {

            SwiftUI.Tab("Summary", systemImage: "heart") {
                NavigationStack {
                    Text("Summary")
                        .navigationTitle("Summary")
                }
            }

            SwiftUI.Tab("Sharing", systemImage: "person.2.fill") {
                NavigationStack {
                    Text("Sharing")
                        .navigationTitle("Sharing")
                }
            }

            SwiftUI.Tab("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    Text("Search")
                        .navigationTitle("Search")
                        .searchable(text: $searchText)
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .tabViewBottomAccessory {
            Text("Bottom Accessory")
        }
    }
}
