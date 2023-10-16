//
//  PostSidebar.swift
//  ProjectAMock
//
//  Created by gnksbm on 2023/08/21.
//

import SwiftUI

enum PostSidebar: CaseIterable {
    case all, report, hidden
    
    var id: Self { self }
    
    var subtitles: [String] {
        switch self {
        case .report:
            return ReportCase.allCases.map { $0.rawValue }
        case .all :
            return ["신고된 전체 게시물"]
        case .hidden:
            return ["숨겨진 게시물"]
        }
    }
}

extension PostSidebar: Identifiable {
    @ViewBuilder
    var label: some View {
        switch self {
        case .all :
        
            Label("신고된 전체 게시물", systemImage: "exclamationmark.octagon.fill")
            
        case .report:
            Label("항목별 신고된 게시물", systemImage: "list.bullet.clipboard")

            
        case .hidden:
            Label("숨겨진 게시물", systemImage: "eye.slash.fill")
        }
    }
    
    // 커스텀 뷰
//    @ViewBuilder
//    var destination: some View {
//        switch self {
//        case .report:
//            PostTableView(reportManager: ReportManager())
//        case .hidden:
//            Text("숨겨진 게시물")
//        }
//    }
}
