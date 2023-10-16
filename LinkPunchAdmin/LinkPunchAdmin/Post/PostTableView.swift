//
//  PostTableView.swift
//  ProjectAMock
//
//  Created by gnksbm on 2023/08/21.
//

import SwiftUI

struct PostTableView: View {
    @ObservedObject var reportStore: ReportStore
    @State var checkIDs: Set<String> = []
    var isCheckedID: Bool {
        if checkIDs.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        NavigationStack {
            HStack {
                Spacer()
                Text("정렬 기준")
                //정렬필터
                Picker("assign", selection: $reportStore.pickAssign) {
                    ForEach(reportStore.assign, id:\.self) { item in
                        Text(item)
                            .font(.caption)
                    }
                }
                .pickerStyle(.segmented)
                .font(.caption)
                
            }
            .padding()
            Table(of: StudyRecruitment.self) {
                
                //숨김체크
                TableColumn("") { studyRecruitment in
                    
                    Button {
                        if checkIDs.contains(studyRecruitment.id) {
                            checkIDs.remove(studyRecruitment.id)
                        } else {
                            checkIDs.insert(studyRecruitment.id)
                            print(checkIDs)
                        }
                    } label: {
                        Image(systemName:  checkIDs.contains(studyRecruitment.id) ? "checkmark.square.fill" : "square")
                    }
                    
                }
                .width(40)
                TableColumn("제목") { studyRecruitment in
                        NavigationLink {
                            PostDetailView(reportStore: reportStore, studyRecruitment: studyRecruitment, btnText: "숨김", btnFunction: reportStore.hideRecruitment)
                        } label: {
                            Text(studyRecruitment.title)
                        }
                        .foregroundColor(.accentColor)
                    }

                TableColumn("작성자"){ studyRecruitment in
                    Text(studyRecruitment.publisher.name ?? "")
                }
                .width(UIScreen.main.bounds.width / 8)
                
                TableColumn("게시 날짜", value: \.createdDateWithTime)
                
                TableColumn("신고접수일") { studyRecruitment in
                    Text(studyRecruitment.postReport?[0].reportedDate ?? "")
                }
                
            } rows: {
                ForEach(reportStore.pageArray) { report in
                    TableRow(report)
                }
            }
            .foregroundColor(.primary)
            .toolbar {
                ToolbarItem (placement: .navigationBarLeading) {
                    HStack {
                        Text("검색 필터")
                        //검색필터
                        Picker("nicknameOrTitle", selection: $reportStore.pickSearch) {
                            ForEach(reportStore.nicknameOrTitle,
                                    id:\.self) { item in
                                
                                Text(item)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    ZStack {
                        HStack {
                            ForEach(1...reportStore.pageCount, id: \.self) { pageNum in
                                Button("\(pageNum)") {
                                    reportStore.selectedPageNum = pageNum
                                    reportStore.fetchReportPost { _ in
                                        reportStore.setData()
                                    }
                                }
                                .disabled(pageNum == reportStore.selectedPageNum)
                                .foregroundColor(pageNum == reportStore.selectedPageNum ? .black : .accentColor)
                            }
                        }
                        HStack {
                            Spacer()
                            if !isCheckedID {
                                Button {
                                    reportStore.hideRecruitment(checkIDs: checkIDs)
                                    checkIDs = []
                                } label: {
                                    Text("선택된 게시물 숨기기")
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                                }
                                .buttonStyle(.borderedProminent)
                                
                            }
                        }
                    }
                    .frame(height: 120)
                }
            }
            .searchable(text: $reportStore.searchString, prompt: reportStore.promptText)
            .navigationBarTitleDisplayMode(.inline)
            
        }
    }
}

struct PostTableView_Previews: PreviewProvider {
    @ObservedObject static var reportStore = ReportStore()
    static var previews: some View {
        NavigationStack {
            PostTableView(reportStore: reportStore)
        }
        .onAppear {
            reportStore.fetchReportPost { _ in
                reportStore.setData()
            }
        }
    }
}
