//
//  RevisionedData.swift
//  Cookie
//
//  Created by 이상현 on 2022/07/23.
//

struct RevisionedData<T>: Equatable {
    static func == (lhs: RevisionedData, rhs: RevisionedData) -> Bool {
        return lhs.revision == rhs.revision
    }

    let revision: UInt
    let data: T?
}

extension RevisionedData {
    func update(_ data: T?) -> RevisionedData {
        return RevisionedData<T>(revision: self.revision + 1, data: data)
    }
}
