//
//  UserCvView.swift
//  LinkPunchAdmin
//
//  Created by yunjikim on 2023/08/23.
//

import SwiftUI

struct UserCvView: View {
    let userInfo: NewUser
    @State var isShowingCv: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("CV")
                    .font(.title3.bold())
                Spacer()
                Button {
                    isShowingCv.toggle()
                } label: {
                    Image(systemName: isShowingCv ? "chevron.down" : "chevron.up")
                }
            }
            
            Divider()
            
            if isShowingCv {
                ScrollView {
                    HStack {
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading) {
                                Text("관심 분야")
                                    .fontWeight(.bold)
                                HStack {
                                    ForEach(userInfo.fields ?? [], id: \.self) { field in
                                        Text("\(field)")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 15)
                                            .background(Color("SubColor"))
                                            .cornerRadius(20)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("선호 지역")
                                    .fontWeight(.bold)
                                HStack {
                                    ForEach(userInfo.location ?? [], id: \.self) { location in
                                        Text("\(location)")
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 15)
                                            .background(Color("SubColor"))
                                            .cornerRadius(20)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .padding(.top)
                            VStack(alignment: .leading) {
                                Text("프로젝트")
                                    .fontWeight(.bold)
                                VStack(alignment: .leading) {
                                    ForEach(userInfo.cv?.projects ?? []) { project in
                                        HStack {
                                            Text("\(project.title)")
                                                .font(.title2.bold())
                                            Spacer()
                                            Text("\(project.period)")
                                                .font(.callout)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.bottom, 5)
                                        Text("\(project.description)")
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(20)
                            }
                            .padding(.top)
                            VStack(alignment: .leading) {
                                Text("활동 내역")
                                    .fontWeight(.bold)
                                VStack(alignment: .leading) {
                                    ForEach(userInfo.cv?.activities ?? []) { activity in
                                        HStack {
                                            Text("\(activity.title)")
                                                .font(.title2.bold())
                                            Spacer()
                                            Text("\(activity.period)")
                                                .font(.callout)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.bottom, 5)
                                        Text("\(activity.description)")
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(20)
                            }
                            .padding(.top)
                            VStack(alignment: .leading) {
                                Text("자격증")
                                    .fontWeight(.bold)
                                VStack(alignment: .leading) {
                                    ForEach(userInfo.cv?.certifications ?? []) { certification in
                                        HStack {
                                            Text("\(certification.title)")
                                                .font(.title2.bold())
                                            Spacer()
                                            Text("\(certification.period)")
                                                .font(.callout)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.bottom, 5)
                                        Text("\(certification.description)")
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(Color.gray.opacity(0.5))
                                .cornerRadius(20)
                            }
                            .padding(.top)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(minHeight: 240, maxHeight: .infinity)
            }
        }
    }
}

struct UserCvView_Previews: PreviewProvider {
    static var previews: some View {
        UserCvView(userInfo: NewUser(), isShowingCv: true)
    }
}
