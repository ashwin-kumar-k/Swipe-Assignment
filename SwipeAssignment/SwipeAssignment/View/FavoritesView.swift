//
//  FavoritesView.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 30/01/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favourites: [FavouriteProduct]
    var body: some View {
        NavigationStack {
            VStack {
                if favourites.isEmpty {
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "heart.slash",
                        description: Text("You haven't saved any favorite products yet.")
                    )
                } else {
                    List {
                        ForEach(favourites) { product in
                            HStack {
                                if let imageUrl = product.imageUrl,let _ = URL(string: imageUrl) {
                                    AsyncCachedImage(url: URL(string: imageUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    } placeholder: {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(width: 80, height: 80)
                                            .shimmer(when: .constant(true))
                                    }
                                }
                                else {
                                    PlaceholderImage()
                                }
                                
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(product.productName)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                    
                                    Text(product.productType)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    HStack {
                                        Text("₹\(String(format: "%.2f", product.price))")
                                            .font(.headline)
                                            .foregroundColor(.green)
                                        
                                        Spacer()
                                        
                                        Text("Tax: \(String(format: "%.1f", product.tax))%")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteFavourite)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }
    
    private func deleteFavourite(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(favourites[index])
        }
    }
}

#Preview {
    FavoritesView()
}
