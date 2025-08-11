//
//  MoreInfoViewModel.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import Foundation

struct TimelineEntry {
    let title: String
    let dateText: String
}

struct MoreInfoDisplay {
    let folioAndTitle: String
    let priority: String
    let status: String
    let type: String

    let email: String?
    let phone: String?

    let left: TimelineEntry
    let right: TimelineEntry
    let middleBadge: String?

    let bossName: String?
    let assignedUsers: [String]

    let store: StoreDetailDTO?
    let area: AreaDetailDTO?
    let department: DepartmentDetailDTO?

    let categories: [(String, String?)]

    let questionnaireName: String?
    let questionnaireQuestion: String?
    let questionnaireOptions: [String]
    let questionnaireSelectedIndex: Int?
}

final class MoreInfoViewModel {

    let detail: ReportDetail
    let display: MoreInfoDisplay

    init(detail: ReportDetail) {
        self.detail = detail

        let isoFrac = ISO8601DateFormatter(); isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let iso = ISO8601DateFormatter()

        func parse(_ s: String?) -> Date? {
            guard let s else { return nil }
            return isoFrac.date(from: s) ?? iso.date(from: s)
        }
        func fmt(_ d: Date?) -> String {
            guard let d else { return "—" }
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy hh:mm a"
            return df.string(from: d)
        }
        func fullName(first: String?, last: String?) -> String {
            [first, last].compactMap { $0 }.joined(separator: " ")
        }
        func safe(_ s: String?) -> String { (s?.isEmpty == false) ? s! : "—" }

        let folio   = safe(detail.folio)
        let title   = safe(detail.name)
        let priority = safe(detail.priority?.name)
        let status   = safe(detail.status?.description)
        let type     = safe(detail.type?.capitalized)

        let email = detail.store?.email ?? detail.createdByUser?.email
        let phone = detail.store?.phone

        let createdByName = fullName(first: detail.createdByUser?.firstName,
                                     last:  detail.createdByUser?.lastName)
        let createdAt = parse(detail.createTime)
        let leftEntry = TimelineEntry(
            title: createdByName.isEmpty ? "Creado por —" : "Creado por \(createdByName)",
            dateText: fmt(createdAt)
        )

        let approvedByName = fullName(first: detail.attendingByUser?.firstName,
                                      last:  detail.attendingByUser?.lastName)
        let approvedAt = parse(detail.updateTime) ?? parse(detail.createTime)
        let rightEntry = TimelineEntry(
            title: approvedByName.isEmpty ? "Aprobado por —" : "Aprobado por \(approvedByName)",
            dateText: fmt(approvedAt)
        )

        let middleBadge: String?
        if let a = approvedAt, let c = createdAt {
            let mins = max(0, Int(a.timeIntervalSince(c) / 60))
            middleBadge = (mins > 0) ? "\(mins) minutos" : nil
        } else {
            middleBadge = nil
        }

        let boss = fullName(first: detail.department?.userManage?.firstName,
                            last:  detail.department?.userManage?.lastName)

        let assignedUsers: [String] = (detail.reportFolioUserAssign ?? [])
            .map { fullName(first: $0.firstName, last: $0.lastName) }
            .filter { !$0.isEmpty }

        let unitCode = detail.store?.keyCode
        let unitName = detail.store?.name
        let unitText = detail.store
        let areaText = detail.area
        let departmentText = detail.department

        let categories: [(String, String?)] = (detail.categories ?? [])
            .map { ($0.category ?? "—", $0.subcategory) }

        let questionnaireName = detail.assignedQuestionnaire ?? detail.questionnaireMain
        let questionnaireQuestion = detail.detailCreation?.question

        let answersArray = detail.detailCreation?.answers ?? []
        let optionsFromDetail: [String]? = answersArray.compactMap { ans in
            guard let t = ans.title, !t.isEmpty else { return nil }
            return t
        }
        let questionnaireOptions = optionsFromDetail ?? ["1", "2", "3", "4", "5"]
        let questionnaireSelectedIndex = answersArray.firstIndex(where: { $0.selected == true })

        self.display = MoreInfoDisplay(
            folioAndTitle: "# \(folio) - \(title)",
            priority: priority,
            status: status,
            type: type,
            email: email,
            phone: phone,
            left: leftEntry,
            right: rightEntry,
            middleBadge: middleBadge,
            bossName: boss.isEmpty ? nil : boss,
            assignedUsers: assignedUsers,
            store: unitText,
            area: areaText,
            department: departmentText,
            categories: categories,
            questionnaireName: questionnaireName,
            questionnaireQuestion: questionnaireQuestion,
            questionnaireOptions: questionnaireOptions,
            questionnaireSelectedIndex: questionnaireSelectedIndex
        )
    }
}
