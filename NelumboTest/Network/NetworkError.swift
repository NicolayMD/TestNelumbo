//
//  NetworkError.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case invalidURL
    case unauthorized
    case server(status: Int, message: String?)
    case decoding(Error)
    case noData
    case underlying(Error)

    var description: String {
        switch self {
        case .invalidURL: return "URL inválida"
        case .unauthorized: return "No autorizado (401)"
        case .server(let s, let msg): return "Error del servidor (\(s)): \(msg ?? "")"
        case .decoding(let e): return "Error decodificando: \(e.localizedDescription)"
        case .noData: return "Respuesta vacía"
        case .underlying(let e): return "Error de red: \(e.localizedDescription)"
        }
    }
}
