import SwiftUI

struct AddDataView: View {
    
    @State var dataManager = DogDataViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Form {
                    Section(header: Text("")) {
                        TextField("Dog Name", text: $dataManager.breed)
                        
                        TextField("ID", text: $dataManager.id)
//                            .disabled(true)
                            .foregroundColor(.gray)
                    }
                }

                Button(action: {
                    dataManager.addData(dogBreed: dataManager.breed, ids: dataManager.id)
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                            .frame(height: 50)

                        if dataManager.isSaving {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Save")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding(.horizontal)
                .disabled(dataManager.isSaving)

                Spacer()
            }
            .padding(.top)
            .navigationTitle("Add Dog")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Saved Successfully!", isPresented: $dataManager.addedDataSuccess) {
                Button("OK") {
                    dismiss()
                    dataManager.breed = ""
                    dataManager.id = "";
                }
            }
        }
    }
}

#Preview {
    AddDataView()
}
