import Foundation
import Firebase
import Combine
import Observation


@Observable
class DogDataViewModel {
    var getList: [DogModel] = []
    var breed: String = ""
    var id: String = ""
    
    var showEditSheet = false
    var showAddSheet: Bool = false
    var addedDataSuccess: Bool = false
    var editedDataSuccess: Bool = false
    var deletedDataSuccess: Bool = false
    var isSaving: Bool = false
    var isEditing: Bool = false
    var isDeleting: Bool = false
    
    private var listener: ListenerRegistration?
    private let dataUpdated = PassthroughSubject<Void, Never>()
    
    var selectedDog: DogModel?
    
    init() {
        fetchRealTimeData()
    }
    
    deinit {
        listener?.remove()
    }
    
    func fetchRealTimeData() {
        let db = Firestore.firestore()
        listener = db.collection("Dog").addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            
            var dogs: [DogModel] = []
            for document in snapshot.documents {
                let values = document.data()
                let id = values["id"] as? String ?? ""
                let breed = values["breed"] as? String ?? ""
                dogs.append(DogModel(id: id, breed: breed))
            }
            
            DispatchQueue.main.async {
                self.getList = dogs
                self.dataUpdated.send()
            }
        }
    }
    
    func addData(dogBreed: String, ids: String) {
        DispatchQueue.main.async {
            self.isSaving = true   // 👈 UI reacts immediately
        }
        
        let db = Firestore.firestore()
        let ref = db.collection("Dog").document(ids)
        ref.setData(["breed": dogBreed, "id": ids]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error adding: \(error.localizedDescription)")
                    self.isSaving = false
                } else {
                    self.addedDataSuccess = true
                    self.isSaving = false
                }
            }
        }
    }

    
    func updateData(dog: DogModel) {
        DispatchQueue.main.async {
            self.isEditing = true
        }
        let db = Firestore.firestore()
        let ref = db.collection("Dog").document(dog.id)
        ref.updateData(["breed": dog.breed]) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error updating: \(error.localizedDescription)")
                    self.isEditing = false
                }
                else {
                    self.editedDataSuccess = true
                    self.isEditing = false
                }
            }
        }
    }
    
    func deleteData(dog: DogModel) {
        DispatchQueue.main.async {
            self.isDeleting = true   // 👈 show loader if you want
        }
        let db = Firestore.firestore()
        let ref = db.collection("Dog").document(dog.id)
        
        ref.delete { error in
            DispatchQueue.main.async {
                if error != nil {
                    self.isDeleting = false
                } else {
                    if let index = self.getList.firstIndex(where: { $0.id == dog.id }) {
                        self.getList.remove(at: index)
                    }
                    self.deletedDataSuccess = true
                    
                }
                self.isDeleting = false
            }
        }
    }

}
