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
                // Header Section
                HStack {
                        Button(action: {
                            dismiss()  // 👈 Dismiss HistoryView and go back to ProfileView
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.brandBrown)
                                .padding(8)
                                .background(Color.white)
                                .clipShape(Circle())
                        }

                        Spacer()
                    Image("logo_black")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.leading, 16)

                    VStack(alignment: .trailing, spacing: 4) {
                        Text("History")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)

                        Text("your adoption and reports")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.brandBrown)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.horizontal)
                .padding(.top)

                List {
                    Section(header: Text("Adoption Requests").foregroundColor(.brandBrown)) {
                        if requestViewModel.requests.isEmpty {
                            Text("No adoption requests yet.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(requestViewModel.requests) { request in
                                // Match pet by ID
                                let matchedPet = petViewModel.pets.first { $0.pid == request.petId }
                                let petName = matchedPet?.name ?? "Unknown Pet"

                                NavigationLink(destination: AdoptionRequestDetailView(request: request)) {
                                    VStack(alignment: .leading) {
                                        Text("Pet: \(petName)")
                                        Text("Status: \(request.status.capitalized)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .onAppear {
                        petViewModel.fetchPets() // ✅ Fetch pets so names can be matched
                        strayReportViewModel.fetchReports()
                        lostReportModel.fetchLostReports()

                        if let uid = session.currentUser?.uid {
                            requestViewModel.fetchRequests(for: uid)
                        }
                    }


                    // Section: Stray Reports
                    Section(header: Text("Stray Reports").foregroundColor(.brandBrown)) {
                        if strayReportViewModel.reports.isEmpty {
                            Text("No stray reports found.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(strayReportViewModel.reports) { report in
                                NavigationLink(destination: StrayReportDetailView(report: report)) {
                                    HStack {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.brandYellow)
                                        VStack(alignment: .leading) {
                                            Text("Type: \(report.petType)")
                                            Text("Condition: \(report.condition)")
                                            Text("Date: \(report.dateTime) • \(report.location)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // Section: Lost Pet Reports
                    Section(header: Text("Lost Pet Reports").foregroundColor(.brandBrown)) {
                        if lostReportModel.lostPets.isEmpty {
                            Text("No lost pets found.")
                                .foregroundColor(.gray)
                        } else {
                            ForEach(lostReportModel.lostPets) { pet in
                                NavigationLink(destination: LostReportDetailView(pet: pet)) {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.brandBlue)
                                        VStack(alignment: .leading) {
                                            Text(pet.name)
                                            Text("Lost at \(pet.lastSeen)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
                .onAppear {
                    strayReportViewModel.fetchReports()
                    lostReportModel.fetchLostReports()
                        if let uid = session.currentUser?.uid {
                            print("Current user ID:", uid)
                            requestViewModel.fetchRequests(for: uid)
                        } else {
                            print("No user logged in")
                        }
                }
                .onChange(of: session.currentUser?.uid) { newUID in
                    if let uid = newUID {
                        print("User loaded later, re-fetching requests")
                        requestViewModel.fetchRequests(for: uid)
                    }
                }

            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
}

// MARK: - StrayReport Detail View
struct StrayReportDetailView: View {
    let report: StrayReport

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(report.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)

                Group {
                    Text("\(report.petType) - \(report.condition)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.brandBrown)

                    Text("Description: \(report.description)")
                        .font(.body)

                    Text("Location: \(report.location)")
                    Text("Reported at: \(report.dateTime)")
                    Text("Still There?: \(report.isStillThere ? "Yes" : "No")")
                }

                Divider()

                Text("Contact: \(report.contact)")
                    .font(.headline)
                    .foregroundColor(.brandBlue)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Stray Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - LostReport Detail View
struct LostReportDetailView: View {
    let pet: LostPet

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(pet.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)

                Group {
                    Text(pet.name)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.brandBrown)

                    Text("Type: \(pet.type), Breed: \(pet.breed)")
                        .font(.subheadline)

                    Text("Gender: \(pet.gender), Age: \(Int(pet.age))")
                    Text("Health: \(pet.healthStatus)")
                    Text("Personality: \(pet.personality)")
                    Text("Color: \(pet.color), Size: \(pet.size)")
                    Text("Wearing: \(pet.wearing)")
                    Text("Last Seen: \(pet.lastSeen)")
                    Text("Reward: \(pet.reward)")
                }

                if !pet.description.isEmpty {
                    Divider()
                    Text("Description")
                        .font(.headline)
                    Text(pet.description)
                }

                Divider()

                Text("Contact: \(pet.contact)")
                    .font(.headline)
                    .foregroundColor(.brandBlue)
            }
            .padding()
        }
        .navigationTitle("Lost Pet Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
// MARK: - Adoption Request Detail View
struct AdoptionRequestDetailView: View {
    let request: AdoptionRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Adoption Request Details")
                .font(.title2).bold()

            Text("Pet ID: \(request.petId)")
            Text("Status: \(request.status.capitalized)")
                .foregroundColor(.brandBrown)

            Text("Requested on: \(request.timestamp.formatted(date: .abbreviated, time: .shortened))")

            Spacer()
        }
        .padding()
        .navigationTitle("Adoption Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}
//#Preview {
//    HistoryView()
//        .environmentObject(SessionManager())
//}


