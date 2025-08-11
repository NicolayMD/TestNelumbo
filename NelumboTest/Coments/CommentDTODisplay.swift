//
//  CommentDTODisplay.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//

import Foundation

extension CommentDTO {
    var authorNameDisplay: String {
        let first = (self as AnyObject).value(forKeyPath: "user.firstName") as? String
        let last  = (self as AnyObject).value(forKeyPath: "user.lastName") as? String
        let full  = [first, last].compactMap { $0 }.joined(separator: " ")
        return full.isEmpty ? "—" : full
    }

    var messageDisplay: String {
        (self as AnyObject).value(forKey: "message") as? String ?? "—"
    }

    var dateTextDisplay: String {
        let s = ((self as AnyObject).value(forKey: "createTime") as? String)
             ?? ((self as AnyObject).value(forKey: "createdAt")  as? String)

        guard let str = s else { return "—" }
        let isoFrac = ISO8601DateFormatter()
        isoFrac.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let iso = ISO8601DateFormatter()
        let d = isoFrac.date(from: str) ?? iso.date(from: str)
        guard let date = d else { return "—" }

        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy hh:mma"
        let out = df.string(from: date)
        return out.replacingOccurrences(of: "AM", with: "am")
                  .replacingOccurrences(of: "PM", with: "pm")
    }
}
