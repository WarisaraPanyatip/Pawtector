import SwiftUI

// MARK: - LostAndFoundView
struct LostAndFoundView: View {
    @StateObject private var lostReportModel = LostReportModel()
    var body: some View {
        NavigationStack {
            AnnounceLostPetView()
        }
    }
}


// MARK: - AnnounceLostPetView
struct AnnounceLostPetView: View {
    @EnvironmentObject var lostReportModel: LostReportModel
    @State private var isShowingDetail = false
    @State private var selectedPet: LostPet? = nil
    @State private var selectedTab = 0
    @State private var searchText = ""
    @Namespace private var tabAnimation

    let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var filteredPets: [LostPet] {
        if searchText.isEmpty {
            return lostReportModel.lostPets
        } else {
            return lostReportModel.lostPets.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
                || $0.breed.localizedCaseInsensitiveContains(searchText)
                || $0.type.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 6) {
                HStack(alignment: .center) {
                    Image("logo_white")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.leading, 16)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Lost & Found")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("help them find the way home")
                            .font(.footnote)
                            .foregroundColor(Color(hex: "#FDBC33"))
                    }
                    .padding(.trailing, 16)
                }
                .padding(.top, 16)

                // Tabs with animation
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            selectedTab = 0
                        }
                    }) {
                        VStack(spacing: 2) {
                            Text("Lost Pet")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(selectedTab == 0 ? .white : .white.opacity(0.7))

                            if selectedTab == 0 {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "tabUnderline", in: tabAnimation)
                            }
                        }
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.easeInOut) {
                            selectedTab = 1
                        }
                    }) {
                        VStack(spacing: 2) {
                            Text("Report Lost")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(selectedTab == 1 ? .white : .white.opacity(0.7))

                            if selectedTab == 1 {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white)
                                    .frame(height: 2)
                                    .matchedGeometryEffect(id: "tabUnderline", in: tabAnimation)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 4)
            }
            .padding(.bottom, 12)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "#77BED1"))

            // Main content
            if selectedTab == 0 {
                ScrollView {
                    VStack(spacing: 16) {
                        // Search
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)

                            TextField("Search by Name, Breed, or Pet Type", text: $searchText)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                        if lostReportModel.lostPets.isEmpty {
                            Text("No lost pets found.")
                                .foregroundColor(.gray)
                                .padding()
                        }
                        else {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(filteredPets) { pet in
                                    Button {
                                        selectedPet = pet
                                        isShowingDetail = true
                                    } label: {
                                        VStack(spacing: 8) {
                                            ZStack(alignment: .topLeading) {
                                                Image(pet.imageName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(height: 140)
                                                    .clipped()
                                                    .cornerRadius(16)
                                                
                                                Text("Reward \(pet.reward)")
                                                    .font(.caption2)
                                                    .fontWeight(.bold)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color(hex: "#FBDC96"))
                                                    .cornerRadius(10)
                                                    .padding(6)
                                            }
                                            
                                            VStack(spacing: 2) {
                                                Text(pet.name)
                                                    .font(.subheadline)
                                                    .fontWeight(.bold)
                                                
                                                Text("\(pet.breed), \(formattedAge(pet.age))")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        .padding(8)
                                        .background(Color.white)
                                        .cornerRadius(16)
                                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom, 40)
                }
                .sheet(isPresented: $isShowingDetail) {
                    if let selectedPet = selectedPet {
                        LostAndFoundDetailView(pet: selectedPet)
                    }
                }
            } else {
                ReportLostView()
                    .padding(.top)
            }
        }
    }

    private func formattedAge(_ age: Float) -> String {
        if age < 1 {
            let months = Int(round(age * 12))
            return "\(months) month\(months == 1 ? "" : "s")"
        } else {
            return String(format: "%.1f year%@", age, age == 1.0 ? "" : "s")
        }
    }
}



// MARK: - LostAndFoundDetailView
import SwiftUI

struct LostAndFoundDetailView: View {
    let pet: LostPet
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(pet.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 240, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 10)

                Text(pet.name)
                    .font(.headline)

                VStack(spacing: 6) {
                    Text("Last Seen: \(pet.lastSeen)")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("Reward: \(pet.reward)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                Divider().padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("**Breed:** \(pet.breed)")
                    Text("**Age:** \(formattedAge(pet.age))")
                    Text("**Gender:** \(pet.gender)")
                    Text("**Color:** \(pet.color)")
                    Text("**Size:** \(pet.size)")
                    Text("**Wearing:** \(pet.wearing)")
                    Text("**Found?:** \(pet.status ? "Yes" : "No")")
                    Text("**Personality:** \(pet.personality)")
                    Text("**Health:** \(pet.healthStatus)")
                    Text("**Description:**\n\(pet.description)")
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                Button(action: {
                    // Optional: Call or message functionality here
                }) {
                    Text("\u{2706} \(pet.contact)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 209 / 255, green: 119 / 255, blue: 119 / 255))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.height > 50 {
                        dismiss()
                    }
                }
        )
    }

    private func formattedAge(_ age: Float) -> String {
        if age < 1 {
            let months = Int(round(age * 12))
            return "\(months) month\(months == 1 ? "" : "s")"
        } else {
            return String(format: "%.1f year%@", age, age == 1.0 ? "" : "s")
        }
    }
}


// MARK: - LostReportPage
//struct LostReportPage: View {
//    @State private var selection = 0
//
//    var body: some View {
//        VStack {
//            Picker("Mode", selection: $selection) {
//                Text("Report").tag(0)
//                Text("History").tag(1)
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 10)
//                    .fill(Color.yellow.opacity(0.2))
//            )
//
//            if selection == 0 {
//                ReportLostView()
//            } else {
//                HistoryLostView()
//            }
//        }
//        .padding()
//    }
//}

