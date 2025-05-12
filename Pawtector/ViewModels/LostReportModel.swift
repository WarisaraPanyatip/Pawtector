import Foundation
import FirebaseFirestore

class LostReportModel: ObservableObject {
    @Published var lostPets: [LostPet] = []

    private let db = Firestore.firestore()

    init() {
        fetchLostReports()
    }

    func fetchLostReports() {
        db.collection("LostReport").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching lost reports: \(error.localizedDescription)")
                return
            }

            print("📦 Found \(snapshot?.documents.count ?? 0) documents")

            self.lostPets = snapshot?.documents.compactMap { doc -> LostPet? in
                let data = doc.data()
                print("🔍 Document: \(data)")

                guard let pid = data["pid"] as? String,
                      let user_id = data["user_id"] as? String,
                      let name = data["name"] as? String,
                      let type = data["type"] as? String,
                      let breed = data["breed"] as? String,
                      let gender = data["gender"] as? String,
                      let ageValue = data["age"] as? Double,
                      let imageName = data["imageName"] as? String,
                      let healthStatus = data["healthStatus"] as? String,
                      let personality = data["personality"] as? String,
                      let status = data["status"] as? Bool,
                      let reward = data["reward"] as? String,
                      let lastSeen = data["lastSeen"] as? String,
                      let description = data["description"] as? String,
                      let contact = data["contact"] as? String,
                      let color = data["color"] as? String,
                      let size = data["size"] as? String,
                      let wearing = data["wearing"] as? String
                else {
                    print("⚠️ Skipped document: missing or invalid field")
                    return nil
                }

                return LostPet(
                    pid: pid,
                    user_id: user_id,
                    name: name,
                    type: type,
                    breed: breed,
                    gender: gender,
                    age: Float(ageValue),
                    imageName: imageName,
                    healthStatus: healthStatus,
                    personality: personality,
                    status: status,
                    reward: reward,
                    lastSeen: lastSeen,
                    description: description,
                    contact: contact,
                    color: color,
                    size: size,
                    wearing: wearing
                )
            } ?? []

            print("✅ Final pet count: \(self.lostPets.count)")
        }
    }
}
