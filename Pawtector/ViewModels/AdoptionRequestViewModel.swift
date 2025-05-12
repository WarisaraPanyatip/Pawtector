import Foundation
import FirebaseFirestore

class AdoptionRequestViewModel: ObservableObject {
    @Published var requests: [AdoptionRequest] = []

    private let db = Firestore.firestore()

    func fetchRequests(for userId: String) {
        db.collection("AdoptionRequest")
            .whereField("userId", isEqualTo: userId)
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] snapshot, error in
                if let error = error {
                    print("❌ Error fetching adoption requests: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No adoption request documents found.")
                    return
                }

                var tempRequests: [AdoptionRequest] = []
                let group = DispatchGroup()

                for doc in documents {
                    let data = doc.data()

                    guard
                        let userId = data["userId"] as? String,
                        let petId = data["petId"] as? String,
                        let status = data["status"] as? String,
                        let timestamp = data["timestamp"] as? Timestamp
                    else {
                        print("⚠️ Skipping malformed document: \(doc.documentID)")
                        continue
                    }

                    let rid = data["rid"] as? String ?? doc.documentID
                    var petName = "Unknown Pet"

                    group.enter()
                    self?.db.collection("StrayPet").document(petId).getDocument { petDoc, error in
                        if let petData = petDoc?.data(), let name = petData["name"] as? String {
                            petName = name
                        }

                        let request = AdoptionRequest(
                            id: doc.documentID,
                            rid: rid,
                            userId: userId,
                            petId: petId,
                            petName: petName,
                            status: status,
                            timestamp: timestamp.dateValue()
                        )

                        tempRequests.append(request)
                        group.leave()
                    }
                }

                group.notify(queue: .main) {
                    self?.requests = tempRequests
                }
            }
    }
}
