//
//  TokenStorage.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

final class TokenStorage {
    static let shared = TokenStorage()
    private init() {}
    private let tokenKey = "auth.token"

    var token: String? {
        get { UserDefaults.standard.string(forKey: tokenKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: tokenKey) }
    }
    func clear() { UserDefaults.standard.removeObject(forKey: tokenKey) }
}