// MARK: - ReportLostView

import SwiftUI
import FirebaseFirestore

struct ReportLostView: View {
    @EnvironmentObject var lostReportModel: LostReportModel
    @State private var selectedPetType = "Dog"
    @State private var petName = ""
    @State private var lastSeen = ""
    @State private var description = ""
    @State private var color = ""
    @State private var size = ""
    @State private var wearing = ""
    @State private var contact = ""
    @State private var reward = ""
    @State private var imageName = "placeholder" // Default placeholder image
    @State private var gender = "Male"
    @State private var age: Float = 1.0
    @State private var breed = ""
    @State private var personality = ""
    @State private var healthStatus = ""
    @State private var status = false
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Color.clear.frame(height: 40)

                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            Text("Pet Name").font(.subheadline)
                            TextField("Enter pet's name", text: $petName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Type").font(.subheadline)
                                    Picker("Type", selection: $selectedPetType) {
                                        Text("Cat").tag("Cat")
                                        Text("Dog").tag("Dog")
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }

                                Spacer()

                                VStack(alignment: .leading) {
                                    Text("Last Seen").font(.subheadline)
                                    TextField("mm/dd/yyyy", text: $lastSeen)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(width: 130)
                                }
                            }

                            Text("Description").font(.subheadline)
                            TextEditor(text: $description)
                                .frame(height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                        }

                        Group {
                            Text("Color").font(.subheadline)
                            TextField("Describe color", text: $color)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Size").font(.subheadline)
                            TextField("Small / Medium / Large", text: $size)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Wearing").font(.subheadline)
                            TextField("e.g. red collar, shirt", text: $wearing)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Contact Number").font(.subheadline)
                            TextField("Your phone number", text: $contact)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Reward (optional)").font(.subheadline)
                            TextField("$0", text: $reward)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                        }

                        Group {
                            Text("Breed").font(.subheadline)
                            TextField("Breed", text: $breed)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Gender").font(.subheadline)
                            Picker("Gender", selection: $gender) {
                                Text("Male").tag("Male")
                                Text("Female").tag("Female")
                            }
                            .pickerStyle(SegmentedPickerStyle())

                            Text("Age (Years)").font(.subheadline)
                            Slider(value: $age, in: 0.1...20, step: 0.1) {
                                Text("Age")
                            }
                            Text(String(format: "%.1f years", age))
                                .font(.caption)

                            Text("Personality").font(.subheadline)
                            TextField("e.g. friendly, shy", text: $personality)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Health Status").font(.subheadline)
                            TextField("e.g. injured, healthy", text: $healthStatus)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top)

                    Button(action: submitReport) {
                        if isSubmitting {
                            ProgressView()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .cornerRadius(12)
                        } else {
                            Text("Send Report")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#77BED1"))
                                .cornerRadius(12)
                        }
                    }
                    .disabled(isSubmitting)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .alert("Report Status", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func submitReport() {
        isSubmitting = true

        let db = Firestore.firestore()
        let newID = UUID().uuidString
        let newReport: [String: Any] = [
            "pid": newID,
            "name": petName,
            "type": selectedPetType,
            "breed": breed,
            "gender": gender,
            "age": age,
            "imageName": imageName,
            "healthStatus": healthStatus,
            "personality": personality,
            "status": status,
            "reward": reward,
            "lastSeen": lastSeen,
            "description": description,
            "contact": contact,
            "color": color,
            "size": size,
            "wearing": wearing
        ]

        db.collection("LostReport").document(newID).setData(newReport) { error in
            isSubmitting = false
            if let error = error {
                alertMessage = "Failed to submit report: \(error.localizedDescription)"
            } else {
                alertMessage = "Report submitted successfully."
                resetForm()
            }
            showAlert = true
            lostReportModel.fetchLostReports()
        }
    }

    private func resetForm() {
        petName = ""
        breed = ""
        gender = "Male"
        age = 1.0
        imageName = "placeholder"
        healthStatus = ""
        personality = ""
        status = false
        reward = ""
        lastSeen = ""
        description = ""
        contact = ""
        color = ""
        size = ""
        wearing = ""
    }
}


#Preview {
    LostAndFoundView()
        .environmentObject(LostReportModel())
}
