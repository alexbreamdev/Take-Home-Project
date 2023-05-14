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
    
    @State private var users: [User] = []
    
    var body: some View {

        NavigationStack {
            ZStack {
                background
                
                // to make scrollable embed in ScrollView
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(users) { user in
                            NavigationLink(value: user) {
                                PersonItemView(user: user)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationDestination(for: User.self) { user in
                DetailView()
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                   create
                }
            }
            .onAppear {
                do {
                    users = try StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self).data
                } catch {
                    print("Can't load users")
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
