//
//  Report.swift
//  LinkPunchAdmin
//
//  Created by gnksbm on 2023/08/23.
//

import Foundation

enum ReportCase: String, CaseIterable {
    case unrelated = "관련 없는 글" // 관련 없는 글
    case spamFlagging = "스팸/도배 글" // 스팸/도배 글
    case obscenity = "음란물" // 음란물
    case offensiveLanguage = "불쾌한 표현" // 불쾌한 표현
    case etc = "기타 사유" // 기타(선택 시 textField)
}

struct ReportCountInfo {
    var isHiddened: Bool = false //숨김여부
    var unrelatedCount = 0
    var spamFlaggingCount = 0
    var obscenityCount = 0
    var offensiveLanguageCount = 0
    var etcCount = 0
    
    var total: Int {
        unrelatedCount + spamFlaggingCount + obscenityCount + offensiveLanguageCount + etcCount
    }
}

struct PostReport: Identifiable {
    var id: String = UUID().uuidString
    var reportedBy: NewUser // 신고자 이름
    var reportedDate: String // 신고한 날짜
    var reportcase: [ReportCase] // 신고 사유 중복 가능
    var reportReason: String = "" // enum에 etc 기타 사유가 작성
}


//샘플데이터
extension PostReport {
    static var sampleData: [Self] = [
        .init(reportedBy: NewUser(), reportedDate: "2023-8", reportcase: [.unrelated, .obscenity], reportReason: "어쩌고 저꺼조"),
        .init(reportedBy: NewUser(), reportedDate: "2023-8", reportcase: [.unrelated, .obscenity], reportReason: "어쩌고 저꺼조"),
        .init(reportedBy: NewUser(), reportedDate: "2023-8", reportcase: [.unrelated, .obscenity], reportReason: "어쩌고 저꺼조"),
        .init(reportedBy: NewUser(), reportedDate: "2023-8", reportcase: [.unrelated, .obscenity], reportReason: "어쩌고 저꺼조")
    ]
}
