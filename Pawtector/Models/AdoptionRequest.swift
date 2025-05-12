import Foundation

struct AdoptionRequest: Identifiable {
    let id: String
    let rid: String
    let userId: String
    let petId: String
    let petName: String
    let status: String
    let timestamp: Date
}
