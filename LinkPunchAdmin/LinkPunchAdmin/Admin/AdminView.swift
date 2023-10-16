//
//  AdminView.swift
//  LinkPunchAdmin
//
//  Created by 김효석 on 2023/08/23.
//

import SwiftUI

struct AdminView: View {
    @State private var columnVisibility = NavigationSplitViewVisibility.doubleColumn
    @EnvironmentObject private var adminStore: AdministratorStore
    @State private var isShowingAlert = false
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            AdminSidebarList()
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("로그아웃", role: .destructive) {
                            isShowingAlert = true
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(7)
                    }
                }
                .alert("로그아웃 하시겠습니까?", isPresented: $isShowingAlert) {
                    Button(role: .destructive) {
                        adminStore.logout()
                    } label: {
                        Text("로그아웃")
                    }
                    Button(role: .cancel) {
                        
                    } label: {
                        Text("취소")
                    }
                }
        } detail: {
            AdminDetailView(admin: adminStore.loginedAdmin ?? Administrator.emptyAdmin)
        }
        .tabItem {
            Image(systemName: "person.badge.key.fill")
            Text("관리자 목록")
        }
    }
}


struct AdminView_Previews: PreviewProvider {
    static var store = AdministratorStore()
    
    static var previews: some View {
        AdminView()
            .environmentObject(store)
            .onAppear {
                store.fetchAccount()
                store.loginedAdmin = Administrator.sampleData[0]
            }
    }
}

