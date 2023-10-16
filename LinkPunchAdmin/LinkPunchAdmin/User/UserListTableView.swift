//
//  UserListTableView.swift
//  LinkPunchAdmin
//
//  Created by J on 2023/08/25.
//

import SwiftUI

struct UserListTableView: View {
    
    @ObservedObject var userStore: UserStore
    let sidebarType: NewUserManagement
    var user: NewUser
    
    @State private var currentPage: Int = 1
    let itemsPerPage: Int = 10
    var totalPages: Int {
        Int(ceil(Double(sortedFilteredList.count) / Double(itemsPerPage)))
    }

    var filteredList: [NewUser] {
        switch sidebarType {
        case .userInformation:
            return userStore.users
        case .reportedUser:
            return userStore.reportedUsers
        case .suspectedUser:
            return userStore.suspendedUsers
        case .deletedUser:
            return userStore.deletedUsers
        }
    }
    
    var sortedFilteredList: [NewUser] {
        switch SortingPicker {
        case sort[0]:
            return filteredList.sorted { lhs, rhs in
                lhs.name ?? "" < rhs.name ?? ""
            }
        case sort[1]:
            return filteredList.sorted { lhs, rhs in
                lhs.userNickName ?? "" < rhs.userNickName ?? ""
            }
        case sort[2]:
            return filteredList.sorted { lhs, rhs in
                lhs.signUpDate ?? "" < rhs.signUpDate ?? ""
            }
        default:
            return filteredList
        }
    }
    
    var currentPageList: [NewUser] {
        let startIndex = (currentPage - 1) * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, sortedFilteredList.count)
        return Array(sortedFilteredList[startIndex..<endIndex])
    }

    
    @State private var SortingPicker: String = "이름순"
    var sort: [String] = ["이름순", "닉네임순", "가입일순"]
    
    @State private var searchedList: [NewUser] = []
    @State private var searchText: String = ""
    var nameOrNickname: [String] = ["이름", "닉네임"]
    @State private var pickSearch: String = "이름"
    var promptText: String {
        "\(pickSearch)을 입력하세요"
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                Text("정렬 기준")
                //정렬필터
                Picker("sort", selection: $SortingPicker) {
                    ForEach(sort, id:\.self) { item in
                        Text(item)
                            .font(.caption)
                    }
                }
                .pickerStyle(.segmented)
                .font(.caption)
            }
            .padding()
            
            Table(of: NewUser.self) {
                TableColumn("이름") { user in
                    NavigationLink {
                        switch sidebarType {
                        case .userInformation:
                            UserInfoDetailView(userStore: userStore, userInfo: user)
                        case .reportedUser:
                            UserReportDetailView(userStore: userStore, userInfo: user)
                        case .suspectedUser:
                            UserSuspendDetailView(userStore: userStore, userInfo: user)
                        case .deletedUser:
                            UserInfoDetailView(userStore: userStore, userInfo: user)
                        }
                    } label: {
                        Text(user.name ?? "")
                            .foregroundColor(.accentColor)
                    }
                }
                
                TableColumn("닉네임") { user in
                    Text(user.userNickName ?? "")
                }
                
                TableColumn("계정") { user in
                    Text(user.userEmail ?? "")
                }
                TableColumn("가입날짜") { user in
                    Text(user.signUpDate ?? "")
                }
                TableColumn("신고받은 횟수") { user in
                    Text("\(user.report?.reportedCount.total ?? 0)")
                }
                
                
            } rows: {
                if searchText.isEmpty {
                    ForEach(currentPageList) { user in
                        TableRow(user)
                    }
                } else {
                    ForEach(searchedList) { user in
                        TableRow(user)
                    }
                }
            }
            .foregroundColor(.primary)
            .searchable(text: $searchText, prompt: promptText)
            .onTapGesture {
                hideKeyboard()
            }
            .onChange(of: searchText){ _ in
                if pickSearch == "이름" {
                    searchedList = filteredList.filter {
                        guard let name = $0.name else {
                            return false
                        }
                        return name.contains(searchText)
                    }
                } else if pickSearch == "닉네임" {
                    searchedList = filteredList.filter {
                        guard let userNickName = $0.userNickName else {
                            return false
                        }
                        return userNickName.contains(searchText)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("검색 필터")
                        //검색필터
                        Spacer()
                        Picker("nicknameOrTitle", selection: $pickSearch) {
                            ForEach(nameOrNickname,
                                    id:\.self) { item in
                                
                                Text(item)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .frame(maxWidth: .infinity)
                }
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button(action: {
                            if currentPage > 1 {
                                currentPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.backward")
                                .foregroundColor(currentPage > 1 ? .primary : .gray)
                        }
                        .disabled(currentPage <= 1)
                        
                        ForEach(1..<min(11, totalPages + 1), id: \.self) { pageNumber in
                            Button(action: {
                                currentPage = pageNumber
                            }) {
                                Text("\(pageNumber)")
                                    .font(.system(size: 16, weight: currentPage == pageNumber ? .bold : .regular))
                                    .foregroundColor(currentPage == pageNumber ? .primary : .gray)
                            }
                            .padding(.horizontal, 8)
                        }
                        
                        Button(action: {
                            if currentPage <= totalPages {
                                currentPage += 1
                            }
                        }) {
                            Image(systemName: "chevron.forward")
                                .foregroundColor(currentPage < totalPages ? .primary : .gray)
                        }
                        .disabled(currentPage >= totalPages)
                    }
                    .padding()
                    .onChange(of: currentPage) { _ in
                        searchedList = []
                    }

                }
            }
        }
        // 새로고침
        .refreshable {
            userStore.fetch { success in
                if success {
                    print(userStore.users.count)
                }
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct UserListTableView_Previews: PreviewProvider {
    static var previews: some View {
        UserListTableView(userStore: UserStore(), sidebarType: .userInformation, user: NewUser())
    }
}
