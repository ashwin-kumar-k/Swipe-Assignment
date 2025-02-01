//
//  APIService.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 29/01/25.
//
import Foundation
import UIKit

class APIService {
    let session = URLSession.shared
    let jsonDecoder = JSONDecoder()
    
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
            throw AppAlerts.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        
        let (data, response) = try await session.data(for: request)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API Response: \(jsonString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw AppAlerts.serverError
        }
        
        do {
            let results = try jsonDecoder.decode([Product].self, from: data)
            return results
        } catch {
            print("Decoding error: \(error)")
            throw AppAlerts.invalidData
        }
    }
    
    func addProductToServer(productName: String, productType: String, price: String, tax: String, image: UIImage?) async throws -> String {
        guard let url = URL(string: "https://app.getswipe.in/api/public/add") else {
            throw AppAlerts.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        
        func append(_ key: String, _ value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        ["product_name": productName, "product_type": productType, "price": price, "tax": tax].forEach { append($0.key, $0.value) }
        
        if let image = image, let imageData = image.jpegData(compressionQuality: 0.8) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"files[]\"; filename=\"product.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        let (data, _) = try await session.data(for: request)
        
        let decodedResponse = try JSONDecoder().decode(ProductResponse.self, from: data)
        guard decodedResponse.success else {
            throw AppAlerts.failure(decodedResponse.message)
        }
        
        return decodedResponse.message
    }
}
