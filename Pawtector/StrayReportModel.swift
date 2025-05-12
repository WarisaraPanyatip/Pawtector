import Foundation

struct StrayReport: Identifiable {
    var id: String { sid }

    let sid: String
    let petType: String
    let condition: String
    let description: String
    let location: String
    let dateTime: String
    let isStillThere: Bool
    let contact: String
    let imageName: String
    let user_id: String
    let createdAt: Date
}
