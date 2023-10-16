////
////  UserData.swift
////  LinkPunchAdmin
////
////  Created by Ari on 2023/08/23.
////
//
//import Foundation
//
//struct User: Identifiable {
//    var userNickName: String? //닉네임
//    var name: String? //이름
//    var signUpDate: String? //가입날짜 생성
//    var userEmail: String? //로그인용 이메일
//    var userPwd: String? //비밀번호
//    var userImage: String? // 프사
//    var social: Social?
//    var education: [Education]?
//    var location: [String]?  // 선호지역이라 여러곳을 작성
//    var fields: [String]? // 관심분야
//    var userReport: [UserReport]?
//    var userSuspend: UserSuspend?
//    var id : String {
//        userEmail ?? ""
//    }
//    var cv  : CV?
//}
//
//enum Social: String {
//    case none
//    case apple
//    case google
//    case kakao
//}
//
//struct Education: Identifiable {
//    var id: String = UUID().uuidString
//    var school: String  // 학교
//    var status: String // 상태 ( 재학, 졸업, 수료 등 )
//    var major: String // 전공
//    var admissionDateString: String
//    var graduateDateString: String
//}
//
//// 활동 내역 struct
//struct Experience: Identifiable { //CV 예상
//    var id: String = UUID().uuidString
//    var title: String
//    var period: String
//    var description: String
//}
//
//// 이력서 정보 struct
//struct CV {
//    var shortIntroduce: String? //(짧게 나타내는 한줄 자기소개)
//    var projects: [Experience]?    // 프로젝트
//    var activities: [Experience]?     //활동
//    var certifications: [Experience]?   //자격증
//}
//
//// 회원 신고 struct
//struct UserReport: Identifiable {
//    var id: String = UUID().uuidString
//    var reporterNickname: String //신고자
//    var reporterEmail: String // 신고자 이메일
//    var reportDateString: String // 신고 날짜
//    var userReportedReason: [UserRepoertedReason] //신고 사유
//    var ReportedReasonDetail: String // 기타일 경우
//}
//
//enum UserRepoertedReason: String {
//    case impersonation = "사칭 계정" // 사칭 계정
//    case fakeAccount = "허위 계정" // 허위 계정
//    case fakeCV = "허위 CV" // CV 허위
//    case offensive = "불쾌한 사적 연락" // 불쾌한 사적 연락
//    case extra = "기타" //기타
//}
//
//// 회원 신고 카운트 struct
//struct ReportCount {
//    //사칭계정 신고 카운트
//    var impersonationCount: Int = 0
//    //허위계정 신고 카운트
//    var fakeAccountCount: Int = 0
//    //허위CV 신고 카운트
//    var fakeCVCount: Int = 0
//    //불쾌한 사적연락 신고 카운트
//    var offensiveCount: Int = 0
//    //기타 신고 카운트
//    var extraCount: Int = 0
//    
//    var total: Int {
//        return impersonationCount + fakeAccountCount + fakeCVCount + offensiveCount + extraCount
//    }
//}
//
//// 회원 정지 struct
//struct UserSuspend {
//    var isStopped: Bool = false //정지여부
//    var isDeleted: Bool = false // 삭제여부
//    var suspensionDateString : String? //정지 날짜
//    var stopCount: Int = 0 //정지횟수
//    var reportedCount: ReportCount //신고횟수
//}
//
//enum UserManagement: CaseIterable {
//    case userInformation, reportedUser, suspectedUser, deletedUser
//}
//
//extension User {
//    static var samples: [Self] = [
//        .init(
//            userNickName: "쭌빵",
//            name: "김성준",
//            signUpDate: "2022년 08월 23일",
//            userEmail: "ggmail.com",
//            userImage: "",
//            location: ["서울", "경기"],
//            fields: ["iOS", "Swift"],
//            userReport: [
//                UserReport(reporterNickname: "신고자5", reporterEmail: "zsdsdf@gmail.com", reportDateString: "2022년 08월 23일", userReportedReason: [.fakeAccount], ReportedReasonDetail: ""),
//                UserReport(reporterNickname: "신고자5", reporterEmail: "serw@gmail.com", reportDateString: "2022년 08월 13일", userReportedReason: [.fakeAccount], ReportedReasonDetail: ""),
//            ],
//            userSuspend: UserSuspend(
//                isStopped: false, isDeleted: false, reportedCount: ReportCount( impersonationCount: 1, fakeCVCount: 1 )
//            ),
//            cv: CV(
//                shortIntroduce: "안녕하세요. iOS 개발자입니다.",
//                projects: [
//                    Experience(title: "LinkPunch", period: "2023.08. ~ Present.", description: "CV를 공유하는 어플리케이션 개발 프로젝트")
//                ],
//                activities: [
//                    Experience(title: "멋쟁이사자처럼", period: "2023.05. ~ Present.", description: "iOS 앱개발 기초 교육 및 프로젝트 진행")
//                ],
//                certifications: [
//                    Experience(title: "정보처리기능사", period: "2023.05.12. 취득", description: "정보처리기능사")
//                ]
//            )
//        ),
//        .init(
//            userNickName: "지축공주",
//            name: "이승준",
//            signUpDate: "2021년 01월 23일",
//            userEmail: "J@gmail.com",
//            userImage: "",
//            location: ["서울", "경기"],
//            fields: ["iOS", "Swift"],
//            userReport: [UserReport(reporterNickname: "신고자1", reporterEmail: "ewtwet@gmail.com", reportDateString: "2022년 08월 23일", userReportedReason: [.fakeAccount], ReportedReasonDetail: "")],
//            userSuspend: UserSuspend(
//                isStopped: false, isDeleted: false, reportedCount: ReportCount( fakeAccountCount: 1 )
//            ),
//            cv: CV(
//                shortIntroduce: "안녕하세요. iOS 개발자입니다.",
//                projects: [
//                    Experience(title: "LinkPunch", period: "2023.08. ~ Present.", description: "CV를 공유하는 어플리케이션 개발 프로젝트")
//                ],
//                activities: [
//                    Experience(title: "멋쟁이사자처럼", period: "2023.05. ~ Present.", description: "iOS 앱개발 기초 교육 및 프로젝트 진행")
//                ],
//                certifications: [
//                    Experience(title: "정보처리기능사", period: "2023.05.12. 취득", description: "정보처리기능사")
//                ]
//            )
//        ),
//        .init(userNickName: "Btv 아리아", name: "한아리", signUpDate: "2022년 08월 23일", userEmail: "vc@gmail.com", userImage: "",
//              userReport: [],
//              userSuspend: UserSuspend(
//                  isStopped: false, isDeleted: false, reportedCount: ReportCount( impersonationCount: 1 )
//              )
//        ),
//        .init(userNickName: "유젝구", name: "유재희", signUpDate: "2022년 11월 23일", userEmail: "efef@gmail.com", userImage: "",
//              userReport: [UserReport(reporterNickname: "신고자3", reporterEmail: "wetwet@gmail.com", reportDateString: "2022년 08월 23일", userReportedReason: [.fakeCV], ReportedReasonDetail: "")],
//              userSuspend: UserSuspend(
//                isStopped: false, isDeleted: false, reportedCount: ReportCount()
//              )
//        ),
//        .init(userNickName: "윤딩", name: "김윤지", signUpDate: "2022년 03월 23일", userEmail: "d@gmail.com", userImage: "",
//              userReport: [UserReport(reporterNickname: "신고자4", reporterEmail: "efghjtj@gmail.com", reportDateString: "2022년 04월 23일", userReportedReason: [.impersonation], ReportedReasonDetail: "")],
//              userSuspend: UserSuspend(
//                isStopped: false, isDeleted: false, reportedCount: ReportCount()
//              )
//        ),
//        .init(userNickName: "불나방", name: "남현정", signUpDate: "2022년 08월 23일", userEmail: "j@gmail.com", userImage: "",
//              userReport: [UserReport(reporterNickname: "신고자8", reporterEmail: "nbfgdf@gmail.com", reportDateString: "2022년 08월 21일", userReportedReason: [.offensive], ReportedReasonDetail: "")],
//              userSuspend: UserSuspend(
//                isStopped: false, isDeleted: false, reportedCount: ReportCount()
//              )
//        ),
//        .init(userNickName: "러츠", name: "함지수", signUpDate: "2022년 08월 23일", userEmail: "grgrg@gmail.com", userImage: "",
//              userReport: [UserReport(reporterNickname: "신고자7", reporterEmail: "yuouyi@gmail.com", reportDateString: "2022년 08월 23일", userReportedReason: [.fakeAccount], ReportedReasonDetail: "")],
//              userSuspend: UserSuspend(
//                isStopped: false, isDeleted: false, reportedCount: ReportCount()
//              )
//        ),
//    ]
//}
//
