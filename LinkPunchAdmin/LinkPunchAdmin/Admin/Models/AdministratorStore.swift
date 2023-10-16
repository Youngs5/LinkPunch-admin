//
//  AdministratorStore.swift
//  LinkPunchAdmin
//
//  Created by Jisoo HAM on 2023/08/25.
//

import UIKit
import FirebaseFirestore

// 상속하지 않는다면 final 키워드를 넣자 !
final class AdministratorStore: ObservableObject {
    
    //admin계정전부들어있는 리스트
    @Published var adminList: [Administrator] = []
    
    @Published var masterList : [Administrator] = []
    @Published var employeeList : [Administrator] = []
    
    
    // 로그인이 된 것을 확인하기 위한 것
    @Published var loginedAdmin : Administrator? = nil
    
    func fetchAccount() {
        masterList = Administrator.sampleData.filter { $0.level == .master }
        
        /*
         masterList = allList.filter { $0[keyPath: \.level] == .master } // GPT 알려준거
         
         원형
         let allList = Administrator.sampleData
         masterList = allList.filter({ Administrator in
         Administrator.level == .master
         })
         */
        
        employeeList = Administrator.sampleData.filter { $0.level == .employee }
    }
    
    func checkAccount(id: String, pw: String) -> Bool {
        var result = false
        
        if adminList.contains (where: {
            $0.adminID == id &&
            $0.password == pw
        }) {
            login(id: id)
            result = true
        }
        if employeeList.contains (where: {
            $0.adminID == id &&
            $0.password == pw
        }) {
            login(id: id)
            result = true
        }
        return result
    }
    
    func addAccount(admin: Administrator) -> Bool {
        let isOverlap = masterList.map { $0.id }
            .contains(admin.id) ||
        employeeList.map { $0.id }
            .contains(admin.id)
        if !isOverlap {
            switch admin.level {
            case .master:
                masterList.append(admin)
            case .employee:
                employeeList.append(admin)
            }
        }
        return !isOverlap
    }
    
    func deleteAccount(admin: Administrator) {
        // firstIndex(of: ) 는 옵셔널 반환임! + hashable을 하지 않으면 에러처리를 따로 해주어야함!
        if let index = masterList.firstIndex(of: admin) {
            masterList.remove(at: index)
        }
        if let index = employeeList.firstIndex(of: admin) {
            employeeList.remove(at: index)
        }
    }
    
    func updateAccount(name: String, id: String, admin: Administrator) {
        if let index = masterList.firstIndex(of: admin) {
            masterList[index].adminName = name
            masterList[index].adminID = id
        }
        if let index = employeeList.firstIndex(of: admin) {
            employeeList[index].adminName = name
            employeeList[index].adminID = id
        }
    }
    
    func login(id: String) {
        if let index = adminList.firstIndex(where: { admin in
            admin.adminID == id
        }) {
            loginedAdmin = adminList[index]
        }
    }
    
    func logout() {
        loginedAdmin = nil
    }
}


extension AdministratorStore {
    
    //관리자 리스트 가져오기
    func fetchAdminData(completion: @escaping (Bool) -> Void) {
        masterList.removeAll()
        employeeList.removeAll()
        
        let dataBase = Firestore.firestore().collection("adminUsers")
        dataBase.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error fetching data: (error?.localizedDescription ?? ")
                return
            }
            
            for document in snapshot.documents {
                if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let post = try? JSONDecoder().decode(Administrator.self, from: jsonData) {
                    
                    self.adminList.append(post)
                    if post.level == .master {
                        self.masterList.append(post)
                    } else {
                        self.employeeList.append(post)
                    }
                    
                }
            }
            
            completion(true)
            print("파이어베이스 스터디 데이터 가져오기 성공")
        }
    }
    
    //파이어베이스에 데이터 추가
    func addAdminData(adminID: String, password: String, level: Administrator.Level, adminName: String, profileUrlString: String) {
        
        let adminUser = Administrator(adminID: adminID, password: password, level: level, adminName: adminName, profileUrlString: profileUrlString)
        
        print("저장 아이디\(adminUser.id)")
        let dataBase = Firestore.firestore().collection("adminUsers")
        dataBase.document(adminUser.id)
            .setData(adminUser.asDictionary())
        
    }
    
    //수정 업데이트
    func updateAccountData(name: String, id: String, admin: Administrator) {
        print("원래 아이디\(admin.id)")
        let updateUser = Administrator(id: admin.id, adminID: id, password: admin.password, level: admin.level, adminName: name, profileUrlString: admin.profileUrlString)
        
        print("바뀐 아이디\(updateUser.id)")
        let dataBase = Firestore.firestore().collection("adminUsers")
        dataBase
            .document(admin.id)
            .updateData(
                updateUser.asDictionary()
            ) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Document successfully updated")
                }
            }
    }
    
    //관리자 삭제
    func deleteAccountData(admin: Administrator) {
        
        let dataBase = Firestore.firestore().collection("adminUsers")
        dataBase
            .document(admin.id)
            .delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document successfully deleted!")
            }
        }
    }
}
