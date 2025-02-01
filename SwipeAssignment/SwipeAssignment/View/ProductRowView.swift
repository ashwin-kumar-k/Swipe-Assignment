//
//  ProductCard.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 30/01/25.
//

import SwiftUI
import SwiftData

struct ProductRowView: View {
    let product: Product
    @Environment(\.modelContext) private var modelContext
    @Query private var favourites: [FavouriteProduct]
    
    var isFavourite: Bool {
        favourites.contains { $0.id == product.id }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageUrl = product.image, let url = URL(string: imageUrl) {
                AsyncCachedImage(url: url) { image in
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
            } else {
                PlaceholderImage()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(product.product_name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button {
                        toggleFavourite()
                    } label: {
                        Image(systemName: isFavourite ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(isFavourite ? .red : .gray)
                            .frame(width: 18)
                    }
                    .buttonStyle(.plain)
                }
                
                Text(product.product_type)
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
    
    private func toggleFavourite() {
        if isFavourite {
            if let favourite = favourites.first(where: { $0.id == product.id }) {
                modelContext.delete(favourite)
            }
        } else {
            let favourite = FavouriteProduct(
                id: product.id,
                productName: product.product_name,
                productType: product.product_type,
                price: product.price,
                tax: product.tax,
                imageUrl: product.image
            )
            modelContext.insert(favourite)
        }
        
        try? modelContext.save()
    }
}

struct PlaceholderImage: View {
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            )
    }
}


