// Fetch and Store username
// Log out
// Remember me: auto-login

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SessionManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: UserModel?

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        listenForAuthChanges()
    }

    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    private func listenForAuthChanges() {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }

            if let user = user {
                self.isLoggedIn = true
                self.fetchUserData(uid: user.uid)
            } else {
                self.isLoggedIn = false
                self.currentUser = nil
            }
        }
    }

    private func fetchUserData(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] document, error in
            if let document = document, document.exists {
                do {
                    self?.currentUser = try document.data(as: UserModel.self)
                } catch {
                    print("Error decoding user data: \(error)")
                }
            } else {
                print("User document does not exist")
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            self.currentUser = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
