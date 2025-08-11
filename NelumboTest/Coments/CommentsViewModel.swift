//
//  CommentsViewModel.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import UIKit

final class CommentsViewModel {
    enum State { case idle, loading, loaded([LocalComment]), error(String), sending(Bool) }

    private let reportId: Int
    private let serverCommentsAny: [Any]?
    var stateChanged: ((State) -> Void)?

    init(reportId: Int, serverComments: [CommentDTO]? = nil) {
        self.reportId = reportId
        self.serverCommentsAny = serverComments?.map { $0 as Any }
    }

    func load() {
        stateChanged?(.loading)
        let server = mapServerComments(fromAnyArray: serverCommentsAny)
        var local = CommentStore.shared.loadLocal(reportId: reportId)

        var combined = server + local
        if combined.isEmpty {
            CommentStore.shared.seedIfEmpty(reportId: reportId)
            local = CommentStore.shared.loadLocal(reportId: reportId)
            combined = server + local
        }

        DispatchQueue.main.async { self.stateChanged?(.loaded(combined)) }
    }

    func send(message: String) {
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        stateChanged?(.sending(true))
        DispatchQueue.global().async {
            _ = CommentStore.shared.appendLocal(reportId: self.reportId, message: trimmed)
            let local = CommentStore.shared.loadLocal(reportId: self.reportId)
            let server = mapServerComments(fromAnyArray: self.serverCommentsAny)
            let combined = server + local
            DispatchQueue.main.async {
                self.stateChanged?(.sending(false))
                self.stateChanged?(.loaded(combined))
            }
        }
    }
}
