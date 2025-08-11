//
//  ServerCommentMapper.swift
//  NelumboTest
//
//  Created by Nicolay Steven Martinez Diaz on 9/08/25.
//
import Foundation

private func get<T>(_ any: Any, _ key: String) -> T? {
    Mirror(reflecting: any).children.first { $0.label == key }?.value as? T
}

private func firstString(_ any: Any, keys: [String]) -> String? {
    for k in keys { if let v: String = get(any, k), !v.isEmpty { return v } }
    return nil
}

private func firstInt(_ any: Any, keys: [String]) -> Int? {
    for k in keys { if let v: Int = get(any, k) { return v } }
    return nil
}

#if DEBUG
func debugPrintServerCommentShape(_ any: Any) {
    let kids = Mirror(reflecting: any).children.compactMap { $0.label }
    print("🧩 ServerComment keys:", kids)
    if let user: Any = get(any, "createdByUser") ?? get(any, "createdBy") ?? get(any, "user") {
        let uk = Mirror(reflecting: user).children.compactMap { $0.label }
        print("   ↳ user keys:", uk)
    }
}
#endif

func mapServerComments(fromAnyArray array: [Any]?) -> [LocalComment] {
    let iso = ISO8601DateFormatter()
    let serverAny = array ?? []
    #if DEBUG
    if let first = serverAny.first { debugPrintServerCommentShape(first) }
    #endif

    return serverAny.compactMap { s in
        let id = firstInt(s, keys: ["id", "commentId", "reportFolioCommentId"]) ?? Int.random(in: 1...9_999_999)

        let message = firstString(s, keys: ["comment", "message", "text", "description"]) ?? ""

        let createTime = firstString(s, keys: ["createTime", "createdAt", "date"]) ?? iso.string(from: Date())

        let user: Any? = get(s, "createdByUser") ?? get(s, "createdBy") ?? get(s, "user")
        let firstName = user.flatMap { firstString($0, keys: ["firstName", "name", "first"]) } ?? ""
        let lastName  = user.flatMap { firstString($0, keys: ["lastName", "surname", "last"]) } ?? ""

        return LocalComment(id: id, message: message, createTime: createTime,
                            firstName: firstName, lastName: lastName)
    }
}
