//
//  ReportDetailDisplay.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import Foundation

struct ReportDetailDisplay {
    let folio: String
    let title: String
    let priority: String
    let status: String
    let type: String
    let daysElapsedText: String
    let description: String
    let storeName: String
    let area: String
    let department: String
    let solver: String

    init(detail: ReportDetail) {
        folio = detail.folio ?? "—"
        title = detail.name ?? "—"
        priority = detail.priority?.name ?? "—"
        status = detail.status?.description ?? "—"
        type = (detail.type?.capitalized) ?? "—" 
        description = detail.description ?? "—"
        storeName = detail.store?.name ?? "—"
        area = detail.area?.name ?? "—"
        department = detail.department?.name ?? "—"
        solver = [detail.attendingByUser?.firstName, detail.attendingByUser?.lastName]
            .compactMap { $0 }.joined(separator: " ").isEmpty ? "—" :
            [detail.attendingByUser?.firstName, detail.attendingByUser?.lastName]
                .compactMap { $0 }.joined(separator: " ")

        if let s = detail.createTime, let d = ISO8601DateFormatter().date(from: s)
            ?? { let f = ISO8601DateFormatter(); f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]; return f.date(from: s) }() {
            let days = Calendar.current.dateComponents([.day], from: d, to: Date()).day ?? 0
            daysElapsedText = "\(days) Días Transcurridos"
        } else {
            daysElapsedText = "— Días Transcurridos"
        }
    }
}
