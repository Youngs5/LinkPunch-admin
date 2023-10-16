//
//  File.swift
//  LinkPunchAdmin
//
//  Created by Ari on 2023/08/23.
//

import Foundation

/*
struct UserReportedData: Identifiable {
    var id: String = UUID().uuidString
    var reporter: String //신고자
    var reportedUser: String //신고받은 사람
    var reportDate: Date // 신고 일자
    var userReportedReason: UserRepoertedReason //신고 사유
}

enum UserRepoertedReason: CaseIterable {
    case impersonation, fakeCV, offensive, extra
    
    var reason: String {
        switch self {
        case .impersonation:
            return "사칭 계정"
        case .fakeCV:
            return "CV 허위"
        case .offensive:
            return "불쾌한 사적 연락"
        case .extra:
            return "기타"
        }
    }
}

extension UserReportedData {
    static var samples: [Self] = [
        .init(reporter: "유젝구", reportedUser: "윤딩", reportDate: Date(), userReportedReason: UserRepoertedReason.impersonation),
        .init(reporter: "윤딩", reportedUser: "쭌빵", reportDate: Date(), userReportedReason: UserRepoertedReason.fakeCV),
        .init(reporter: "쭌빵", reportedUser: "불나방", reportDate: Date(), userReportedReason: UserRepoertedReason.fakeCV),
        .init(reporter: "불나방", reportedUser: "러츠", reportDate: Date(), userReportedReason: UserRepoertedReason.fakeCV),
        .init(reporter: "불나방", reportedUser: "러츠", reportDate: Date(), userReportedReason: UserRepoertedReason.fakeCV)
    ]
}

enum UserManagement: CaseIterable {
    case userInformation, reportedUser, suspectedUser
    
    var title: String {
        switch self {
        case .userInformation:
            return "전체 회원 정보"
        case .reportedUser:
            return "신고된 회원"
        case .suspectedUser:
            return "정지된 회원"
        }
    }
}

*/
