//
//  UserSidebarListCell.swift
//  LinkPunchAdmin
//
//  Created by Ari on 2023/08/23.
//

import SwiftUI

struct UserSidebarListCell: View {
    @ObservedObject var userStore: UserStore
    let item : NewUserManagement
    
    var title: String {
        switch item {
        case .userInformation:
            return "전체 회원 정보"
        case .reportedUser:
            return "신고된 회원"
        case .suspectedUser:
            return "정지된 회원"
        case .deletedUser:
            return "삭제된 회원"
        }
    }
    
    var userCount: Int {
        switch item {
        case .userInformation:
            return userStore.users.count
        case .reportedUser:
            return userStore.reportedUsers.count
        case .suspectedUser:
            return userStore.suspendedUsers.count
        case .deletedUser:
            return userStore.deletedUsers.count
        }
    }
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(userCount)")
        }
    }
}

struct UserSidebarListCell_Previews: PreviewProvider {
    static var previews: some View {
        UserSidebarListCell(userStore: UserStore(), item: .reportedUser)
    }
}
