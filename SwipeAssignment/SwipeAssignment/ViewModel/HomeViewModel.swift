//
//  HomeViewModel.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 29/01/25.
//

import Foundation
import Observation

@MainActor
class HomeViewModel: ObservableObject {
    private var api = APIService()
    
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var hasError = false
    @Published var error: Error?
    
    init() {
        fetchProduct()
    }
    
    func fetchProduct() {
        isLoading = true
        Task {
            do {
                let fetchedProducts = try await api.fetchProducts()
                DispatchQueue.main.async {
                    self.products = fetchedProducts
                }
            } catch {
                DispatchQueue.main.async {
                    self.hasError = true
                    self.error = error
                }
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}
