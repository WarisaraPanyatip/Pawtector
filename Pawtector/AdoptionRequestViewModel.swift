import Foundation
import FirebaseAuth
import FirebaseFirestore

class AdoptionRequestViewModel: ObservableObject {
    @Published var requests: [AdoptionRequest] = []

    private let db = Firestore.firestore()

    func fetchRequests(for userId: String) {
        db.collection("RequestAdoption")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching adoption requests: \(error.localizedDescription)")
                    return
                }

                self.requests = snapshot?.documents.compactMap { doc in
                    try? doc.data(as: AdoptionRequest.self)
                } ?? []
            }
    }
}
