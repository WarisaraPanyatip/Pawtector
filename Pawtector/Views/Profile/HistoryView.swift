//import SwiftUI
//
//struct HistoryView: View {
//    @Environment(\.dismiss) private var dismiss
//    @StateObject private var lostReportModel = LostReportModel()
//    @StateObject private var strayReportViewModel = StrayReportViewModel()
//    @StateObject private var requestViewModel = AdoptionRequestViewModel()
//    @EnvironmentObject var session: SessionManager
//    @EnvironmentObject var petViewModel: PetViewModel
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 0) {
//                header
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 20) {
//                        // Adoption
//                        Text("Adoption Requests")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(requestViewModel.requests) { request in
//                                    if let pet = petViewModel.pets.first(where: { $0.pid == request.petId }) {
//                                        HistoryTile(imageName: pet.imageName, title: pet.name, subtitle: "Age: \(formattedAge(pet.ageDescription))", status: request.status.capitalized, statusColor: .orange) {
//                                            AdoptionRequestDetailView(request: request)
//                                        }
//                                    }
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//
//                        // Lost Reports
//                        Text("Lost Pet Reports")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(lostReportModel.lostPets) { pet in
//                                    let imageName = pet.type == "Dog"
//                                        ? ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"].randomElement()!
//                                        : ["จี๊ด", "ส้มส้ม", "แหมว"].randomElement()!
//
//                                    HistoryTile(imageName: imageName, title: pet.name, subtitle: "Lost at \(pet.lastSeen)", status: pet.status ? "Found" : "Missing", statusColor: pet.status ? .green : .red) {
//                                        LostReportHistoryDetailView(pet: pet, model: lostReportModel)
//                                    }
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//
//                        // Stray Reports
//                        Text("Stray Reports")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(strayReportViewModel.reports) { report in
//                                    HistoryTile(imageName: report.imageName, title: report.petType, subtitle: "\(report.dateTime) @ \(report.location)", status: report.isStillThere ? "Not Rescued" : "Rescued", statusColor: report.isStillThere ? .red : .green) {
//                                        StrayReportDetailView(report: report)
//                                    }
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//                    }
//                }
//                .onAppear {
//                    petViewModel.fetchPets()
//                    strayReportViewModel.fetchReports()
//                    lostReportModel.fetchLostReports()
//                    if let uid = session.currentUser?.uid {
//                        requestViewModel.fetchRequests(for: uid)
//                    }
//                }
//            }
//            .navigationBarHidden(true)
//        }
//    }
//
//    var header: some View {
//        HStack {
//            Button(action: { dismiss() }) {
//                Image(systemName: "chevron.left")
//                    .font(.title2)
//                    .foregroundColor(.brandBrown)
//                    .padding(8)
//                    .background(Color.white)
//                    .clipShape(Circle())
//            }
//            Spacer()
//            VStack(alignment: .trailing) {
//                Text("History")
//                    .font(.title)
//                    .bold()
//                    .foregroundColor(.black)
//                Text("your adoption and reports")
//                    .font(.caption)
//                    .foregroundColor(.brandBrown)
//            }
//            Image("logo_black")
//                .resizable()
//                .frame(width: 60, height: 60)
//        }
//        .padding()
//    }
//
//    func formattedAge(_ age: Float) -> String {
//        if age < 1 {
//            let months = Int(round(age * 12))
//            return "\(months) mo"
//        } else {
//            return String(format: "%.1f yr%@", age, age == 1.0 ? "" : "s")
//        }
//    }
//}
//
//private struct HistoryTile<Content: View>: View {
//    let imageName: String
//    let title: String
//    let subtitle: String
//    let status: String
//    let statusColor: Color
//    let destination: () -> Content
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            VStack(spacing: 8) {
//                Image(imageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 180, height: 150)
//                    .clipped()
//                    .cornerRadius(12)
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(title)
//                        .font(.headline)
//                        .foregroundColor(.primary)
//                    Text(subtitle)
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//
//                    NavigationLink(destination: destination()) {
//                        Text("View")
//                            .font(.caption2).bold()
//                            .padding(.vertical, 4)
//                            .padding(.horizontal, 12)
//                            .background(Color.brandBlue)
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                            .padding(.top, 6)
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(12)
//            .shadow(radius: 4)
//
//            Text(status)
//                .font(.caption2)
//                .padding(6)
//                .background(statusColor)
//                .foregroundColor(.white)
//                .clipShape(Capsule())
//                .padding(8)
//        }
//        .frame(width: 200)
//    }
//}
//
//
//
//// MARK: - Lost Report Detail View with Found Button
//struct LostReportHistoryDetailView: View {
//    var pet: LostPet
//    @ObservedObject var model: LostReportModel
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 24) {
//                let imageName = pet.type == "Dog"
//                    ? ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"].randomElement()!
//                    : ["จี๊ด", "ส้มส้ม", "แหมว"].randomElement()!
//
//                Image(imageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 300)
//                    .cornerRadius(20)
//                    .clipped()
//
//                Text(pet.name)
//                    .font(.system(size: 32, weight: .bold))
//                    .foregroundColor(.brandBrown)
//
//                HStack(spacing: 16) {
//                    infoChip(icon: "pawprint.fill", text: pet.type)
//                    infoChip(icon: "calendar", text: "\(Int(pet.age)) yrs")
//                    infoChip(icon: pet.gender == "Male" ? "m.circle" : "f.circle", text: pet.gender)
//                    infoChip(icon: "dot.radiowaves.left.and.right", text: pet.breed)
//                }
//
//                Button(action: {
//                    model.markAsFound(petID: pet.pid)
//                    dismiss()
//                }) {
//                    Text("✅ Mark as Found")
//                        .font(.headline)
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.green)
//                        .foregroundColor(.white)
//                        .cornerRadius(12)
//                }
//
//                VStack(spacing: 12) {
//                    detailBlock(icon: "map.fill", title: "Last Seen", text: pet.lastSeen)
//                    detailBlock(icon: "eye", title: "Color", text: pet.color)
//                    detailBlock(icon: "scalemass", title: "Size", text: pet.size)
//                    detailBlock(icon: "tshirt.fill", title: "Wearing", text: pet.wearing)
//                    detailBlock(icon: "smiley.fill", title: "Personality", text: pet.personality)
//                    detailBlock(icon: "heart.fill", title: "Health", text: pet.healthStatus)
//                    detailBlock(icon: "doc.plaintext", title: "Description", text: pet.description)
//                }
//
//                Text("📞 \(pet.contact)")
//                    .font(.headline)
//                    .foregroundColor(.brandBlue)
//                    .padding(.top)
//            }
//            .padding()
//        }
//        .navigationTitle("Lost Pet Details")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//
//    private func infoChip(icon: String, text: String) -> some View {
//        VStack {
//            Image(systemName: icon)
//                .foregroundColor(.brandBlue)
//            Text(text).font(.caption)
//        }
//        .padding()
//        .frame(width: 70)
//        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.brandBrown))
//    }
//
//    private func detailBlock(icon: String, title: String, text: String) -> some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Image(systemName: icon).foregroundColor(.brandBrown)
//                Text(title).bold()
//            }
//            Text(text)
//        }
//        .padding()
//        .background(RoundedRectangle(cornerRadius: 12).fill(Color.brandBrown.opacity(0.1)))
//    }
//}
//
//struct AdoptionRequestDetailView: View {
//    let request: AdoptionRequest
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Adoption Request Details")
//                .font(.title2).bold()
//                .foregroundColor(.brandBrown)
//
//            HStack {
//                Image(systemName: "pawprint.fill")
//                Text("Pet ID: \(request.petId)")
//            }
//
//            HStack {
//                Image(systemName: "checkmark.seal.fill")
//                Text("Status: \(request.status.capitalized)")
//            }
//
//            HStack {
//                Image(systemName: "calendar")
//                Text("Requested on: \(request.timestamp.formatted(date: .abbreviated, time: .shortened))")
//            }
//
//            Spacer()
//        }
//        .padding()
//        .navigationTitle("Adoption Detail")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//import SwiftUI
//
//struct StrayReportDetailView: View {
//    let report: StrayReport
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                Image(report.imageName)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 200)
//                    .clipped()
//                    .cornerRadius(12)
//
//                Group {
//                    Text("\(report.petType) - \(report.condition)")
//                        .font(.title2)
//                        .bold()
//                        .foregroundColor(.brandBrown)
//
//                    Text("Description: \(report.description)")
//                    Text("Location: \(report.location)")
//                    Text("Reported at: \(report.dateTime)")
//                    Text("Still There?: \(report.isStillThere ? "Yes" : "No")")
//                }
//
//                Divider()
//
//                HStack {
//                    Image(systemName: "phone.fill")
//                        .foregroundColor(.brandBlue)
//                    Text("Contact: \(report.contact)")
//                        .foregroundColor(.brandBlue)
//                        .bold()
//                }
//
//                Spacer()
//            }
//            .padding()
//        }
//        .navigationTitle("Stray Detail")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//

