//
//  AdminDetailRowView.swift
//  LinkPunchAdmin
//
//  Created by Jisoo HAM on 2023/08/28.
//

import SwiftUI

struct AdminDetailRowView: View {

    @Binding var textFieldValue: String
    
    let title : String

    var body: some View {
        HStack {
            Text("\(title)")
            Spacer()
            TextField("\(title)을 입력하세요", text: $textFieldValue)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct AdminDetailRowView_Previews: PreviewProvider {
    static var previews: some View {
        AdminDetailRowView(textFieldValue: .constant("Master"), title: "이름")
    }
}
