//
//  CommentStoreTests.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 10/08/25.
//

import XCTest
@testable import NelumboTest

final class CommentStoreTests: XCTestCase {
    func test_appendAndLoadLocal() {
        let reportId = 9999
        UserDefaults.standard.removeObject(forKey: "comments_local_\(reportId)")

        let store = CommentStore.shared
        _ = store.appendLocal(reportId: reportId, message: "Hola")
        let loaded = store.loadLocal(reportId: reportId)
        XCTAssertEqual(loaded.count, 1)
        XCTAssertEqual(loaded.first?.message, "Hola")
    }
    
    func test_mapServerComment_minimo() {
        // Simula un DTO suelto con claves básicas
        struct FakeUser { let firstName: String?; let lastName: String? }
        struct FakeComment { let id: Int; let comment: String?; let createTime: String; let user: FakeUser }
        let any: Any = FakeComment(id: 1, comment: "hola", createTime: "2025-08-10T10:00:00Z",
                                   user: FakeUser(firstName: "", lastName: "Pérez"))

        let result = mapServerComments(fromAnyArray: [any])
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.message, "hola")
        XCTAssertEqual(result.first?.firstName, "")
    }
}