import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var lostReportModel = LostReportModel()
    @StateObject private var strayReportViewModel = StrayReportViewModel()
    @StateObject private var requestViewModel = AdoptionRequestViewModel()
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var petViewModel: PetViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                header
//                ScrollView {
                    
  //                  VStack(alignment: .leading, spacing: 35) {
                        // Adoption
//                        Text("Adoption Requests")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(requestViewModel.requests) { request in
//                                    if let pet = petViewModel.pets.first(where: { $0.pid == request.petId }) {
//                                        HistoryTile(
//                                            imageName: pet.imageName,
//                                            title: pet.name,
//                                            subtitle: "Breed: \(pet.breed)\nAge: \(formattedAge(pet.ageDescription))",
//                                            status: request.status.capitalized,
//                                            statusColor: .orange,
//                                            destination: { AdoptionRequestDetailView(request: request) }
//                                        )
//                                    }
//                                }
//                            }
//                            .padding(.horizontal)
//                        }
//
//                        // Lost Reports
//                        Text("Lost Pet Reports")
//                            .font(.headline)
//                            .padding(.horizontal)
//                            .padding(.bottom, 10)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(lostReportModel.lostPets) { pet in
//                                    let imageName = pet.type == "Dog"
//                                        ? ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"].randomElement()!
//                                        : ["จี๊ด", "ส้มส้ม", "แหมว"].randomElement()!
//
//                                    HistoryTile(
//                                        imageName: imageName,
//                                        title: pet.name,
//                                        subtitle: "Lost at \(pet.lastSeen)",
//                                        status: pet.status ? "Found" : "Missing",
//                                        statusColor: pet.status ? .green : .red,
//                                        destination: { LostReportHistoryDetailView(pet: pet, model: lostReportModel) }
//                                    )
//                                }
//                            }
//                            .padding(.horizontal)
//                            .padding(.bottom, 10)
//                        }

                        // Stray Reports
