//
//  SwipeAssignmentApp.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 29/01/25.
//

import SwiftUI

@main
struct SwipeAssignmentApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .modelContainer(for: FavouriteProduct.self)
        }
    }
}
