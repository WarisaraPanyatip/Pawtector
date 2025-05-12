import Foundation

struct AdoptionRequest: Identifiable, Codable {
    var id: String
    let rid: String  
    let userId: String
    let petId: String
    let status: String
    let timestamp: Date
}
