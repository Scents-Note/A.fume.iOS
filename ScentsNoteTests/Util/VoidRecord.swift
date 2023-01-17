//
//  VoidRecord.swift
//  ScentsNoteTests
//
//  Created by 황득연 on 2023/01/17.
//

import RxSwift
import RxTest

struct VoidRecord: Equatable {
    let record: Recorded<Event<Void>>

    static func == (lhs: Self, rhs: Self) -> Bool {
        guard lhs.record.time == rhs.record.time else { return false }

        switch (lhs.record.value, rhs.record.value) {
        case (.next, .next),
             (.completed, .completed):
            return true
        default:
            return false
        }
    }
}
