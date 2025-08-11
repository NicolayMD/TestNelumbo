//
//  ReportDetailViewModel.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import Foundation

final class ReportDetailViewModel {
    enum State { case loading, loaded(ReportDetail), error(String) }
    private let id: Int
    private let service: ReportsService
    var stateChanged: ((State) -> Void)?

    init(id: Int, reportsService: ReportsService = .shared) {
        self.id = id
        self.service = reportsService
    }

    func load() {
        stateChanged?(.loading)
        service.fetchDetail(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let d): self?.stateChanged?(.loaded(d))
                case .failure(let e): self?.stateChanged?(.error(e.description))
                }
            }
        }
    }
}
