//
//  LogInView.swift
//  LinkPunchAdmin
//
//  Created by Jisoo HAM on 2023/08/22.
//

import SwiftUI

struct LogInView: View {
    //MARK: - Properties
    
    @StateObject var adminStore: AdministratorStore = AdministratorStore()
    
    @State private var emailString: String = "adminm"
    @State private var passwordlString: String = "1"
    @State private var isShowingAlert: Bool = false
    
    @State private var isLoadData: Bool = false
    private var isAvailable: Bool {
        return emailString == "" || passwordlString == "" || !isLoadData ? false : true
    }
    
    var body: some View {
        if adminStore.loginedAdmin != nil {
            ContentView()
                .environmentObject(adminStore)
        } else {
            NavigationStack {
                VStack {
                    Image("Logo_Admin")
                        .resizable()
                        .frame(width: 190, height: 190)
                        .cornerRadius(20)
                        .padding(.bottom, 60)
                    Text("관리자용 앱 로그인")
                        .font(.largeTitle)
                        .padding(.bottom, 80)
                    VStack {
                        HStack {
                            Image(systemName: "envelope")
                                .resizable()
                                .frame(width: 20, height: 15)
                            TextField("Email", text: $emailString)
                                .font(.title)
                                .frame(width: 380)
                                .textInputAutocapitalization(.never)
                        }
                        Divider()
                            .frame(width: 450)
                        HStack {
                            Image(systemName: "key")
                                .resizable()
                                .frame(width: 15, height: 20)
                            
                            SecureField("Password", text: $passwordlString)
                                .font(.title)
                                .frame(width: 380)
                        }
                        Divider()
                            .frame(width: 450)
                            .padding(.bottom, 30)
                        Button {
                            isShowingAlert = !adminStore.checkAccount(id: emailString, pw: passwordlString)
                            emailString = ""
                            passwordlString = ""
                        } label: {
                            Text("Log in")
                                .cornerRadius(5)
                                .font(.title2)
                                .frame(width: 250, height: 50)
                        }
                        .disabled(!isAvailable)
                        .buttonStyle(.borderedProminent)
                        .alert("로그인 실패", isPresented: $isShowingAlert) {
                            Button("확인", role: .cancel) {
                                print("로그인 실패 alert")
                            }
                        }
                    }
                }
                .padding()
            }
            .onAppear{
                adminStore.fetchAccount()
                adminStore.fetchAdminData { success in
                    if success {
                        isLoadData = true
                    }
                }
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
