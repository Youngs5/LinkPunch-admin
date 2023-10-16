//
//  PostSidebarList.swift
//  ProjectAMock
//
//  Created by gnksbm on 2023/08/21.
//

import SwiftUI

struct PostSidebarList: View {
    @ObservedObject var reportStore: ReportStore = ReportStore()
    
    @State var isLoading: Bool = false
    
    var body: some View {
        List(PostSidebar.allCases) { postSiderbar in
            
            //데이터불러오기전까지는 로딩프로그레스뷰 띄워주기
            if !isLoading {
                ProgressView("Loading...")
                
            } else {
                Section {
                    ForEach(postSiderbar.subtitles, id: \.self) { subtitle in
                        NavigationLink {
                            switch postSiderbar {
                            case .all : //이것도 나눠야 할까여?
                                //                            HiddenPostTableView(reportStore: reportStore)
                                
                                PostTableView(reportStore: reportStore)
                                    .refreshable {
                                        reportStore.fetchReportPost { success in
                                            //데이터를 받아왔다면
                                            if success {
                                                //isLoading값을 변경하여 프로그레스뷰 지우고 뷰그려주기
                                                reportStore.setData()
                                                isLoading = true
                                                print("신고된 게시물 수 \(reportStore.fetchedArray.count)")
                                            }
                                        }
                                    }
                                
                            case .report :
                                CasePostTableView(reportStore: reportStore, selectedReport: .init(rawValue: subtitle) ?? .obscenity)
                                    .refreshable {
                                        reportStore.fetchReportPost { success in
                                            //데이터를 받아왔다면
                                            if success {
                                                //isLoading값을 변경하여 프로그레스뷰 지우고 뷰그려주기
                                                reportStore.setData()
                                                isLoading = true
                                                print("신고된 게시물 수 \(reportStore.fetchedArray.count)")
                                            }
                                        }
                                    }
                            case .hidden :
                                HiddenPostTableView(reportStore: reportStore)
                                    .refreshable {
                                        reportStore.fetchReportPost { success in
                                            //데이터를 받아왔다면
                                            if success {
                                                //isLoading값을 변경하여 프로그레스뷰 지우고 뷰그려주기
                                                reportStore.setData()
                                                isLoading = true
                                                print("신고된 게시물 수 \(reportStore.fetchedArray.count)")
                                            }
                                        }
                                    }
                            }
                            
                        } label: {
                            switch postSiderbar {
                            case .all :
                                PostSidebarListCell(title: subtitle, count: reportStore.reportedArray.count)
                            case .report :
                                PostSidebarListCell(title: subtitle, count: reportStore.reportedListCountingByCase(postSidebar: postSiderbar, reportCase: subtitle))
                                //reportedListCountingByCase(rawValue: item)
                            case .hidden :
                                PostSidebarListCell(title: subtitle, count: reportStore.hiddenList.count)
                            }
                            
                            
                        }
                        
                    }
                } header: {
                    postSiderbar.label
                }
            }
        }
        .refreshable {
            reportStore.fetchReportPost { success in
                //데이터를 받아왔다면
                if success {
                    //isLoading값을 변경하여 프로그레스뷰 지우고 뷰그려주기
                    reportStore.setData()
                    isLoading = true
                    print("신고된 게시물 수 \(reportStore.fetchedArray.count)")
                }
            }
        }
        .onAppear {
            reportStore.fetchReportPost { success in
                //데이터를 받아왔다면
                if success {
                    //isLoading값을 변경하여 프로그레스뷰 지우고 뷰그려주기
                    reportStore.setData()
                    isLoading = true
                    print("신고된 게시물 수 \(reportStore.fetchedArray.count)")
                }
            }
        }
    }
}

struct PostSidebarList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PostSidebarList()
        }
    }
}
