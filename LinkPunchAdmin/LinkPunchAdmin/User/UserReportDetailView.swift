//
//  UserReportDetailView.swift
//  LinkPunchAdmin
//
//  Created by yunjikim on 2023/08/23.
//

import SwiftUI

struct UserReportDetailView: View {
    let userStore: UserStore
    let userInfo: NewUser
    var userReportList: [NewUserReports] {
            guard let userReports = userInfo.userReports else {
                return []
        }
        return userReports
    }
    
    @State private var isShowingStoppedAlert: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            UserProfileView(userInfo: userInfo)
                .padding(.horizontal)
            
            UserCvView(userInfo: userInfo, isShowingCv: false)
                .padding(.horizontal)
                .padding(.bottom, 50)
            
            VStack(alignment: .leading) {
                Text("신고 사유")
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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingStoppedAlert = true
                        
                    } label: {
                        Text("계정 정지")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .alert(isPresented: $isShowingStoppedAlert) {
                        Alert(
                            title: Text("선택된 사용자가 정지됩니다."),
                            message: Text("이 작업은 되돌릴 수 없습니다."),
                            primaryButton: .destructive(Text("정지"), action: {
                                userStore.processSuspendUser(user: userInfo)
                                dismiss()
                            }),
                            secondaryButton: .cancel(Text("취소"))
                        )
                    }
                }
            }
        }
        .navigationTitle("신고된 회원 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserReportDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UserReportDetailView(userStore: UserStore(), userInfo: NewUser())
        }
    }
}
