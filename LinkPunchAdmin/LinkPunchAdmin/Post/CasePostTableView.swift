//
//  CasePostTableView.swift
//  LinkPunchAdmin
//
//  Created by 남현정 on 2023/08/28.
//

import SwiftUI

struct CasePostTableView: View {
    @ObservedObject var reportStore: ReportStore

    var selectedReport: ReportCase
    
    var filteredList: [StudyRecruitment] {
        switch selectedReport {
        case .unrelated :
            return reportStore.reportedArray.filter { $0.reportCountInfo?.unrelatedCount ?? 0 > 0 }
        case .spamFlagging :
            return reportStore.reportedArray.filter { $0.reportCountInfo?.spamFlaggingCount ?? 0 > 0 }
        case .obscenity :
            return reportStore.reportedArray.filter { $0.reportCountInfo?.obscenityCount ?? 0 > 0 }
        case .offensiveLanguage :
            return reportStore.reportedArray.filter { $0.reportCountInfo?.offensiveLanguageCount ?? 0 > 0 }
        case .etc:
            return reportStore.reportedArray.filter { $0.reportCountInfo?.etcCount ?? 0 > 0 }
        }
    }
    
    @State var searchTerm: String = ""
    
    //정렬
    var assign: [String] = ["최근신고순", "최근게시글순", "신고 많은 순"]
    @State var pickAssign: String = "최근신고순"
    
    //검색
    @State var searchString: String = ""
    var nicknameOrTitle: [String] = ["이름", "제목"]
    @State var pickSearch: String = "이름"
    var promptText: String {
        "\(pickSearch)을 입력하세요"
    }
    var searchedData: [StudyRecruitment] {
        reportStore.searchReportPost(filteredList, searchString, pickSearch)
    }
    
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
                Picker("assign", selection: $pickAssign) {
                    ForEach(assign, id:\.self) { item in
                        Text(item)
                            .font(.caption)
                    }
                }
                .pickerStyle(.segmented)
                .font(.caption)
                
            }.padding()
            
            Table(of: StudyRecruitment.self) {
                
                //숨김체크
                TableColumn("") { studyRecruitment in

                    Button {
                        if checkIDs.contains(studyRecruitment.id) {
                            checkIDs.remove(studyRecruitment.id)
                        }else {
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
                ForEach(reportStore.sortedArray(data: searchedData, pickAssign: pickAssign)) { report in
                  
                    TableRow(report)
                }
            }
            .foregroundColor(.primary)
            .toolbar{
                ToolbarItem (placement: .navigationBarLeading) {
                    
                    HStack {
                        Text("검색 필터")
                        //검색필터
                        Picker("nicknameOrTitle", selection: $pickSearch) {
                            ForEach(nicknameOrTitle,
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
            .searchable(text: $searchString, prompt: promptText)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CasePostTableView_Previews: PreviewProvider {
    static var previews: some View {
        CasePostTableView(reportStore: ReportStore(), selectedReport: .obscenity)
    }
}
