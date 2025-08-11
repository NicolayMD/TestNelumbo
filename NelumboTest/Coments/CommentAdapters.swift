//
//  CommentAdapters.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import Foundation

extension LocalComment {
    var authorNameDisplay: String { [firstName, lastName].filter { !$0.isEmpty }.joined(separator: " ") }
    var messageDisplay: String { message }
    var dateTextDisplay: String {
        let isoFrac = ISO8601DateFormatter(); isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let iso = ISO8601DateFormatter()
        let d = isoFrac.date(from: createTime) ?? iso.date(from: createTime)
        guard let date = d else { return "—" }
        let df = DateFormatter(); df.dateFormat = "dd/MM/yyyy hh:mma"
        return df.string(from: date)
            .replacingOccurrences(of: "AM", with: "am")
            .replacingOccurrences(of: "PM", with: "pm")
    }
}
