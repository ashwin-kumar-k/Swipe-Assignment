# Swipe iOS Assignment

A SwiftUI-based iOS application for product management with offline support and favorites functionality.

## 📱 Features

- **Product Listing**
  - Search functionality
  - Real-time product filtering
  - Pull-to-refresh updates
  - Loading state indicators with shimmer effect
  - Cached image loading with placeholders

- **Add Products**
  - Product type selection (Product/Service)
  - Form validation
  - Image picker with 1:1 aspect ratio
  - Offline support with background sync
  - Real-time network status monitoring

- **Favorites Management**
  - Local persistence using SwiftData
  - Add/Remove favorites with heart icon
  - Dedicated favorites tab

## 🛠 Technical Stack

- **Framework**: SwiftUI
- **Architecture**: MVVM
- **iOS Deployment Target**: iOS 17.0+
- **Swift Version**: 5.9
- **Data Persistence**: 
  - SwiftData (Favorites)
  - UserDefaults (Offline products)
  - NSCache (Image caching)
- **Networking**: URLSession with async/await
- **Image Picker**: PhotosUI

## 📋 Requirements

- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

## 🚀 Installation

1. Clone the repository
2. Open the project in Xcode
3. Select your development team in the project settings
4. Build and run the project (⌘ + R)

## 📐 Architecture

The project follows the MVVM (Model-View-ViewModel) architecture pattern:

### Models
- `Product`: Core data model for products
- `FavouriteProduct`: SwiftData model for favorites
- `AppAlerts`: Comprehensive error handling system

### Views
- `MainTabView`: Main tab-based navigation
- `HomeView`: Product listing screen
- `AddProductView`: Product creation form
- `FavoritesView`: Saved favorites display
- `ProductRowView`: Reusable product card component

### ViewModels
- `HomeViewModel`: Manages product listing and fetching
- `AddProductViewModel`: Handles product creation and offline sync


## 💾 Offline Support

The app implements a robust offline support system:

1. **Network Monitoring**
   - Real-time connection status tracking
   - Visual indicators for network state

2. **Local Storage**
   - Products created offline are saved locally
   - Automatic background sync when connection is restored
   - Queue-based sync system to maintain data integrity

3. **Data Persistence**
   - Favorites are stored using SwiftData
   - Offline products are stored in UserDefaults
   - Image caching using NSCache

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## 🙋‍♂️ Author

Ashwin Kumar K (ashwink.career@gmail.com)
