//
//  ReportsCache.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

struct CachedReportDTOs: Codable {
    let savedAt: Date
    let items: [ReportDTO]
}

final class ReportsCache {
    static let shared = ReportsCache()
    private init() {}

    private let keyDTO = "cachedReports.dto.v1"

    func saveDTOs(_ dtos: [ReportDTO]) {
        let payload = CachedReportDTOs(savedAt: Date(), items: dtos)
        if let data = try? JSONEncoder().encode(payload) {
            UserDefaults.standard.set(data, forKey: keyDTO)
        }
    }

    func loadDTOs() -> CachedReportDTOs? {
        guard let data = UserDefaults.standard.data(forKey: keyDTO) else { return nil }
        return try? JSONDecoder().decode(CachedReportDTOs.self, from: data)
    }

    func clearDTOs() {
        UserDefaults.standard.removeObject(forKey: keyDTO)
    }
}
