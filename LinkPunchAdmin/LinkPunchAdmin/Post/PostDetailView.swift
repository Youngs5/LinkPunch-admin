//
//  PostDetailView.swift
//  ProjectAMock
//
//  Created by gnksbm on 2023/08/22.
//

import SwiftUI

struct PostDetailView: View {
    @ObservedObject var reportStore: ReportStore
    let studyRecruitment: StudyRecruitment
    var btnText: String
    var btnFunction: (Set<String>) -> Void
    
    @State var isAlert = false
    @State var isDeleteAlert = false
    
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        GeometryReader { geometry in
            HStack(alignment: .top) {
                VStack {
                    Form {
                        ForEach(studyRecruitment.postReport ?? []) { report in
                            Section {
                                VStack(alignment: .leading) {
                                    Group {
                                        Text("\u{2022} 신고자: \(report.reportedBy)")
                                        Text("\u{2022} 신고 날짜: \(report.reportedDate)")
                                    }
                                    .padding(EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3))
                                    HStack(alignment: .top, spacing: 0) {
                                        Text("\u{2022} 신고 사유: ")
                                            .frame(width: 85)
                                            .padding(EdgeInsets(top: 3, leading: 2, bottom: 3, trailing: 0))
                                        VStack(alignment: .leading) {
                                            ForEach(Array(report.reportcase.enumerated()), id: \.element) { (index, reportCase) in
                                                //                                                    Text("\(reportCase.rawValue)" + (index == report.reportcase.count - 1 ? "" : ","))
                                                Text(reportCase.rawValue)
                                            }
                                        }
                                        .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 3))
                                    }


                                    if !report.reportReason.isEmpty {
                                        HStack(alignment: .top, spacing: 0) {
                                            Text("\u{2022} 상세 신고 사유: ")
                                                .frame(width: 120)
                                                .padding(EdgeInsets(top: 3, leading: 2, bottom: 3, trailing: 0))
                                            Text(report.reportReason)
                                                .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 3))
                                        }
                                    }

                                }
                                .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width / 2)
                
                VStack {
                    RecruitmentView(studyRecruitment: studyRecruitment)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
        .toolbar {
            HStack() {
                Spacer()
                Button("\(btnText)") {
                    isAlert = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("삭제") {
                    isDeleteAlert = true
                }
                .buttonStyle(.bordered)
                .foregroundColor(.white)
                .background(.red)
                .cornerRadius(7)
            }
        }
        .alert(isPresented: $isAlert) {
            Alert(title: Text("\(btnText)"),
                  message: Text("\(btnText)처리 되었습니다."),
                  dismissButton: .default(Text("완료")) {
                btnFunction([studyRecruitment.id])
                dismiss()
            })
        }
        .alert("게시글이 삭제됩니다", isPresented: $isDeleteAlert) {
            Button("삭제", role: .destructive) {
                reportStore.deleteRecruitment(checkIDs: [studyRecruitment.id])
                reportStore.setData()
                dismiss()
            }
        }
        
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PostDetailView(reportStore: .init(), studyRecruitment: .init(field: .AI, location: .init(latitude: 0, longitude: 0, address: ""), userName: "", userImgString: "", title: "", contents: "", applicantCount: 0, nowApplicant: 0, publisher: .init(), participants: []), btnText: "") { _ in
                
            }
        }
    }
}
