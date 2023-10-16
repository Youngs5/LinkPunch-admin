//
//  Administrator.swift
//  LinkPunchAdmin
//
//  Created by 김효석 on 2023/08/23.
//

import Foundation

struct Administrator : Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var adminID: String //관리자아이디 (이메일로 말고 그냥 아이디로)
    let password: String //비밀번호
    var level: Level
    var adminName: String
    let profileUrlString: String
    
    
    // 외부에서 쓰이지 않는 것은 중첩으로 자주 쓰이는 애플의 예제에 따라 + 피드백 내용을 수용하여 변경하였음.
    enum Level: CaseIterable, Identifiable, Codable{
        case master, employee
        
        var id: Self { self }
        var levelString: String {
            switch self {
            case .master:
                return "Master"
            case .employee:
                return "Employee"
            }
        }
    }
}

extension Administrator {
    static let emptyAdmin: Self = .init(adminID: "", password: "", level: .employee, adminName: "", profileUrlString: "")
    static let sampleData: [Self] = [
        Administrator(adminID: "adminm", password: "1", level: .master, adminName: "master", profileUrlString: ""),
        Administrator(adminID: "admine", password: "2", level: .employee, adminName: "employee", profileUrlString: ""),
        
        Administrator(adminID: "Lee", password: "1", level: .master, adminName: "이승준", profileUrlString: ""),
        Administrator(adminID: "Kim1", password: "1", level: .employee, adminName: "김건섭", profileUrlString: ""),
        Administrator(adminID: "Kim2", password: "1", level: .employee, adminName: "김효석", profileUrlString: ""),
        Administrator(adminID: "Nam", password: "1", level: .employee, adminName: "남현정", profileUrlString: ""),
        Administrator(adminID: "Ham", password: "1", level: .employee, adminName: "함지수", profileUrlString: "")
    ]
}

