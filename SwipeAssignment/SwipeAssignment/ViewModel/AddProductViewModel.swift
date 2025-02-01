//
//  AddProductViewModel.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 30/01/25.
//

import SwiftUI
import PhotosUI

@Observable
class AddProductViewModel {
    
    var productType: ProductType = .product
    var productName: String = ""
    var price: String = ""
    var tax: String = ""
    var selectedImage: UIImage?
    var showImagePicker = false
    let networkMonitor = NetworkMonitor.shared
    let alertManager = AlertManager.shared
    let apiService = APIService()
    
    enum ProductType: String, CaseIterable {
        case product = "Product"
        case service = "Service"
    }
    
    struct LocalProduct: Codable {
        let productName: String
        let productType: String
        let price: String
        let tax: String
        let imageData: Data?
    }
    
    init() {
        Task { @MainActor in
            while true {
                if networkMonitor.isReachable {
                    syncOfflineProducts()
                }
                try? await Task.sleep(nanoseconds: 5_000_000_000)
            }
        }
    }
    
    var isFormValid: Bool {
        !productName.isEmpty &&
        Double(price) != nil &&
        Double(tax) != nil
    }
    
    func addProduct() {
        if networkMonitor.isReachable {
            Task {
                do {
                    let message = try await apiService.addProductToServer(
                        productName: productName,
                        productType: productType.rawValue,
                        price: price,
                        tax: tax,
                        image: selectedImage
                    )
                    await MainActor.run {
                        print("Product added successfully: \(message)")
                        alertManager.alert = .success
                        alertManager.showAlert = true
                        clearForm()
                    }
                } catch {
                    await MainActor.run {
                        print("Error adding product: \(error)")
                        alertManager.alert = error.self as? AppAlerts
                        alertManager.showAlert = true
                    }
                }
            }
        } else {
            saveProductLocally()
        }
    }
    
    func saveProductLocally() {
        let localProduct = LocalProduct(
            productName: productName,
            productType: productType.rawValue,
            price: price,
            tax: tax,
            imageData: selectedImage?.jpegData(compressionQuality: 0.8)
        )
        
        var savedProducts = getSavedProducts()
        savedProducts.append(localProduct)
        
        if let encodedData = try? JSONEncoder().encode(savedProducts) {
            UserDefaults.standard.set(encodedData, forKey: "offline_products")
            print("Product saved locally")
        }
        
        alertManager.alert = .savedLocally
        alertManager.showAlert = true
        clearForm()
    }
    
    func syncOfflineProducts() {
        var products = getSavedProducts()
        
        guard !products.isEmpty else { return }
        
        print("Syncing offline products...")
        
        Task {
            for product in products {
                let image = product.imageData.flatMap { UIImage(data: $0) }
                
                do {
                    let _ = try await apiService.addProductToServer(
                        productName: product.productName,
                        productType: product.productType,
                        price: product.price,
                        tax: product.tax,
                        image: image
                    )
                    
                    await MainActor.run {
                        self.alertManager.alert = .syncedWithServer
                        self.alertManager.showAlert = true
                        print("Synced: \(product.productName)")
                    }
                    
                } catch let error as AppAlerts {
                    switch error {
                        case .failure(let errorMessage):
                            await MainActor.run {
                                self.alertManager.alert = .notSyncedWithServer(product.productName, errorMessage)
                                self.alertManager.showAlert = true
                                print("Failed to sync \(product.productName): \(errorMessage)")
                            }
                        default:
                            await MainActor.run {
                                self.alertManager.alert = .notSyncedWithServer(product.productName, "Unknown error")
                                self.alertManager.showAlert = true
                                print("Failed to sync \(product.productName): \(error)")
                            }
                    }
                }
                
                products.removeAll { $0.productName == product.productName }
                await MainActor.run {
                    if let updatedData = try? JSONEncoder().encode(products) {
                        UserDefaults.standard.set(updatedData, forKey: "offline_products")
                    }
                }
            }
        }
    }
    
    private func getSavedProducts() -> [LocalProduct] {
        if let savedData = UserDefaults.standard.data(forKey: "offline_products"),
           let decodedProducts = try? JSONDecoder().decode([LocalProduct].self, from: savedData) {
            return decodedProducts
        }
        return []
    }
    
    
    private func clearForm() {
        productType = .product
        productName = ""
        price = ""
        tax = ""
        selectedImage = nil
    }
}
