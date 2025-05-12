import FirebaseFirestore
import Foundation

struct Pet: Identifiable, Codable {
    @DocumentID var id: String?
    let ageDescription: Float32
    let background: String
    let breed: String
    let gender: String
    let healthStatus: String
    let imageName: String
    let location: String
    let name: String
    let personality: String
    let pid: String
    let status: Bool
    let trainingStatus: String
    let type: String
    var uuid: UUID? { UUID(uuidString: pid) }

    enum CodingKeys: String, CodingKey {
        case id
        case ageDescription = "AgeDescription"
        case background, breed, gender, healthStatus
        case imageName, location, name, personality, pid
        case status, trainingStatus, type
    }
}
