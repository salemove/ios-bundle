import Kingfisher

/// A wrapper for Kingfisher's cache. As we aren't using Kingfisher's default functionality (loading the image URL directly and setting
/// the cache's key as the absoluteURL), then we manually cache and retrieve the files by using its ID.
final class Cache {
    /// Gets an image from the cache using the specified ID.
    /// - Parameters:
    ///   - id: The UUID of the image.
    ///   - completion: If an image with the specified ID is present in the cache, then `completion` gets called with the image.
    ///   Otherwise, it gets called with `nil`.
    static func image(using id: String, completion: @escaping (UIImage?) -> Void) {
        ImageCache.default.retrieveImage(forKey: id) { result in
            switch result {
            case .success(let value):
                if value.cacheType == .none {
                    completion(nil)
                } else {
                    completion(value.image)
                }
            case .failure:
                completion(nil)
            }
        }
    }

    /// Saves the image to the cache.
    /// - Parameters:
    ///   - image: The image generated from the data.
    ///   - original: The data of the image. Used by Kingfisher to save the image with the correct file format.
    ///   - key: The key under which the image should be cached.
    static func save(_ image: UIImage, original: Data?, usingKey key: String) {
        ImageCache.default.store(image, original: original, forKey: key)
    }
}
