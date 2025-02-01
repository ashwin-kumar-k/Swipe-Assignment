//
//  AsyncCachedImage.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 29/01/25.
//
import SwiftUI

struct AsyncCachedImage<ImageView: View, PlaceholderView: View>: View {
    var url: URL?
    @ViewBuilder var content: (Image) -> ImageView
    @ViewBuilder var placeholder: () -> PlaceholderView
    
    @State private var image: UIImage? = nil
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> ImageView,
        @ViewBuilder placeholder: @escaping () -> PlaceholderView
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        VStack {
            if let uiImage = image {
                content(Image(uiImage: uiImage))
            } else if url == nil {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            } else {
                placeholder()
                    .onAppear {
                        Task {
                            image = await downloadPhoto()
                        }
                }
            }
        }
        .onChange(of: url) { newURL in
            image = nil
            Task {
                image = await downloadPhoto()
            }
        }
    }
    
    private func downloadPhoto() async -> UIImage? {
        do {
            guard let url else { return nil }
            
            // Add memory cache for better performance
            if let cachedImage = ImageCache.shared.get(key: url.absoluteString) {
                return cachedImage
            }
            
            if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)),
               let image = UIImage(data: cachedResponse.data) {
                // Store in memory cache
                ImageCache.shared.set(image, key: url.absoluteString)
                return image
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let image = UIImage(data: data) else {
                print("Failed to convert data to UIImage")
                return nil
            }
            
            // Store in both caches
            let cachedData = CachedURLResponse(response: response, data: data)
            URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: url))
            ImageCache.shared.set(image, key: url.absoluteString)
            
            return image
            
        } catch {
            print("Error downloading: \(error)")
            return nil
        }
    }
}

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100 // Adjust based on your needs
    }
    
    func set(_ image: UIImage, key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func remove(key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
