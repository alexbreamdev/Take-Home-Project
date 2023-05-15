//
//  CreateView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 15.05.2023.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Form {
                firstName
                lastName
                job
                submit
            }
            .navigationTitle("Create")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                  done
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateView()
            
        }
    }
}


private extension CreateView {
    var done: some View {
        Button {
            dismiss()
        } label: {
            Text("Done")
        }
    }
    
    var firstName: some View {
        TextField("First Name", text: .constant(""))
    }
    
    var lastName: some View {
        TextField("Last Name", text: .constant(""))
    }
    
    var job: some View {
        TextField("Job", text: .constant(""))
    }
    
    var submit: some View {
        Section {
            Button {
                
            } label: {
                Text("Submit")
            }
        }
    }
    
}
