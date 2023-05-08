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
                Theme.background.edgesIgnoringSafeArea([.top])
                
                // to make scrollable embed in ScrollView
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(1..<10, id: \.self) { item in
                            VStack(spacing: .zero) {
                              Rectangle()
                                    .fill(.blue)
                                    .frame(height: 130)
                                
                                VStack(alignment: .leading) {
                                    Text("#\(item)")
                                        .font(.system(.caption, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 9)
                                        .padding(.vertical, 4)
                                        .background(Theme.pill, in: Capsule())
                                    
                                    Text("<First Name> <Last Name>")
                                        .foregroundColor(Theme.text)
                                        .font(.system(.body, design: .rounded))
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(Theme.detailBackground)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .shadow(color: Theme.text.opacity(0.1), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        Symbols.plus
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
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
