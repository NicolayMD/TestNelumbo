//
//  AuthService.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

final class AuthService {
    static let shared = AuthService()
    private init() {}

    private let demoUsername = "rafael@gmail.com"
    private let demoPassword = "1Aasdfgh"

    func signIn(completion: @escaping (Result<String, NetworkError>) -> Void) {
        let body = SignInRequest(username: demoUsername, password: demoPassword)
        HTTPClient.shared.post(path: APIConfig.Path.signIn, body: body) { (result: Result<SignInResponse, NetworkError>) in
            switch result {
            case .success(let resp):
                let token = resp.token ?? resp.accessToken
                if let t = token, !t.isEmpty {
                    TokenStorage.shared.token = t
                    completion(.success(t))
                } else {
                    completion(.failure(.server(status: 200, message: "Token no recibido")))
                }
            case .failure(let e):
                completion(.failure(e))
            }
        }
    }
}
