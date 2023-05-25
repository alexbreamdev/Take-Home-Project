//
//  CreateView.swift
//  ThePeople
//
//  Created by Oleksii Leshchenko on 15.05.2023.
//

import SwiftUI
// MARK: - Create new person and send it to API with this form
// 1.Use @focusState to leave textField and disable AttributeGraph warning
struct CreateView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusField: Field?
    @ObservedObject var createViewModel = CreateViewModel()
    let successfulAction: () -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    firstName
                    lastName
                    job
                    
                } footer: {
                    // Check if error of type FormError.validation
                    if case .validation(let error) = createViewModel.error,
                       // Unwrap errorDescription string optional
                       let errorDescription = error.errorDescription {
                        Text(errorDescription)
                            .foregroundStyle(.red)
                    }
                }
                Section {
                    submit
                    
                }
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
                    successfulAction()
                }
            }
            .alert(isPresented: $createViewModel.hasError, error: createViewModel.error) {}
            .overlay {
                if createViewModel.state == .submitting {
                    ProgressView()
                }
            }
            .disabled(createViewModel.state == .submitting)

        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateView {}
            
        }
    }
}

extension CreateView {
    // enum cases for @FocusState
    enum Field: Hashable {
        case firstName
        case lastName
        case job
    }
}

// MARK: - Subviews
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
            .focused($focusField, equals: Field.firstName)
    }
    
    var lastName: some View {
        TextField("Last Name", text:  $createViewModel.person.lastName)
            .focused($focusField, equals: Field.lastName)
    }
    
    var job: some View {
        TextField("Job", text:  $createViewModel.person.job)
            .focused($focusField, equals: Field.job)
    }
    
    var submit: some View {
        Section {
            Button {
                focusField = nil
                createViewModel.create()
            } label: {
                Text("Submit")
            }
        }
    }
    
}
