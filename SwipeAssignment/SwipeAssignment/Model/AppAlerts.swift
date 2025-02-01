//
//  Error.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 29/01/25.
//

import Foundation

enum AppAlerts: Error, LocalizedError {
    case invalidData
    case invalidURL
    case serverError
    case noData
    case invalidName
    case invalidPrice
    case invalidTax
    case invalidResponse
    case success
    case failure(String)
    case connected
    case disconnected
    case savedLocally
    case syncedWithServer
    case notSyncedWithServer(String, String)
    case error(String)
    
    var alertTitle: String? {
        switch self {
            case .invalidData, .invalidURL, .serverError, .noData, .invalidResponse:
                return "Oops!"
            case .invalidName, .invalidPrice, .invalidTax:
                return "Validation Error"
            case .success:
                return "Success!"
            case .connected:
                return "Back Online!"
            case .disconnected:
                return "No Internet Connection"
            case .savedLocally:
                return "Saved"
            case .syncedWithServer:
                return "Synced"
            case .notSyncedWithServer(_,_):
                return "Failed"
            case .error(_):
                return "Error"
            case .failure(_):
                return "Failed"
        }
    }
    
    var alertDescription: String? {
        switch self {
            case .invalidData:
                return "The data received from the server is invalid."
            case .invalidURL:
                return "The URL is invalid or may be broken. Please check and try again."
            case .serverError:
                return "There was an issue connecting to the server. Please try again later."
            case .invalidName:
                return "Product name cannot be empty."
            case .invalidPrice:
                return "Price must be a valid number."
            case .invalidTax:
                return "Tax must be a valid number."
            case .noData:
                return "No data was returned from the server."
            case .invalidResponse:
                return "The server returned an invalid response."
            case .success:
                return "Product added successfully!"
            case .connected:
                return "You are connected to the Internet."
            case .disconnected:
                return "You have lost internet access. Please check your connection."
            case .savedLocally:
                return "Product saved locally. It will be uploaded when online."
            case .syncedWithServer:
                return "Product Data synced with the server. Swipe down to Refresh"
            case .notSyncedWithServer(let productName, let message):
                return "'\(productName)' couldn't be synced due to: \(message)."
            case .error(let errorDescription):
                return "An error occurred: \(errorDescription)"
            case .failure(let errorDescription):
                return "Product could not be added: \(errorDescription)"
        }
    }
}