//                        Text("Stray Reports")
//                            .font(.headline)
//                            .padding(.horizontal)
//
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 16) {
//                                ForEach(strayReportViewModel.reports) { report in
//                                    let imageName = ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"].randomElement()!
//
//                                    HistoryTile(
//                                        imageName: imageName,
//                                        title: "\(report.petType) - \(report.condition)",
//                                        subtitle: "\(report.dateTime)\n\(report.location)",
//                                        status: report.isStillThere ? "Not Rescued" : "Rescued",
//                                        statusColor: report.isStillThere ? .red : .green,
//                                        destination: { EmptyView() }
//                                    )
//                                }
//                            }
//                            .padding(.horizontal)
//                            .padding(.bottom, 10)
//                        }
//                    }
 //               }
                ScrollView {
                    VStack(alignment: .leading, spacing: 35) {
                        let userId = session.currentUser?.uid
                        let filteredRequests = requestViewModel.requests.filter { $0.userId == userId }
                        let filteredLost = lostReportModel.lostPets.filter { $0.user_id == userId }
                        let filteredStray = strayReportViewModel.reports.filter { $0.user_id == userId }

                        if filteredRequests.isEmpty && filteredLost.isEmpty && filteredStray.isEmpty {
                            Spacer()
                            Text("You have no history yet.")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 40)
                            Spacer()
                        } else {
                            // Adoption
                            if !filteredRequests.isEmpty {
                                Text("Adoption Requests")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(filteredRequests) { request in
                                            if let pet = petViewModel.pets.first(where: { $0.pid == request.petId }) {
                                                HistoryTile(
                                                    imageName: pet.imageName,
                                                    title: pet.name,
                                                    subtitle: "Breed: \(pet.breed)\nAge: \(formattedAge(pet.ageDescription))",
                                                    status: request.status.capitalized,
                                                    statusColor: .orange,
                                                    destination: { AdoptionRequestDetailView(request: request) }
                                                )
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }

                            // Lost
                            if !filteredLost.isEmpty {
                                Text("Lost Pet Reports")
                                    .font(.headline)
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(filteredLost) { pet in
                                            let imageName = pet.type == "Dog"
                                                ? ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"].randomElement()!
                                                : ["จี๊ด", "ส้มส้ม", "แหมว"].randomElement()!

                                            HistoryTile(
                                                imageName: imageName,
                                                title: pet.name,
                                                subtitle: "Lost at \(pet.lastSeen)",
                                                status: pet.status ? "Found" : "Missing",
                                                statusColor: pet.status ? .green : .red,
                                                destination: { LostReportHistoryDetailView(pet: pet, model: lostReportModel) }
                                            )
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }
                            }

                            // Stray
                            if !filteredStray.isEmpty {
                                Text("Stray Reports")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(filteredStray) { report in
                                            let imageName = ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"].randomElement()!

                                            HistoryTile(
                                                imageName: imageName,
                                                title: "\(report.petType) - \(report.condition)",
                                                subtitle: "\(report.dateTime)\n\(report.location)",
                                                status: report.isStillThere ? "Not Rescued" : "Rescued",
                                                statusColor: report.isStillThere ? .red : .green,
                                                destination: { EmptyView() }
                                            )
                                        }
                                    }
                                    .padding(.horizontal)
                                    .padding(.bottom, 10)
                                }
                            }
                        }
                    }
                }

                .onAppear {
                    petViewModel.fetchPets()
                    strayReportViewModel.fetchReports()
                    lostReportModel.fetchLostReports()
                    if let uid = session.currentUser?.uid {
                        requestViewModel.fetchRequests(for: uid)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.brandBrown)
                    .padding(8)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("History")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                Text("your adoption and reports")
                    .font(.caption)
                    .foregroundColor(.brandBrown)
            }
            Image("logo_black")
                .resizable()
                .frame(width: 60, height: 60)
        }
        .padding()
    }

    func formattedAge(_ age: Float) -> String {
        if age < 1 {
            let months = Int(round(age * 12))
            return "\(months) mo"
        } else {
            return String(format: "%.1f yr%@", age, age == 1.0 ? "" : "s")
        }
    }
}

