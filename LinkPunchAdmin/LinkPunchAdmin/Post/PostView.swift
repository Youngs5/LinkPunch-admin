//
//  UserView.swift
//  ProjectAMock
//
//  Created by gnksbm on 2023/08/22.
//

import SwiftUI

struct PostView: View {
    @State var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @EnvironmentObject private var adminStore: AdministratorStore
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            PostSidebarList()
        } detail: {
            
        }
        .tabItem {
            Image(systemName: "exclamationmark.triangle.fill")
            Text("신고된 게시물")
        }
        
    }
    
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
