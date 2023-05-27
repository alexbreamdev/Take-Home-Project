//
//  PeopleView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 05.05.2023.
//

import SwiftUI

struct PeopleView: View {
    @State private var showCreateView: Bool = false
    @StateObject private var peopleVM = PeopleViewModel()
    @State private var shouldShowSuccess: Bool = false
    @State private var hasAppeared: Bool = false
    
    // make columns for lazyVgrid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {

        NavigationStack {
            ZStack {
                background
                
                if peopleVM.isLoading {
                    ProgressView()
                } else {
                    // to make scrollable embed in ScrollView
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(peopleVM.users) { user in
                                NavigationLink(value: user) {
                                    PersonItemView(user: user)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .refreshable {
                Task {
                    await peopleVM.fetchUsers()
                }
            }
            .navigationDestination(for: User.self) { user in
                DetailView(userId: user.id)
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                   create
                        .disabled(peopleVM.isLoading)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    refresh
                        .disabled(peopleVM.isLoading)
                }
            }
            .task {
                // fetch one time
                if hasAppeared == false {
                    await peopleVM.fetchUsers()
                    hasAppeared = true
                }
            }
            .sheet(isPresented: $showCreateView) {
                CreateView {
                    haptic(.success) // buzz on success
                    withAnimation(.spring().delay(0.25)) {
                        self.shouldShowSuccess.toggle()
                    }
                }
            }
            .alert(isPresented: $peopleVM.hasError, error: peopleVM.error) {
                Button {
                    Task {
                        await peopleVM.fetchUsers()
                    }
                } label: {
                    Text("Retry")
                }
            }
            .overlay {
                if shouldShowSuccess {
                    CheckmarkPopoverView()
                        .transition(.scale.combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.spring()) {
                                    self.shouldShowSuccess.toggle()
                                }
                            }
                        }
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
    
    var refresh: some View {
        Button {
            Task {
                await peopleVM.fetchUsers()
            }
        } label: {
            Symbols.refresh
                .font(.system(.headline, design: .rounded))
                .fontWeight(.bold)
        }
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
