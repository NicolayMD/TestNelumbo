//
//  CommentStore.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import Foundation

struct LocalComment: Codable {
    let id: Int
    let message: String
    let createTime: String
    let firstName: String
    let lastName: String
}

final class CommentStore {
    static let shared = CommentStore()
    private let defaults = UserDefaults.standard
    private init() {}

    private func keyLocal(for reportId: Int) -> String { "comments_local_\(reportId)" }

    func loadLocal(reportId: Int) -> [LocalComment] {
        let k = keyLocal(for: reportId)
        if let data = defaults.data(forKey: k),
           let decoded = try? JSONDecoder().decode([LocalComment].self, from: data) {
            return decoded
        }
        return []
    }

    func saveLocal(reportId: Int, comments: [LocalComment]) {
        let k = keyLocal(for: reportId)
        if let data = try? JSONEncoder().encode(comments) {
            defaults.set(data, forKey: k)
        }
    }

    func appendLocal(reportId: Int, message: String, authorFirst: String = "Tú", authorLast: String = "") -> LocalComment {
        var current = loadLocal(reportId: reportId)
        let iso = ISO8601DateFormatter()
        let new = LocalComment(
            id: -Int.random(in: 100000...999999),
            message: message,
            createTime: iso.string(from: Date()),
            firstName: authorFirst,
            lastName: authorLast
        )
        current.append(new)
        saveLocal(reportId: reportId, comments: current)
        return new
    }

    func seedIfEmpty(reportId: Int) {
        let hasLocal = !loadLocal(reportId: reportId).isEmpty
        if hasLocal { return }
        let iso = ISO8601DateFormatter()
        let now = Date()
        let seed: [LocalComment] = [
            LocalComment(id: -1, message: "Mensaje de prueba y descriptivo sobre la solicitud de mantenimiento", createTime: iso.string(from: now.addingTimeInterval(-3600*24)), firstName: "Luis Alberto", lastName: "García"),

        ]
        saveLocal(reportId: reportId, comments: seed)
    }
}
