//
//  PeopleView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 05.05.2023.
//

import SwiftUI

struct PeopleView: View {
    // make columns for lazyVgrid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {

        NavigationStack {
            ZStack {
                background
                
                // to make scrollable embed in ScrollView
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(1..<10, id: \.self) { item in
                           PersonItemView(user: User(id: 1, email: "email", firstName: "Alex", lastName: "Bream", avatar: ""))
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                   create
                }
            }
            
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}

// MARK: - Subviews in PeopleView
extension PeopleView {
    var background: some View {
        Theme.background.edgesIgnoringSafeArea([.top])
    }
    
    var create: some View {
        Button {
            
        } label: {
            Symbols.plus
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
        }
    }
}
