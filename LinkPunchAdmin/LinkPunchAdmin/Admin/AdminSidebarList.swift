//
//  AdminSidebarList.swift
//  LinkPunchAdmin
//
//  Created by 김효석 on 2023/08/23.
//

import SwiftUI

struct AdminSidebarList: View {
    
    @EnvironmentObject var adminStore: AdministratorStore
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State private var level = Administrator.Level.master
    
    @State private var isShowingSheet = false
    
    @State var isLoading: Bool = false
    
    var body: some View {
        List(Administrator.Level.allCases){ sidebar in
            
            if !isLoading {
                ProgressView("Loading...")
                
            } else {
                Section {
                    switch sidebar {
                    case .master:
                        ForEach($adminStore.masterList) { $admin in
                            NavigationLink {
                                AdminDetailView(admin: admin)
                            } label: {
                                Text(admin.adminName)
                            }
                        }
                    case .employee:
                        ForEach($adminStore.employeeList) { $admin in
                            NavigationLink {
                                AdminDetailView(admin: admin)
                            } label: {
                                Text(admin.adminName)
                            }
                        }
                    }
                } header: {
                    Text(sidebar.levelString)
                    if let log = adminStore.loginedAdmin, log.level == .master {
                        Button {
                            level = sidebar
                            isShowingSheet = true
                        } label: {
                            Spacer()
                            Image(systemName: "plus")
                                .padding(.trailing, 5)
                        }
                        .foregroundColor(.accentColor)
                    }
                    Spacer()
                }
            }
            
        }
        .onAppear {
            adminStore.fetchAdminData { success in
                if success {
                    isLoading = true
                    print("matser 관리자 수 \(adminStore.masterList.count)")
                    print("employee 관리자 수 \(adminStore.employeeList.count)")
                }
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            AdminRegisterView(level: $level, isPresented: $isShowingSheet)
        }
    }
}

struct AdminSidebarList_Previews: PreviewProvider {
    // Fetch되기 이전이기 때문에 프리뷰에서 리스트가 보이지 않음. 프리뷰에서도 확인하기 위해서 fetch를 진행함.
    static var store = AdministratorStore()
    
    static var previews: some View {
        AdminSidebarList()
            .environmentObject(store)
            .onAppear {
                store.fetchAccount()
            }
    }
}
