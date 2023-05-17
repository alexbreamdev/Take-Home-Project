//
//  PeopleView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 05.05.2023.
//

import SwiftUI

struct PeopleView: View {
    @State private var showCreateView: Bool = false
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
                
                NetworkingManager.shared.request("https://reqres.in/api/users", type: UsersResponse.self) { result in
                    switch result {
                    case .success(let response):
                        self.users = response.data
                    case .failure(let error):
                        print(error)
                    }
                }
            }
            .sheet(isPresented: $showCreateView) {
                  CreateView()
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
            showCreateView.toggle()
        } label: {
            Symbols.plus
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
        }
    }
}
