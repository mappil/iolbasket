//
//  AvatarView.swift
//  IOL App Basket
//
//  Created by massimiliano allegretti on 23/06/25.
//

import SwiftUI
import Foundation

struct AvatarView: View {
    let name: String
    @StateObject private var loader = ImageLoader()

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .clipShape(Circle())
        .onAppear {
            let urlString = "https://github.com/mappil/iolbasket/blob/main/avatars/\(name.lowercased()).jpg?raw=true"
            loader.load(from: urlString)
        }
    }
}

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let cache = URLCache(memoryCapacity: 50 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024)
    private let cacheLifetime: TimeInterval = 600 // 10 minuti

    func load(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad

        // Check manual cache (with TTL logic)
        if let cachedResponse = cache.cachedResponse(for: request) {
            let age = Date().timeIntervalSince(cachedResponse.timestamp)
            if age < cacheLifetime, let image = UIImage(data: cachedResponse.data) {
                self.image = image
                return
            }
        }

        // Fetch from network
        URLSession.shared.dataTask(with: request) { data, response, _ in
            guard let data = data,
                  let response = response,
                  let image = UIImage(data: data) else { return }

            // Save to custom cache
            let cachedResponse = CachedURLResponse(response: response, data: data)
            self.cache.storeCachedResponse(cachedResponse, for: request)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}

// Extension to attach timestamp to CachedURLResponse
private extension CachedURLResponse {
    var timestamp: Date {
        if let date = (self.userInfo?["timestamp"] as? Date) {
            return date
        } else {
            return Date.distantPast
        }
    }
}
