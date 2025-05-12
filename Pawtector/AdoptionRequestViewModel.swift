import Foundation
import FirebaseFirestore

class AdoptionRequestViewModel: ObservableObject {
    @Published var requests: [AdoptionRequest] = []

    private let db = Firestore.firestore()

    func fetchRequests(for userId: String) {
        db.collection("AdoptionRequest")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching adoption requests: \(error.localizedDescription)")
                    return
                }

                print("Fetched adoption request docs:")
                snapshot?.documents.forEach { doc in
                    print(doc.documentID, doc.data())
                }

                self.requests = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    guard
                        let userId = data["userId"] as? String,
                        let petId = data["petId"] as? String,
                        let status = data["status"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp
                    else {
                        return nil
                    }

                    // Use existing 'rid' if available, otherwise fall back to document ID
                    let rid = data["rid"] as? String ?? doc.documentID

                    return AdoptionRequest(
                        id: doc.documentID,
                        rid: rid,
                        userId: userId,
                        petId: petId,
                        status: status,
                        timestamp: timestamp.dateValue()
                    )
                } ?? []
            }
    }
}
