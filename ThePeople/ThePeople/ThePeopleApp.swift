//
//  ThePeopleApp.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 26.04.2023.
//

import SwiftUI

@main
struct ThePeopleApp: App {
    var body: some Scene {
        WindowGroup {
            // tabView is used to make a bottom bar with navigation buttons
            TabView {
                PeopleView()
                    .tabItem {
                        Symbols.person
                        Text("Home")
                    }
            }
        }
    }
}
