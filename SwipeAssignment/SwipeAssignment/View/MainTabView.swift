//
//  MainTabView.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 30/01/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Products", systemImage: "list.bullet")
                }
            
            AddProductView()
                .tabItem {
                    Label("Add Product", systemImage: "plus.circle")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
        .accentColor(.blue)
    }
}
