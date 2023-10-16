//
//  AdminRegisterView.swift
//  LinkPunchAdmin
//
//  Created by gnksbm on 2023/08/25.
//

import SwiftUI

struct AdminRegisterView: View {
    @EnvironmentObject var adminStore: AdministratorStore
    
    @State private var nameString: String = ""
    @State private var idString: String = ""
    @State private var passwordString: String = ""
    @State private var isOverlap = false
    
    @Binding var level: Administrator.Level
    @Binding var isPresented: Bool
    
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
                    AdminDetailRowView(textFieldValue: $idString, title: "아이디")
                    AdminDetailRowView(textFieldValue: $passwordString, title: "비밀번호")
                    HStack {
                        Text("권한")
                        Spacer()
                        Picker("",selection: $level) {
                            ForEach(Administrator.Level.allCases) { level in
                                Text(level.levelString)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                    HStack{
                        Spacer()
                        Button {
                            //디비에 저장
                            adminStore.addAdminData(adminID: idString, password: passwordString, level: level, adminName: nameString, profileUrlString: "")
                            
                            if adminStore.addAccount(admin: .init(adminID: idString, password: passwordString, level: level, adminName: nameString, profileUrlString: "")) {
                                isPresented = false
                            } else {
                                isOverlap = true
                            }
                        } label: {
                            Text("완료")
                        }
                        .disabled(
                            nameString == "" ||
                            idString == "" ||
                            passwordString == ""
                        )
                        .multilineTextAlignment(.trailing)
                    }
                }
                .font(.title2)
                .padding(.vertical)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        isPresented = false
                    }
                }
            }
        }
        .alert("중복된 아이디입니다.", isPresented: $isOverlap) {
            Button("확인") {
                
            }
        }
    }
}

struct AdminRegisterView_Previews: PreviewProvider {
    static var adminStore: AdministratorStore = .init()
    static var previews: some View {
        AdminRegisterView(level: .constant(.employee), isPresented: .constant(true))
            .environmentObject(adminStore)
            .onAppear {
                adminStore.fetchAccount()
            }
    }
}
