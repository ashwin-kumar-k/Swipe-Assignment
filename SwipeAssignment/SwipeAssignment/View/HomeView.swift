//
//  HomeView.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 29/01/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var networkMonitor = NetworkMonitor.shared
    @StateObject private var vm = HomeViewModel()
    @State private var searchText = ""
    
    private var filteredProducts: [Product] {
        vm.products.filter { product in
            searchText.isEmpty ||
            product.product_name.lowercased().contains(searchText.lowercased()) ||
            product.product_type.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if networkMonitor.isReachable {
                    if vm.isLoading {
                        ProgressView("Loading Products...")
                            .padding()
                    } else {
                        
                        if filteredProducts.isEmpty {
                            ContentUnavailableView(
                                "No Products Found",
                                systemImage: "magnifyingglass",
                                description: Text("No products match your search. Try different keywords.")
                            )
                        } else {
                            List(filteredProducts) { product in
                                ProductRowView(product: product)
                                    .listRowSeparator(.hidden)
                            }
                            .listStyle(PlainListStyle())
                            .refreshable {
                                vm.fetchProduct()
                            }
                        }
                    }
                } else {
                    ContentUnavailableView(
                        "No Internet Connection",
                        systemImage: "wifi.slash",
                        description: Text("Check your connection and try again.")
                    )
                }
            }
            .navigationTitle("Products")
            .alert(isPresented: $vm.hasError, content: {
                Alert(title: Text("Error!"), message: Text(vm.error?.localizedDescription ?? ""))
            })
            .onChange(of: networkMonitor.isReachable) { isReachable in
                if isReachable {
                    vm.fetchProduct()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        vm.fetchProduct()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .searchable(text: $searchText, prompt: Text("Search Products"))
        }
        .networkStatusBanner()
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
