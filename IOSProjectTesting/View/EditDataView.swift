//
//  EditDataView.swift
//  IOSProjectTesting
//
//  Created by prashanth on 23/08/25.
//

import SwiftUI

struct EditDataView: View {

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State var dog: DogModel
    @Bindable var viewModel: DogDataViewModel

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Breed")) {
                    TextField("Breed", text: $dog.breed)
                }
            }
            .navigationTitle("Edit Dog")
            .navigationBarItems(trailing:          
            Button(action:{
                viewModel.updateData(dog: dog)
            }, label: {
                if viewModel.isEditing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Update")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            })
            )
            .alert("Updated Successfully!", isPresented: $viewModel.editedDataSuccess) {
                Button("OK") {
                    dismiss()
                }
            }
        }
    }
}

