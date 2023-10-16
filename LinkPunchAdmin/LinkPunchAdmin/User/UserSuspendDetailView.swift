//
//  UserSuspendDetailView.swift
//  LinkPunchAdmin
//
//  Created by J on 2023/08/23.
//

import SwiftUI

struct UserSuspendDetailView: View {
    let userStore: UserStore
    
    let userInfo: NewUser
    var userReportList: [NewUserReports] {
            guard let userReports = userInfo.userReports else {
                return []
        }
        return userReports
    }
    
    @State private var isShowingReleaseAlert: Bool = false
    @State private var isShowingDeletedAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                UserProfileView(userInfo: userInfo)
                    .padding(.horizontal)
                    .padding(.bottom, 50)
                Text("신고받은 이력")
                    .font(.title3.bold())
                    .padding(.horizontal)
                Table(of: NewUserReports.self) {
                    TableColumn("신고 사유 내용") { userReport in
                        VStack(alignment: .leading) {
                            ForEach(userReport.userReportedReason, id: \.self) { reason in
                                Text("\(reason.rawValue)")
                            }
                        }
                    }
                    TableColumn("신고받은 날짜") { userReport in
                        Text("\(userReport.reportDateString)")
                    }
                } rows: {
                    ForEach(userReportList) { userReport in
                        TableRow(userReport)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingReleaseAlert = true
                        } label: {
                            Text("정지 해제")
                        }
                        .buttonStyle(.bordered)
                        .alert(isPresented: $isShowingReleaseAlert) {
                            Alert(
                                title: Text("선택된 사용자의 계정 정지가 해제됩니다."),
                                message: Text("이 작업은 되돌릴 수 없습니다."),
                                primaryButton: .default(Text("정지 해제"), action: {
                                    userStore.processReleaseUser(user: userInfo)
                                    dismiss()
                                }),
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingDeletedAlert = true
                        } label: {
                            Text("계정 삭제")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                        .alert(isPresented: $isShowingDeletedAlert) {
                            Alert(
                                title: Text("선택된 사용자가 삭제됩니다."),
                                message: Text("이 작업은 되돌릴 수 없습니다."),
                                primaryButton: .destructive(Text("삭제"), action: {
                                    userStore.processDeleteUser(user: userInfo)
                                    dismiss()
                                }),
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }
                    }
                }
            }
            .navigationTitle("정지된 회원 정보")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct UserSuspendDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserSuspendDetailView(userStore: UserStore() , userInfo: NewUser())
    }
}
