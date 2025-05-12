import Foundation

struct UserModel: Identifiable, Codable {
    var id: String { uid }
    let uid: String
    let email: String
    let username: String
    let phone: String
    let createdAt: Date
    var favorites: [String] = []
}
