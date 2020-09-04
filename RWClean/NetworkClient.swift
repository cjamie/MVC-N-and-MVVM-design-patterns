import Foundation

protocol ProductLoader {
    func getProducts(for type: Product.ProductType, completion: @escaping ((Result<[Product], Error>) -> Void))
}

public final class NetworkClient {
    // MARK: - Instance Properties

    internal let baseURL: URL
    internal let session = URLSession.shared

    // MARK: - Class Constructors

    public static let shared: NetworkClient = {
        let file = Bundle.main.path(forResource: "ServerEnvironments", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        let urlString = dictionary["service_url"] as! String
        let url = URL(string: urlString)!
        return NetworkClient(baseURL: url)
    }()

    // MARK: - Object Lifecycle

    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
}

// MARK: - ProductLoader

extension NetworkClient: ProductLoader {
    func getProducts(for type: Product.ProductType, completion: @escaping ((Result<[Product], Error>) -> Void)) {
        let finalURL = baseURL.appendingPathComponent("/products/\(type.rawValue)")

        session.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                completion(.failure(NetworkError(error: error)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            do {
                guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                    Self.dispatch { completion(.failure(NetworkError.jsonDecoding)) }
                    return
                }
                let products = Product.array(jsonArray: jsonObject)
                Self.dispatch { completion(.success(products)) }

            } catch {
                Self.dispatch { completion(.failure(NetworkError(error: error))) }
                return
            }

        }.resume()
    }

    private static func dispatch(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
}
