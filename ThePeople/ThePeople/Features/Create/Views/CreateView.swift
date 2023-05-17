//
//  CreateView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 15.05.2023.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var createViewModel = CreateViewModel()
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
            .onChange(of: createViewModel.state) { formState in
                if formState == .successful {
                    dismiss()
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
        TextField("First Name", text: $createViewModel.person.firstName)
    }
    
    var lastName: some View {
        TextField("Last Name", text:  $createViewModel.person.lastName)
    }
    
    var job: some View {
        TextField("Job", text:  $createViewModel.person.job)
    }
    
    var submit: some View {
        Section {
            Button {
                createViewModel.create()
            } label: {
                Text("Submit")
            }
        }
    }
    
}
