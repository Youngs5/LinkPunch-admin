//
//  ContentView.swift
//  ProjectAMock
//
//  Created by gnksbm on 2023/08/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PostView()
            UserView()
            AdminView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var store = AdministratorStore()
    
    static var previews: some View {
        ContentView()
            .environmentObject(store)
            .onAppear {
                store.fetchAccount()
            }
            .environmentObject(AdministratorStore())
            
    }
}
