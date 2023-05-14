//
//  DetailView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 14.05.2023.
//

import SwiftUI

struct DetailView: View {
    var body: some View {
        ZStack {
            background
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    
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
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}

private extension DetailView {
    var background: some View {
        Theme.background.edgesIgnoringSafeArea(.top)
    }
}

private extension DetailView {
    
    var general: some View {
        VStack(alignment: .leading, spacing: 8) {
            PillView(id: 0)
            Group {
                firstName
                lastName
                email
            }
            .foregroundColor(Theme.text)
        }
    }
    
    var link: some View {
        Link(destination: URL(string: "https://reqres.in/#support-heading")!) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Support Reqres")
                    .foregroundColor(Theme.text)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.semibold)
                
                Text("https://reqres.in/#support-heading")
            }
            
            Spacer()
            
            Symbols.link
                .font(.system(.title3, design: .rounded))
        }
    }
    
    @ViewBuilder
    var firstName: some View {
        Text("First Name")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text("First Name Here")
            .font(.system(.subheadline, design: .rounded))
        Divider()
    }
    
    @ViewBuilder
    var lastName: some View {
        Text("Last Name")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text("First Name Here")
            .font(.system(.subheadline, design: .rounded))
        Divider()
    }
    
    @ViewBuilder
    var email: some View {
        Text("Email")
            .font(.system(.body, design: .rounded))
            .fontWeight(.semibold)
        
        Text("First Name Here")
            .font(.system(.subheadline, design: .rounded))
        Divider()
    }
}
