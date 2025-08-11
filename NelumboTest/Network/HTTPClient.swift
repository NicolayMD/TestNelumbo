//
//  HTTPClient.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

final class HTTPClient {
    static let shared = HTTPClient()
    private init() {}

    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        return URLSession(configuration: config)
    }()

    private let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .useDefaultKeys
        d.dateDecodingStrategy = .iso8601
        return d
    }()


    func get<T: Decodable>(
        path: String,
        query: [URLQueryItem]? = nil,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        request(method: "GET", path: path, query: query, body: Optional<Data>.none, completion: completion)
    }

    func post<T: Decodable, B: Encodable>(
        path: String,
        body: B,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        do {
            let data = try JSONEncoder().encode(body)
            request(method: "POST", path: path, query: nil, body: data, completion: completion)
        } catch {
            completion(.failure(.underlying(error)))
        }
    }


    private func request<T: Decodable>(
        method: String,
        path: String,
        query: [URLQueryItem]?,
        body: Data?,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        var components = URLComponents(url: APIConfig.baseURL, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = query
        guard let url = components?.url else { completion(.failure(.invalidURL)); return }

        var req = URLRequest(url: url)
        req.httpMethod = method
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = TokenStorage.shared.token {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        req.httpBody = body

        let task = session.dataTask(with: req) { [weak self] data, resp, err in
            if let err = err { completion(.failure(.underlying(err))); return }
            guard let http = resp as? HTTPURLResponse else { completion(.failure(.noData)); return }

            if http.statusCode == 401 { completion(.failure(.unauthorized)); return }
            guard (200...299).contains(http.statusCode) else {
                let msg = data.flatMap { String(data: $0, encoding: .utf8) }
                completion(.failure(.server(status: http.statusCode, message: msg)))
                return
            }

            guard let data = data else { completion(.failure(.noData)); return }
            do {
                guard let self else { return }
                let decoded = try self.jsonDecoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }
        task.resume()
    }
    
    func getRaw(path: String,
                query: [URLQueryItem]? = nil,
                completion: @escaping (Result<String, NetworkError>) -> Void) {
        var components = URLComponents(url: APIConfig.baseURL, resolvingAgainstBaseURL: false)
        components?.path = path
        components?.queryItems = query
        guard let url = components?.url else { completion(.failure(.invalidURL)); return }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = TokenStorage.shared.token {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let task = session.dataTask(with: req) { data, resp, err in
            if let err = err { completion(.failure(.underlying(err))); return }
            guard let http = resp as? HTTPURLResponse else { completion(.failure(.noData)); return }
            if http.statusCode == 401 { completion(.failure(.unauthorized)); return }
            guard let data = data else { completion(.failure(.noData)); return }
            let text = String(data: data, encoding: .utf8) ?? "<binario>"
            if (200...299).contains(http.statusCode) {
                completion(.success(text))
            } else {
                completion(.failure(.server(status: http.statusCode, message: text)))
            }
        }
        task.resume()
    }

}
