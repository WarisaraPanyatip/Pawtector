import Foundation
import FirebaseFirestore

class LostReportModel: ObservableObject {
    @Published var lostPets: [LostPet] = []

    private let db = Firestore.firestore()

    func fetchLostReports() {
        db.collection("LostReport").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching: \(error.localizedDescription)")
                return
            }

            self.lostPets = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                guard let pid = data["pid"] as? String,
                      let name = data["name"] as? String,
                      let type = data["type"] as? String,
                      let breed = data["breed"] as? String,
                      let gender = data["gender"] as? String,
                      let age = data["age"] as? Float,
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
                      let wearing = data["wearing"] as? String else {
                    return nil
                }

                return LostPet(
                    pid: pid,
                    name: name,
                    type: type,
                    breed: breed,
                    gender: gender,
                    age: age,
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
        }
    }
}
