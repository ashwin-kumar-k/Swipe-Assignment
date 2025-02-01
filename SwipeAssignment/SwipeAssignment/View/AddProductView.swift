//
//  AddProductView.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 30/01/25.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    @State var viewModel = AddProductViewModel()
    @State var alertManager = AlertManager.shared
    @State var networkMonitor = NetworkMonitor.shared
    @FocusState private var focusedField: FocusedField?
    
    enum FocusedField {
        case productName, price, tax
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Product Type")) {
                    Picker("Select Product Type", selection: $viewModel.productType) {
                        ForEach(AddProductViewModel.ProductType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                Section(header: Text("Product Details")) {
                    TextField("Product Name", text: $viewModel.productName)
                        .focused($focusedField, equals: .productName)
                    
                    TextField("Price", text: $viewModel.price)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .price)
                    
                    TextField("Tax", text: $viewModel.tax)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .tax)
                }
                
                Section(header: Text("Product Image (Optional)")) {
                    Button(action: { viewModel.showImagePicker = true }) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                            Text(viewModel.selectedImage == nil ? "Select Image" : "Image Selected")
                        }
                    }
                    
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .navigationTitle("Add Product")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: {
                        viewModel.addProduct()
                        hideKeyboard()
                    })
                    .disabled(!viewModel.isFormValid)
                }
            }
            .alert(isPresented: $alertManager.showAlert) {
                Alert(title: Text(alertManager.alert?.alertTitle ?? "Oops!"), message: Text(alertManager.alert?.alertDescription ?? "Unknown Error"), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $viewModel.showImagePicker) {
                ImagePicker(selectedImage: $viewModel.selectedImage)
            }
        }
        .networkStatusBanner()
    }
    
    private func hideKeyboard() {
        focusedField = nil
    }
}

#Preview {
    AddProductView()
}
