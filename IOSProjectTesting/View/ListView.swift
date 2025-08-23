import SwiftUI

struct ListView: View {
    
    @State private var dataManager = DogDataViewModel()
    @State var loginVM = LoginVM()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataManager.getList, id: \.id) { dog in
                    Text(dog.breed)
                        .swipeActions {
                            Button("Edit") {
                                dataManager.selectedDog = dog
                                dataManager.showEditSheet = true
                            }
                            .tint(.blue)
                            
                            Button("Delete") {
                                dataManager.deleteData(dog: dog)
                            }
                            .tint(.red)
                        }
                }
            }
            .navigationTitle("Animals")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        loginVM.logout()
                    } label: {
                        Text("Logout")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dataManager.showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $dataManager.showAddSheet) {
                AddDataView()
            }
            .sheet(isPresented: $dataManager.showEditSheet) {
                if let dogToEdit = dataManager.selectedDog {
                    EditDataView(dog: dogToEdit, viewModel: dataManager)
                }
            }
            .alert("Deleted Successfully!", isPresented: $dataManager.deletedDataSuccess) {
                Button("OK") {

                }
            }
            .overlay(alignment: .bottom) {
                if loginVM.showToast {
                    Text("✅ Logged In!")
                        .padding()
                        .background(.green.opacity(0.8))
                        .cornerRadius(8)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                loginVM.showToast = false
                            }
                        }
                }
            }
        }
    }
}