struct AdoptionRequestDetailView: View {
    let request: AdoptionRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Adoption Request Details")
                .font(.title2).bold()
                .foregroundColor(.brandBrown)

            HStack {
                Image(systemName: "pawprint.fill")
                Text("Pet ID: \(request.petId)")
            }

            HStack {
                Image(systemName: "checkmark.seal.fill")
                Text("Status: \(request.status.capitalized)")
            }

            HStack {
                Image(systemName: "calendar")
                Text("Requested on: \(request.timestamp.formatted(date: .abbreviated, time: .shortened))")
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Adoption Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct LostReportHistoryDetailView: View {
    let pet: LostPet
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var model: LostReportModel
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Pet Image with Reward
                ZStack(alignment: .topTrailing) {
                    let dogImages = ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"]
                    let catImages = ["จี๊ด", "ส้มส้ม", "แหมว"]
                    let imageName = pet.type == "Dog" ? dogImages.randomElement()! : catImages.randomElement()!
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .cornerRadius(20)
                        .clipped()

                    if !pet.reward.isEmpty {
                        Text("🎁 \(pet.reward)")
                            .font(.caption)
                            .padding(8)
                            .background(Color.brown.opacity(0.9))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                }

                // Pet Name
                Text(pet.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.brandBrown)

                // Info Chips
                HStack(spacing: 16) {
                    infoChip(icon: "pawprint.fill", text: pet.type)
                    infoChip(icon: "calendar", text: formattedAge(pet.age))
                    infoChip(icon: pet.gender == "Male" ? "m.circle" : "f.circle", text: pet.gender)
                    infoChip(icon: "dot.radiowaves.left.and.right", text: pet.breed)
                }
                .padding()

                
                Button(action: {
                    model.markAsFound(petID: pet.pid) {
                        dismiss()
                    }

                }) {
                    Text("Found")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                // Detail Blocks
                VStack(spacing: 16) {
                    detailBlock(icon: "map.fill", title: "Last Seen", text: pet.lastSeen)
                    detailBlock(icon: "eye", title: "Color", text: pet.color)
                    detailBlock(icon: "scalemass", title: "Size", text: pet.size)
                    detailBlock(icon: "tshirt.fill", title: "Wearing", text: pet.wearing)
                    detailBlock(icon: "smiley.fill", title: "Personality", text: pet.personality)
                    detailBlock(icon: "heart.fill", title: "Health", text: pet.healthStatus)
                    detailBlock(icon: "doc.plaintext", title: "Description", text: pet.description)
                }

            }
            .padding()
        }
        .navigationTitle("Lost Pet Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: – Reusable Info Chip
    private func infoChip(icon: String, text: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.brandBlue)

            Text(text)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .frame(minWidth: 70, maxWidth: 80, minHeight: 60)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.brandBrown, lineWidth: 1)
        )
    }

