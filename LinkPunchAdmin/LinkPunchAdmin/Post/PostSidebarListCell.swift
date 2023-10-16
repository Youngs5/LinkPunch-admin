//
//  PostSidebarListCell.swift
//  ProjectAMock
//
//  Created by gnksbm on 2023/08/22.
//

import SwiftUI

struct PostSidebarListCell: View {
    var title: String
    var count: Int
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text("\(count)")
        }
    }
}

struct PostSidebarListCell_Previews: PreviewProvider {
    static var previews: some View {
        PostSidebarListCell(title: "Test", count: 0)
    }
}
