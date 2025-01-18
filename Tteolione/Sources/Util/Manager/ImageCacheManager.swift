//
//  ImageCacheManager.swift
//  Tteolione
//
//  Created by 전준영 on 1/18/25.
//

import UIKit

final class ImageCacheManager {
    
    static let shared = ImageCacheManager()
    private init() {}
    
    private let nsCache = NSCache<NSString, NSData>()
    private let urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                    diskCapacity: 100 * 1024 * 1024,
                                    diskPath: "imageCache")
    
    private lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = urlCache
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()
    
    func loadImage(from url: URL) async -> UIImage? {
        let cacheKey = NSString(string: url.absoluteString)
        
        if let cachedData = nsCache.object(forKey: cacheKey),
           let image = UIImage(data: cachedData as Data) {
            return image
        }
        
        let request = URLRequest(url: url)
        if let cachedResponse = urlCache.cachedResponse(for: request),
           let cachedImage = UIImage(data: cachedResponse.data) {
            nsCache.setObject(NSData(data: cachedResponse.data), forKey: cacheKey)
            return cachedImage
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200..<300) ~= statusCode else {
                print("Image download failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
                return nil
            }
            
            let cachedResponse = CachedURLResponse(response: response, data: data)
            urlCache.storeCachedResponse(cachedResponse, for: request)
            nsCache.setObject(NSData(data: data), forKey: cacheKey)
            
            return UIImage(data: data)
        } catch {
            print("Failed to download image: \(error)")
            return nil
        }
    }
}
