//
//  DetailView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 14.05.2023.
//

import SwiftUI

struct DetailView: View {
    let userId: Int
    @ObservedObject var detailViewModel = DetailViewModel()
    var body: some View {
        ZStack {
            background
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    avatar
                    
                    Group {
                        general
                        link
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 18)
                    .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .alert(isPresented: $detailViewModel.hasError, error: detailViewModel.error){}
        .onAppear {
            detailViewModel.fetchDetails(for: userId)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DetailView(userId: 1)
        }
    }
}

private extension DetailView {
    var background: some View {
        Theme.background.edgesIgnoringSafeArea(.top)
    }
}

private extension DetailView {
    
    @ViewBuilder
    var avatar: some View {
        if let avatarAbsString = detailViewModel.user?.avatar,
           let avatarURL = URL(string: avatarAbsString) {
            AsyncImage(url: avatarURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
    
    var general: some View {
        VStack(alignment: .leading, spacing: 8) {
            PillView(id: detailViewModel.user?.id ?? 0)
            Group {
                firstName
                lastName
                email
            }
            .foregroundColor(Theme.text)
        }
    }
    
    @ViewBuilder
    var link: some View {
        if let supportAbsString = detailViewModel.support?.url,
           let supportURL = URL(string: supportAbsString),
           let supportText = detailViewModel.support?.text {
            Link(destination: supportURL) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(supportText)
                        .foregroundColor(Theme.text)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    
                    Text(supportAbsString)
                }
                
                Spacer()
                
                Symbols.link
                    .font(.system(.title3, design: .rounded))
            }
        }
        else {
            EmptyView()
        }
    }
    
    @ViewBuilder
    var firstName: some View {
        Text("First Name")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text(detailViewModel.user?.firstName ?? "-")
            .font(.system(.subheadline, design: .rounded))
        Divider()
    }
    
    @ViewBuilder
    var lastName: some View {
        Text("Last Name")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text(detailViewModel.user?.lastName ?? "-")
            .font(.system(.subheadline, design: .rounded))
        Divider()
    }
    
    @ViewBuilder
    var email: some View {
        Text("Email")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text(detailViewModel.user?.email ?? "-")
            .font(.system(.subheadline, design: .rounded))
        Divider()
    }
}
