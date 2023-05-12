//
//  PersonItemView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 12.05.2023.
//

import SwiftUI

struct PersonItemView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: .zero) {
            AsyncImage(url: URL(string: user.avatar)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 130)
                    .clipped()
            } placeholder: {
                Image("logo")
            }
            
            VStack(alignment: .leading) {
                PillView(id: user.id)
                
                Text("\(user.firstName) \(user.lastName)")
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

struct PersonItemView_Previews: PreviewProvider {
    static var previews: some View {
        PersonItemView(user: try! StaticJSONMapper.decode(file: "SingleUserData", type: UserDetailResponse.self).data)
            .frame(width: 250)
    }
}
