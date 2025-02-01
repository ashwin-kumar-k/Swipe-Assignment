//
//  Product.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 29/01/25.
//

import Foundation

struct Product: Identifiable, Codable {
    var id = UUID()
    let image: String?
    let price: Double
    let product_name: String
    let product_type: String
    let tax: Double
    
    enum CodingKeys: String, CodingKey {
        case image
        case price
        case product_name
        case product_type
        case tax
    }
}

struct ProductResponse: Codable {
    let message: String
    let product_details: Product?
    let product_id: Int?
    let success: Bool
}
