//
//  FavoriteProduct.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 31/01/25.
//

import SwiftData
import Foundation

@Model
final class FavouriteProduct {
    var id: UUID
    var productName: String
    var productType: String
    var price: Double
    var tax: Double
    var imageUrl: String?
    
    init(id: UUID, productName: String, productType: String, price: Double, tax: Double, imageUrl: String?) {
        self.id = id
        self.productName = productName
        self.productType = productType
        self.price = price
        self.tax = tax
        self.imageUrl = imageUrl
    }
}
