//
//  UserStore.swift
//  LinkPunchAdmin
//
//  Created by J on 2023/08/25.
//

import Foundation
import Firebase
import FirebaseFirestore

final class UserStore: ObservableObject {
    @Published var users: [NewUser] = []
    @Published var reportedUsers: [NewUser] = [] // 신고된 회원 리스트
    @Published var suspendedUsers: [NewUser] = [] // 정지된 회원 리스트
    @Published var deletedUsers: [NewUser] = [] // 삭제된 회원 리스트
    
    let db = Firestore.firestore()
    
    // 유저정보 Fetch
    func fetch(completion: @escaping (Bool) -> Void) {
            
        users.removeAll()
        db.collection("users").getDocuments { (querySnapshot, error) in
            
            guard let querySnapshot = querySnapshot, error == nil else {
                print("Error fetching data: (error?.localizedDescription ?? ")
                return
            }
            
            for document in querySnapshot.documents {
                if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let post = try? JSONDecoder().decode(NewUser.self, from: jsonData) {
                    self.users.append(post)
                }
            }
            completion(true)
            print("유저리스트 패치: \(self.users)")
        }
    }
    
    //계정 정지
    func processSuspendUser(user: NewUser) {
        
        var user = user
        // TODO: 정지날짜 추가 필요
        //정지여부 처리
        // user.userSuspend?.suspensionDateString
        if var userSuspend =  user.report {
            userSuspend.isStopped = true
            userSuspend.stopCount += 1
            user.report = userSuspend
        } else {
            user.report = NewReport(
                isStopped: true ,
                isDeleted: false,
                suspensionDate: "2023-08-29",
                stopCount: 1,
                reportedCount: NewReportCount()
            )
        }
        
        // 카운트 초기화
        var recentUserSuspend = user.report
        recentUserSuspend?.reportedCount.impersonationCount = countReports(user)[0]
        recentUserSuspend?.reportedCount.fakeAccountCount = countReports(user)[1]
        recentUserSuspend?.reportedCount.fakeCVCount = countReports(user)[2]
        recentUserSuspend?.reportedCount.offensiveCount = countReports(user)[3]
        recentUserSuspend?.reportedCount.extraCount = countReports(user)[4]
        recentUserSuspend?.reportedCount.total = sum(countReports(user))
        
        user.report = recentUserSuspend
        
        let updatedIndex = users.firstIndex { User in
            User.id == user.id
        }
        
        if let updatedIndex {
            users.remove(at: updatedIndex)
            users.append(user)
            dummyfetch()
        }
    }
    
    func sum(_ intArray: [Int]) -> Int {
        return intArray.reduce(0, +)
    }
    
    func countReports(_ user: NewUser) -> [Int] {
        var offensiveCount = 0
        var fakeAccountCount = 0
        var fakeCVCount = 0
        var impersonationCount = 0
        var extraCount = 0
        
        if let userReports = user.userReports {
            for userReport in userReports {
                switch userReport.userReportedReason {
                case [.impersonation]:
                    impersonationCount += 1
                case [.fakeAccount]:
                    fakeAccountCount += 1
                case [.fakeCV]:
                    fakeCVCount += 1
                case [.offensive]:
                    offensiveCount += 1
                default:
                    extraCount += 1
                }
            }
        }
        
        return [impersonationCount, fakeAccountCount, fakeCVCount, offensiveCount, extraCount]
    }
    
    // 계정 정지 해제
    func processReleaseUser(user: NewUser) {
        var user = user
        
        var userSuspend = user.report
        userSuspend?.isStopped = false
        user.report = userSuspend
        
        let updatedIndex = users.firstIndex { User in
            User.id == user.id
        }
        
        if let updatedIndex {
            users.remove(at: updatedIndex)
            users.append(user)
            dummyfetch()
        }
    }
    
    // 계정 삭제
    func processDeleteUser(user: NewUser) {
        var user = user
        
        var userSuspend = user.report ?? NewReport(isDeleted: true, reportedCount: NewReportCount())
        
        userSuspend.isDeleted = true
        userSuspend.isStopped = false
        
        user.report = userSuspend
        
        let updatedIndex = users.firstIndex { User in
            User.id == user.id
        }
        
        if let updatedIndex {
            users.remove(at: updatedIndex)
            users.append(user)
            dummyfetch()
        }
    }
    
    //더미 파이어베이스 연동
    func dummyfetch() {
        reportedUsers = users.filter {
            let amountReportedCount = $0.report?.reportedCount.total
            return amountReportedCount != 0
        }
        
        suspendedUsers = users.filter {
            guard let usersSuspend = $0.report else {
                return false
            }
            return usersSuspend.isStopped
        }
        
        deletedUsers = users.filter {
            guard let usersSuspend = $0.report else {
                return false
            }
            return usersSuspend.isDeleted
        }
    }
}
