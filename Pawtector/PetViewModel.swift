import Foundation
import FirebaseFirestore


class PetViewModel: ObservableObject {
    @Published var pets: [Pet] = []

    private let db = Firestore.firestore()

    init() {
        fetchPets()
    }

    func fetchPets() {
        db.collection("StrayPet").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching pets: \(error.localizedDescription)")
                return
            }

            self.pets = snapshot?.documents.compactMap { document in
                do {
                    let pet = try document.data(as: Pet.self)
                    return pet
                } catch {
                    print("⚠️ Decoding error: \(error.localizedDescription)")
                    return nil
                }
            } ?? []

            print("✅ Loaded \(self.pets.count) pets from Firestore")
        }
    }
}
