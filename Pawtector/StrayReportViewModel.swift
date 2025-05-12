import Foundation
import FirebaseFirestore

class StrayReportViewModel: ObservableObject {
    @Published var reports: [StrayReport] = []

    private let db = Firestore.firestore()

    func fetchReports() {
        db.collection("StrayReport")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching stray reports: \(error.localizedDescription)")
                    return
                }

                self.reports = snapshot?.documents.compactMap { doc in
                    let data = doc.data()

                    guard let sid = data["sid"] as? String,
                          let petType = data["petType"] as? String,
                          let condition = data["condition"] as? String,
                          let description = data["description"] as? String,
                          let location = data["location"] as? String,
                          let dateTime = data["dateTime"] as? String,
                          let isStillThere = data["isStillThere"] as? Bool,
                          let contact = data["contact"] as? String,
                          let imageName = data["imageName"] as? String,
                          let user_id = data["user_id"] as? String,
                          let createdAtTimestamp = data["createdAt"] as? Timestamp
                    else {
                        print("⚠️ Skipped invalid report entry")
                        return nil
                    }

                    return StrayReport(
                        sid: sid,
                        petType: petType,
                        condition: condition,
                        description: description,
                        location: location,
                        dateTime: dateTime,
                        isStillThere: isStillThere,
                        contact: contact,
                        imageName: imageName,
                        user_id: user_id,
                        createdAt: createdAtTimestamp.dateValue()
                    )
                } ?? []

                print("✅ Loaded \(self.reports.count) stray reports")
            }
    }
}
