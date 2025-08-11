//
//  ReportsService.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

final class ReportsService {
    static let shared = ReportsService()
    private init() {}

    func fetchListDTO(limit: Int = 20,
                      order: String = "DESC",
                      completion: @escaping (Result<[ReportDTO], NetworkError>) -> Void) {
        let query = [
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "order", value: order)
        ]
        HTTPClient.shared.get(path: APIConfig.Path.reportsList, query: query, completion: completion)
    }

    func fetchListDTOWithCache(limit: Int = 20,
                               order: String = "DESC",
                               completion: @escaping (Result<[ReportDTO], NetworkError>) -> Void)
    {
        if let cached = ReportsCache.shared.loadDTOs(), !cached.items.isEmpty {
            completion(.success(cached.items))
        }

        fetchListDTO(limit: limit, order: order) { result in
            switch result {
            case .success(let dtos):
                ReportsCache.shared.saveDTOs(dtos)
                completion(.success(dtos))
            case .failure(let e):
                let hadCache = !(ReportsCache.shared.loadDTOs()?.items.isEmpty ?? true)
                if !hadCache {
                    completion(.failure(e))
                }
            }
        }
    }
    func fetchDetail(id: Int,
                     completion: @escaping (Result<ReportDetail, NetworkError>) -> Void) {
        HTTPClient.shared.get(path: APIConfig.Path.reportDetail(id),
                              query: nil,
                              completion: completion)
    }

}
