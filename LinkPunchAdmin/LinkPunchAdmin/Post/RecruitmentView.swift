//
//  TestView.swift
//  LinkPunchAdmin
//
//  Created by 남현정 on 2023/08/23.
//

import SwiftUI

struct RecruitmentView: View {
    let studyRecruitment: StudyRecruitment
    
    var body: some View {
        VStack(alignment: .leading){
            List {
                Section {
                    VStack(alignment: .leading) {
                        Group {
                            HStack {
                                Text("제목: \(studyRecruitment.title)")
                                    .font(.title2)
                                    .bold()
                            }
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
                            
                            HStack {
                                Text("작성 날짜:")
                                Text(studyRecruitment.createdDate)
                            }
                            
                            HStack {
                                Text("작성자 닉네임:")
                                Text(studyRecruitment.publisher.userNickName ?? "")
                            }
                            
                            HStack {
                                Text("작성자 이름:")
                                Text(studyRecruitment.publisher.name ?? "")
                            }
                            
                            HStack {
                                Text("작성자 메일 주소:")
                                Text(studyRecruitment.publisher.userEmail ?? "")
                            }
                            
                            HStack {
                                Text("분야:")
                                Text(studyRecruitment.field.rawValue)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        
                    }
                    .padding(EdgeInsets(top: 5, leading: 20, bottom: 10, trailing: 20))
                    Divider()
                }
                .listRowSeparator(.hidden)
                
                Section {
                    VStack(alignment: .leading) {
                        Text("게시글 내용")
                            .font(.title2)
                            .bold()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        Text("\(studyRecruitment.contents)")
                            .lineSpacing(5)
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                    Divider()
                }
                .listRowSeparator(.hidden)
                
                Section {
                    VStack(alignment: .leading) {
                        Text("참여자 목록")
                            .font(.title2)
                            .bold()
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                        ForEach(studyRecruitment.participants) { participant in
                            VStack(alignment: .leading) {
                                Group {
                                    HStack {
                                        Text("이름:")
                                        Text(participant.name ?? "")
                                    }
                                    
                                    HStack {
                                        Text("메일 주소:")
                                        Text(participant.userEmail ?? "")
                                    }
                                }
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                            }
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .cornerRadius(6)
                        }
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                    Divider()
                }
                .listRowSeparator(.hidden)
            }
            
            .listStyle(.plain)
        }
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden()
    }
    
}

struct RecruitmentView_Previews: PreviewProvider {
    static var previews: some View {
        RecruitmentView(studyRecruitment: .init(field: .AI, location: .init(latitude: 0, longitude: 0, address: ""), userName: "", userImgString: "", title: "", contents: "", applicantCount: 0, nowApplicant: 0, publisher: .init(), participants: []))
    }
}
