import Foundation
import FirebaseFirestoreSwift

struct AdoptionRequest: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    let petId: String
    let status: String
    let timestamp: Date
}
