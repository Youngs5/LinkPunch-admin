//
//  AdminDetailView.swift
//  LinkPunchAdmin
//
//  Created by 김효석 on 2023/08/23.
//

import SwiftUI

struct AdminDetailView: View {
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    @EnvironmentObject var adminStore: AdministratorStore
    //바인딩에 private를 적지 못하는 이유 : 상위 뷰에서 값이 전달되어야하는데 private을 넣음으로 스코프가 제한되니까 안됨
    var admin: Administrator
    
    @State private var emptyAdmin = Administrator.emptyAdmin
    @State private var nameString: String = ""
    @State private var idString: String = ""
    
    @State private var isEditMode: Bool = false
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                Group {
                    HStack {
                        Spacer()
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width / 5)
                        Spacer()
                    }
                    AdminDetailRowView(textFieldValue: $nameString, title: "이름")
                        .disabled(!isEditMode)
                    AdminDetailRowView(textFieldValue: $idString, title: "아이디")
                        .disabled(!isEditMode)
                }
                .font(.title2)
                .padding(.vertical)
            }
            .navigationTitle(admin.level.levelString)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if let log = adminStore.loginedAdmin, log.level == .master {
                    if !isEditMode {
                        Button {
                            isEditMode = true
                        } label: {
                            Text("수정")
                                .font(.title3)
                                .frame(width: 45, height: 25)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                    } else {
                        Button {
                            print("바꿀 아이디 \(admin.id)")
                            adminStore.updateAccountData(name: nameString, id: idString, admin: admin)
                            // 완료를 했을 때 변경된 값을 다시 담아줘야지
                            adminStore.updateAccount(name: nameString, id: idString, admin: admin)
                            isEditMode = false
                        } label: {
                            Text("완료")
                                .font(.title3)
                                .frame(width: 45, height: 25)
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                    }
                    Button {
                        isShowingAlert = true
                    } label: {
                        Text("삭제")
//                            .foregroundColor(.red)
                            .font(.title2)
                            .frame(width: 45, height: 25)
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.white)
                    .background(.red)
                    .cornerRadius(7)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 15))
                    .alert("관리자 삭제", isPresented: $isShowingAlert) {
                        Button(role: .destructive) {
                            adminStore.deleteAccountData(admin: admin)
                            adminStore.deleteAccount(admin: admin)
                            dismiss()
                        } label: {
                            Text("삭제")
                        }
                        Button(role: .cancel) {
                            
                        } label: {
                            Text("취소")
                        }
                    }
                }
            }
        }
        .onChange(of: admin, perform: { newValue in
            isEditMode = false
            nameString = newValue.adminName
            idString = newValue.adminID
        })
        .onAppear {
            nameString = admin.adminName
            idString = admin.adminID
        }
    }
}

// sampleData[0]은 마스터 계정 -> 수정, 삭제, 관리자 추가 버튼이 보여야만 함
// 프리뷰에서 확인이 안되어서 확인이 가능하게 변경함.
struct AdminDetailView_Previews: PreviewProvider {
    static var store = AdministratorStore()
    static var admin = Administrator.sampleData[0]
    
    static var previews: some View {
        AdminDetailView(admin: admin)
        //        AdminDetailView(admin: .constant(admin))
            .environmentObject(store)
            .onAppear {
                // loginedAdmin => nil로 되어있고 거기에 넣어서 로그인이 되고 그 로그인 계정은 Master 계정! 그래서 버튼 보임
                store.loginedAdmin = admin
            }
    }
}
