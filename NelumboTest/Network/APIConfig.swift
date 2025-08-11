//
//  APIConfig.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

enum APIConfig {

    static let baseURL = URL(string: "https://checkapidev.nelumbo.com.co")!

    enum Path {
        static let signIn = "/api/v1/auth/signin"
        static let reportsList = "/api/v1/report-folio/mobile/filters"
        static func reportDetail(_ id: Int) -> String { "/api/v1/report-folio/\(id)" }
    }
}
