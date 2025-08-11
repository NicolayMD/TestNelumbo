//
//  ReportsListViewModel.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

final class ReportsListViewModel {
    enum State { case idle, loading, loaded([ReportListItem]), error(String) }

    var stateChanged: ((State) -> Void)?
    var onSelect: ((Int) -> Void)?
    private let service: ReportsService

    init(service: ReportsService = .shared) { self.service = service }

    func load() {
        stateChanged?(.loading)
        service.fetchListDTOWithCache { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dtos):
                    self?.stateChanged?(.loaded(dtos.map(ReportListItem.init(dto:))))
                case .failure(let e):
                    self?.stateChanged?(.error(e.description))
                }
            }
        }
    }


    func select(item: ReportListItem) { onSelect?(item.id) }
}