    // MARK: – Reusable Detail Block
    private func detailBlock(icon: String, title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.brandBrown)
                Text(title)
                    .font(.headline)
            }
            Text(text)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(Color.brandBrown).opacity(0.1))
        )
    }

    // MARK: – Age Formatter
    private func formattedAge(_ age: Float) -> String {
        if age < 1 {
            let months = Int(round(age * 12))
            return "\(months) month\(months == 1 ? "" : "s")"
        } else {
            return String(format: "%.1f year%@", age, age == 1.0 ? "" : "s")
        }
    }
}


private struct HistoryTile<Content: View>: View {
    let imageName: String
    let title: String
    let subtitle: String
    let status: String
    let statusColor: Color
    let destination: () -> Content

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 180, height: 150)
                    .clipped()
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    ForEach(subtitle.split(separator: "\n"), id: \.self) { line in
                        Text(line)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    if destination() is EmptyView == false {
                        NavigationLink(destination: destination()) {
                            Text("View")
                                .font(.caption2).bold()
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(Color.brandBlue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.top, 6)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 4)

            Text(status)
                .font(.caption2)
                .padding(6)
                .background(statusColor)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding(8)
        }
        .frame(width: 210)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

private func detailBlock(icon: String, title: String, text: String) -> some View {
    VStack(alignment: .leading, spacing: 8) {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.brandBrown)
            Text(title)
                .font(.headline)
        }
        Text(text)
            .font(.body)
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
        RoundedRectangle(cornerRadius: 12)
            .fill(Color(Color.brandBrown).opacity(0.1))
    )
}

