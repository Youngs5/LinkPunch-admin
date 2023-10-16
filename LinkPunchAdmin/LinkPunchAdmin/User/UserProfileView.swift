//
//  UserProfileView.swift
//  LinkPunchAdmin
//
//  Created by 김성준 on 2023/08/23.
//

import SwiftUI

struct UserProfileView: View {
    let userInfo: NewUser
    
    var body: some View {
        HStack(spacing: 25) {
            if let userImage = userInfo.userImage {
                AsyncImage(url: URL(string: userImage)) { image in
                    image
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 150))
            }
            
            HStack() {
                VStack(alignment: .leading){
                    Group{
                        HStack{
                            VStack{
                                Text("이름")
                                    .padding(.top, 12)
                                Divider()
                                Text("닉네임")
                                    .padding(.top, 7)
                                Divider()
                                Text("이메일")
                                    .padding(.top, 7)
                                Divider()
                                Text("가입날짜")
                                    .padding(.top, 7)
                                Divider()
                                Text("신고받은 횟수")
                                    .padding(.top, 7)
                                    .padding(.bottom, 12)
                            }
                            .frame(width: 200)
                            .background(.gray.opacity(0.5))
                           
                            VStack(alignment: .leading){
                                Text(userInfo.name ?? "")
                                    .padding(.top, 12)
                                    .padding(.leading, 5)
                                Divider()
                                Text(userInfo.userNickName ?? "")
                                    .padding(.top, 7)
                                    .padding(.leading, 5)
                                Divider()
                                Text(userInfo.userEmail ?? "")
                                    .padding(.top, 7)
                                    .padding(.leading, 5)
                                Divider()
                                Text(userInfo.signUpDate ?? "")
                                    .padding(.top, 7)
                                    .padding(.leading, 5)
                                Divider()
                                Text("\(userInfo.report?.reportedCount.total ?? 0)")
                                    .padding(.top, 7)
                                    .padding(.leading, 5)
                                    .padding(.bottom, 12)
                            }
                        }
                    }
                    .padding(2)
                }
            }
        }
        .padding(.top)
        .frame(maxWidth: .infinity)
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(userInfo: NewUser())
    }
}
