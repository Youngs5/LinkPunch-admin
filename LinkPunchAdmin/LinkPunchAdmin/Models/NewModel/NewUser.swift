//
//  NewUser.swift
//  LinkPunchAdmin
//
//  Created by 최하늘 on 2023/08/30.
//

import Foundation

struct NewUser: Identifiable, Codable {
    var isDeviceDuplicateCheck: Bool?
    var userNickName: String? //닉네임
    var name: String? //이름
    var signUpDate: String? //가입날짜 생성
    
    var userEmail: String? //로그인용 이메일
    var userPwd: String? //비밀번호
    var userImage: String? // 프사
    var social: NewSocial?

    var education: [NewEducation]?
    var location: [String]?  // 선호지역이라 여러곳을 작성
    var fields: [String]? // 관심분야
    
    
    var id : String {
        userEmail ?? ""
    }
    var report: NewReport?  //신고 관련 struct
    var cv: NewCV?
    var userReports: [NewUserReports]?
    
    enum CodingKeys: CodingKey {
        case isDeviceDuplicateCheck
        case userNickName
        case name
        case signUpDate
        case userEmail
        case userPwd
        case userImage
        case social
        case education
        case location
        case fields
        case report
        case cv
        case userReports
    }
}

enum NewSocial: String, Codable {
    case none
    case apple
    case google
    case kakao
}

enum NewUserManagement: CaseIterable {
    case userInformation, reportedUser, suspectedUser, deletedUser
}

struct NewEducation: Identifiable, Codable {
    var id: String = UUID().uuidString
    var school: String  // 학교
    var status: String // 상태 ( 재학, 졸업, 수료 등) 
    var major: String // 전공
    var admissionYear: String
    var graduateYear: String
    enum CodingKeys: CodingKey {
        case school
        case status
        case major
        case admissionYear
        case graduateYear
    }
}

// 신고 관련 struct
struct NewReport: Codable {
    var isStopped: Bool = false //정지여부
    var isDeleted: Bool = false // 삭제여부
    var suspensionDate : String? //정지날짜
    var stopCount: Int = 0 //정지횟수 
    var reportedCount: NewReportCount //신고횟수 
}

// 활동 내역 struct
struct NewExperience: Identifiable, Codable { //CV 예상
    var id: String = UUID().uuidString
    var title: String
    var period: String
    var description: String
}

// 이력서 정보 struct
struct NewCV: Codable {
    var shortIntroduce: String? //(짧게 나타내는 한줄 자기소개)
    
//    var projects: [Experience]?    // 프로젝트
//    var activities: [Experience]?     //활동
//    var certifications: [Experience]?   //자격증
    
    //임시데이터
    var projects: [NewExperience] = [
        NewExperience(title: "LinkPunch", period: "2023.08. ~ Present.", description: "CV를 공유하는 어플리케이션 개발 프로젝트")
    ]
    var activities: [NewExperience] = [
        NewExperience(title: "멋쟁이 사자처럼", period: "2023.05. ~ Present.", description: "iOS 앱개발 기초 교육 및 프로젝트 진행")
    ]
    var certifications: [NewExperience] = [
        NewExperience(title: "정보처리기능사", period: "2023.05.12. 취득", description: "정보처리기능사")
    ]

}

struct NewUserReports: Identifiable, Codable {
    var id: String = UUID().uuidString
    var reporterNickname: String //신고자
    var reporterEmail: String // 신고자 이메일
    var reportDateString: String // 신고 일자
    var userReportedReason: [NewUserRepoertedReason] //신고 사유
    var ReportedReasonDetail: String // 기타일 경우
}

struct NewReportCount: Codable {
    //사칭계정 신고 카운트
    var impersonationCount: Int = 0
    //허위계정 신고 카운트
    var fakeAccountCount: Int = 0
    //허위CV 신고 카운트
    var fakeCVCount: Int = 0
    //불쾌한 사적연락 신고 카운트
    var offensiveCount: Int = 0
    //기타 신고 카운트
    var extraCount: Int = 0
    
    var total: Int = 0
}

enum NewUserRepoertedReason: String, CaseIterable, Codable {
    case impersonation = "사칭 계정"  // 사칭 계정
    case fakeAccount = "허위 계정"  // 허위 계정
    case fakeCV = "CV 허위"  // CV 허위
    case offensive = "불쾌한 사적 연락"  // 불쾌한 사적 연락
    case extra = "기타"  //기타 -> textField로 연결
}

