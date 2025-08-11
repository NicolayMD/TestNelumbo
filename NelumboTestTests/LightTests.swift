//
//  LightTests.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 11/08/25.
//

import XCTest
@testable import NelumboTest

final class LightTests: XCTestCase {
    
    func test_ReportListItem_mapsDTO() {
        let dto = ReportDTO(
            id: 42,
            name: "Título X",
            description: "Desc",
            folio: "F123",
            areaId: nil, departmentId: nil, priorityId: nil, type: "corrective",
            storeId: nil, createdBy: nil, statusId: nil,
            createTime: "2025-07-24T10:41:00Z", updateTime: nil, deleteTime: nil,
            area: MiniRef(id: 1, name: "Área Uno", description: nil),
            department: MiniRef(id: 2, name: "Depto Dos", description: nil),
            priority: MiniRef(id: 3, name: "Alta", description: nil),
            store: StoreRef(id: 10, name: "Sucursal A", keyCode: "001", address: nil, email: nil, phone: nil),
            createdByUser: UserRef(id: 7, firstName: "Ana", lastName: "Torres", email: nil, username: nil),
            status: StatusRef(id: 9, description: "En curso"),
            attendingByUser: nil
        )
        
        let vm = ReportListItem(dto: dto)
        
        XCTAssertEqual(vm.id, 42)
        XCTAssertEqual(vm.folio, "F123")
        XCTAssertEqual(vm.title, "Título X")
        XCTAssertEqual(vm.priority, "Alta")
        XCTAssertEqual(vm.statusText, "En curso")
        XCTAssertEqual(vm.area, "Área Uno")
        XCTAssertEqual(vm.department, "Depto Dos")
        XCTAssertEqual(vm.unitName, "Sucursal A")
        XCTAssertEqual(vm.creator, "Ana Torres")
        XCTAssertEqual(vm.type, "Corrective".lowercased().capitalized)
        XCTAssertTrue(vm.createdAt.contains("2025"))
    }
    
    func test_ReportDetailDisplay_buildsDaysAndTexts() {
        let threeDaysAgo = ISO8601DateFormatter().string(from: Date().addingTimeInterval(-3*24*3600))

        let detail = ReportDetail(
            id: 1,
            name: "Cambio de repuesto",
            description: "Desc",
            folio: "FR1",
            areaId: nil, departmentId: nil, priorityId: nil, type: "corrective",
            actionPlanImplementedId: nil, storeId: nil, evidences: nil, createdBy: nil, statusId: nil,
            rating: nil, ratingComment: nil, solutionDate: nil, solutionTime: nil, reportDate: nil, reportUrl: nil,
            userAttendingId: nil, configReportFolio: nil, statusAttentionId: nil, answerId: nil, detailCreation: nil,
            reasonReassign: nil, reassignUser: nil, reassignTime: nil, reasonCancel: nil, cancelUser: nil,
            cancelTime: nil, categoryId: nil, subcategoryId: nil, subcategoryText: nil, userQuestionnaireId: nil,
            assignedQuestionnaireId: nil, questionId: nil, createTime: threeDaysAgo, updateTime: nil, deleteTime: nil,
            dateStart: nil, dateEnd: nil, questionnaireId: nil, notified: nil, timeNotification: nil,
            area: AreaDetailDTO(id: 1, name: "Area A", description: nil, userManageId: nil),
            department: DepartmentDetailDTO(id: 2, name: "Depto B", description: nil, userManageId: nil, userManage: nil, userManagers: nil),
            priority: MiniRef(id: 3, name: "Alta", description: nil),
            store: StoreDetailDTO(id: 10, name: "Sucursal A", keyCode: "001", address: nil, email: nil, phone: nil, storeTimeZone: nil),
            createdByUser: UserRef(id: 9, firstName: "Luis", lastName: "García", email: nil, username: nil),
            status: StatusRef(id: 5, description: "Espera"),
            reportFolioComments: nil, reportFolioAnswers: nil, reportFolioUserAssign: nil, statusAttention: nil,
            reportFolioCategory: nil, reportFolioSubcategory: nil, categories: nil,
            attendingByUser: UserRef(id: 8, firstName: "Pedro", lastName: "Mena", email: nil, username: nil),
            assignedQuestionnaire: nil, questionnaireMain: nil, canDoActions: nil, canReassign: nil, usersTracking: nil,
            canResponse: nil, existAnyQuote: nil, canNotification: nil, userManageDepartment: nil, sla: nil, ola: nil,
            existSolutionCaseMgDpto: nil
        )

        let display = ReportDetailDisplay(detail: detail)
        XCTAssertEqual(display.folio, "FR1")
        XCTAssertEqual(display.title, "Cambio de repuesto")
        XCTAssertEqual(display.priority, "Alta")
        XCTAssertEqual(display.storeName, "Sucursal A")
        XCTAssertTrue(display.daysElapsedText.contains("Días Transcurridos"))
    }
    
    func test_CommentStore_persistsAndLoads() {
        let suite = UserDefaults(suiteName: "test.comments.suite")!
        let original = UserDefaults.standard

        UserDefaults.standard.removeObject(forKey: "comments_local_999")

        let store = CommentStore.shared
        _ = store.appendLocal(reportId: 999, message: "Hola", authorFirst: "Tú", authorLast: "")
        let loaded = store.loadLocal(reportId: 999)

        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.message, "Hola")
        XCTAssertEqual(loaded.first?.firstName, "Tú")

        UserDefaults.standard.removeObject(forKey: "comments_local_999")
        _ = original
        _ = suite
    }
}


