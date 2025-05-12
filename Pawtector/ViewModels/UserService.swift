import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    private let db = Firestore.firestore()

    // MARK: - Create New User
    func createUserInFirestore(user: User, username: String, phone: String) {
        let newUser = UserModel(
            uid: user.uid,
            email: user.email ?? "",
            username: username,
            phone: phone,
            createdAt: Date(),
            favorites: []
        )

        do {
            try db.collection("users").document(user.uid).setData(from: newUser)
            print("User saved to Firestore")
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }

    // MARK: - Update Favorites
    func updateFavorite(for userID: String, petID: String, isAdding: Bool) {
        let userRef = db.collection("users").document(userID)

        if isAdding {
            userRef.updateData([
                "favorites": FieldValue.arrayUnion([petID])
            ]) { error in
                if let error = error {
                    print("Failed to add favorite: \(error.localizedDescription)")
                } else {
                    print("Added pet \(petID) to favorites.")
                }
            }
        } else {
            userRef.updateData([
                "favorites": FieldValue.arrayRemove([petID])
            ]) { error in
                if let error = error {
                    print("Failed to remove favorite: \(error.localizedDescription)")
                } else {
                    print("Removed pet \(petID) from favorites.")
                }
            }
        }
    }

    // MARK: - Fetch Favorites
    func fetchFavorites(for userID: String, completion: @escaping ([String]) -> Void) {
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch favorites: \(error.localizedDescription)")
                completion([])
                return
            }

            if let data = snapshot?.data(),
               let favorites = data["favorites"] as? [String] {
                completion(favorites)
            } else {
                completion([])
            }
        }
    }
}
