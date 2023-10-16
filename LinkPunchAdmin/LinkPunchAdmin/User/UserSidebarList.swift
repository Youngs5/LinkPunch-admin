//
//  UserSidebarList.swift
//  LinkPunchAdmin
//
//  Created by Ari on 2023/08/23.
//

import SwiftUI

struct UserSidebarList: View {
    let userStore: UserStore
    
    var body: some View {
        List(UserSidebar.allCases) { screen in
            Section {
                ForEach(screen.subtitle, id: \.self) { item in
                    NavigationLink {
                        UserListTableView(userStore: userStore, sidebarType: item, user: NewUser())
                    } label: {
                        UserSidebarListCell(userStore: userStore, item: item)
                    }
                }
            } header: {
                screen.label
            }
        }
    }
}


struct UserSidebarList_Previews: PreviewProvider {
    static var previews: some View {
        UserSidebarList(userStore: UserStore())
    }
}
