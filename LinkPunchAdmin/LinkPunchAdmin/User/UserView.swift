//
//  UserView.swift
//  ProjectAMock
//
//  Created by gnksbm on 2023/08/22.
//

import SwiftUI

struct UserView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @StateObject var userStore: UserStore = UserStore()
    
    var body: some View {
        NavigationSplitView (columnVisibility: $columnVisibility){
            UserSidebarList(userStore: userStore)
            
        }detail: {
            
        }
        .tabItem {
            Image(systemName: "person")
            Text("회원관리")
        }
        .onAppear {
            userStore.fetch { success in
                if success {
                    userStore.dummyfetch()
                }
            }
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
