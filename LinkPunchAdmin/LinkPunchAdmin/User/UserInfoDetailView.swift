//
//  UserInfoDetailView.swift
//  LinkPunchAdmin
//
//  Created by 김성준 on 2023/08/23.
//

import SwiftUI

struct UserInfoDetailView: View {
    let userStore: UserStore
    let userInfo: NewUser
    
    @State private var isShowingStoppedAlert: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack{
            //MARK: 회원 프로필 영역
            UserProfileView(userInfo: userInfo)
                .padding(.bottom, 50)

            //MARK: CV영역
            UserCvView(userInfo: userInfo, isShowingCv: true)
                .padding(.bottom, 50)
            Spacer()          
        }
        .padding(.horizontal)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !(userInfo.report?.isDeleted ?? false) {
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
        .navigationTitle("회원 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct UserInfoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            UserInfoDetailView(userStore: UserStore(), userInfo: NewUser())
        }
    }
}
