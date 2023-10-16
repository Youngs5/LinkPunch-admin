//
//  UserSidebar.swift
//  LinkPunchAdmin
//
//  Created by Ari on 2023/08/23.
//

import SwiftUI



enum UserSidebar: CaseIterable {
    case userInformation
    
    var id: Self { self }
    
    var subtitle: [NewUserManagement] {
        switch self {
        case .userInformation:
            return NewUserManagement.allCases.map { $0 }
        }
    }
}

extension UserSidebar: Identifiable {
    @ViewBuilder
    var label: some View {
        switch self {
        case .userInformation:
            Label("회원 정보", systemImage: "info.circle")
        }
    }
    
    // 커스텀 뷰
    @ViewBuilder
    var destination: some View {
        switch self {
        case .userInformation:
            UserListTableView(userStore: UserStore(), sidebarType: .userInformation, user: NewUser())
        }
    }
}
