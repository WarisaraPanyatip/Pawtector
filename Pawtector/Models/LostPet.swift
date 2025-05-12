import Foundation

struct LostPet: Identifiable {
    var id: String { pid }

    let pid: String
    let user_id: String 
    let name: String
    let type: String
    let breed: String
    let gender: String
    let age: Float
    let imageName: String
    let healthStatus: String
    let personality: String
    let status: Bool
    let reward: String
    let lastSeen: String
    let description: String
    let contact: String
    let color: String
    let size: String
    let wearing: String
}
