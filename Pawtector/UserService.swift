//handle writing to Firestore

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    private let db = Firestore.firestore()

    func createUserInFirestore(user: User, username: String, phone: String) {
        let newUser = UserModel(
            uid: user.uid,
            email: user.email ?? "",
            username: username,
            phone: phone,
            createdAt: Date()
        )

        do {
            try db.collection("users").document(user.uid).setData(from: newUser)
            print("User saved to Firestore")
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
}
