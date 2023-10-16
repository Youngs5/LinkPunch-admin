//
//  NewStudyRecruitment.swift
//  LinkPunchAdmin
//
//  Created by 최하늘 on 2023/08/30.
//

import SwiftUI

struct StudyRecruitment: Identifiable, Codable {
    var id: String = UUID().uuidString
    var endDate: String? //옵셔널 없어져야함
    var createdAt: Double = Date().timeIntervalSince1970
    var field: NewFieldType
    var location: StudyLocation
    var userName: String // 유저 네임          // 수정 필요, -> publisher가 있는데 있을 필요가 없음
    var userImgString: String // 유저 이미지    // 수정 필요, -> publisher가 있는데 있을 필요가 없음
    var title: String
    var contents: String
    var applicantCount: Int
    var nowApplicant: Int

//    var reportCount: Int  //신고횟수 추가
    var publisher: NewUser         // 게시글 작성자   // 옵셔널인 이유..?
    var participants: [NewUser]    // 스터디 참여자
    
    var postReport: [NewPostReport]?         //신고 관련 Struct
    var reportCountInfo: NewReportCountInfo?  //신고 카운트 struct
    var createdDate: String {
        let dateCreatedAt: Date = Date(timeIntervalSince1970: createdAt)
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "MM월 dd일"
        return dateFormatter.string(from: dateCreatedAt)
    }
    
    
    //관리자쪽 날짜 형식
    var createdDateWithTime: String {
        let dateCreatedAt = Date(timeIntervalSince1970: createdAt)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return dateFormatter.string(from: dateCreatedAt)
    }
    
    var userImg: Image {
        Image(systemName: userImgString)
    }
}

enum NewFieldType: String, CaseIterable, Identifiable, Codable {
    
    case All
    case Frontend
    case Backend
    case AI
    case Mobile
    case Game
    case Graphic
    case Etc
    
    var id: String { self.rawValue }
    
}

struct StudyLocation: Identifiable, Codable {
    var id: UUID = UUID()
    let latitude: Double // 위도
    let longitude: Double // 경도
    let address: String // 주소
}

struct NewPostReport: Codable, Identifiable {
    var id: String = UUID().uuidString
    var reportedBy: String // 신고자 이메일
    var reportedDate: String //신고날짜
    var reportcase: [NewReportCase] // 신고사유 중복가능
    var reportReason: String = "" // enum에 etc 기타사유가 작성
}

struct NewReportCountInfo: Codable {
    var isHiddened: Bool //숨김여부
    var unrelatedCount: Int //관련없는 글
    var spamFlaggingCount: Int//스팸
    var obscenityCount: Int // 음란물
    var offensiveLanguageCount: Int //불쾌한 표현
    var etcCount: Int //기타
    
    var total: Int {
        unrelatedCount + spamFlaggingCount + obscenityCount + offensiveLanguageCount + etcCount
    }
}

// 관련 없는 글, 스팸/도배 글, 음란물, 불쾌한 표현, 기타(선택 시 textField)
enum NewReportCase: String, CaseIterable, Codable {
    case unrelated = "관련 없는 글" // 관련 없는 글
    case spamFlagging = "스팸/도배 글"  // 스팸/도배 글
    case obscenity = "음란물" // 음란물
    case offensiveLanguage = "불쾌한 표현"  // 불쾌한 표현
    case etc = "기타 사유"  // 기타(선택 시 textField)
}
