//
//  ReportListItem.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 8/08/25.
//

import Foundation

struct ReportListItem {
    let id: Int
    let folio: String
    let title: String
    let priority: String
    let statusText: String
    let createdAt: String
    let area: String
    let department: String
    let unitName: String
    let creator: String
    let solver: String
    let type: String
}

extension ReportListItem {
    init(dto: ReportDTO) {
        id = dto.id
        folio = dto.folio ?? "—"
        title = dto.name ?? "—"
        priority = dto.priority?.name ?? "—"
        statusText = dto.status?.description ?? "—"
        createdAt = Self.format(dateString: dto.createTime)
        area = dto.area?.name ?? "—"
        department = dto.department?.name ?? "—"
        unitName = dto.store?.name ?? "—"
        creator = [dto.createdByUser?.firstName, dto.createdByUser?.lastName]
            .compactMap { $0 }.joined(separator: " ").nilDash
        solver = [dto.attendingByUser?.firstName, dto.createdByUser?.lastName]
            .compactMap { $0 }.joined(separator: " ").nilDash
        type = (dto.type?.capitalized) ?? "—"
    }

    private static func format(dateString: String?) -> String {
        guard let s = dateString else { return "—" }
        let isoFrac = ISO8601DateFormatter()
        isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let iso = ISO8601DateFormatter()
        let d = isoFrac.date(from: s) ?? iso.date(from: s)
        guard let date = d else { return "—" }
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm"
        return df.string(from: date)
    }
}

private extension String {
    var nilDash: String { isEmpty ? "—" : self }
}
