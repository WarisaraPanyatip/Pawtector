import SwiftUI

// MARK: - LostAndFoundView
struct LostAndFoundView: View {
    var body: some View {
        NavigationStack {
            AnnounceLostPetView()
        }
    }
}

// MARK: - AnnounceLostPetView
import SwiftUI

// MARK: - AnnounceLostPetView
struct AnnounceLostPetView: View {
    @State private var isShowingDetail = false
    @State private var selectedPet: Pet? = nil
    @State private var selectedTab = 0
    @State private var searchText = ""
    @Namespace private var tabAnimation

    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let pets: [Pet] = Pet.sampleData

    var filteredPets: [Pet] {
        if searchText.isEmpty {
            return pets
        } else {
            return pets.filter {
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

                            ZStack {
                                if selectedTab == 0 {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.white)
                                        .matchedGeometryEffect(id: "tabUnderline", in: tabAnimation)
                                        .frame(height: 2)
                                } else {
                                    Color.clear.frame(height: 2)
                                }
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

                            ZStack {
                                if selectedTab == 1 {
                                    RoundedRectangle(cornerRadius: 2)
                                        .fill(Color.white)
                                        .matchedGeometryEffect(id: "tabUnderline", in: tabAnimation)
                                        .frame(height: 2)
                                } else {
                                    Color.clear.frame(height: 2)
                                }
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

                                            Text("\(pet.breed), \(pet.ageDescription)")
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
}


// MARK: - LostAndFoundDetailView
struct LostAndFoundDetailView: View {
    let pet: Pet
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
                    Text("Last Seen: \(pet.location)")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("\(pet.reward) Reward")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                Divider().padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("**Breed:** \(pet.breed)")
                    Text("**Age:** \(pet.ageDescription)")
                    Text("**Found?:** \(pet.isFound ? "Yes" : "No")")
                    Text("**Personality:** \(pet.personality)")
                    Text("**Health:** \(pet.healthStatus)")
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                Button(action: {
                    // Call or message
                }) {
                    Text("\u{2706} XXXX-XXX-XXXX")
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

struct ReportLostView: View {
    @State private var selectedPetType = "Dog"
    @State private var petName = ""
    @State private var lastSeen = ""
    @State private var description = ""
    @State private var color = ""
    @State private var size = ""
    @State private var wearing = ""
    @State private var contact = ""
    @State private var reward = ""
    @State private var isHistoryPresented = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Spacer for top button
                    Color.clear.frame(height: 40)

                    // Form container
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

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Upload Photo").font(.subheadline)
                            Button(action: {
                                // Upload action
                            }) {
                                VStack {
                                    Image(systemName: "camera")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top)

                    // Submit Button
                    Button(action: {
                        // Submit logic
                    }) {
                        Text("Send Report")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#77BED1"))
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }

//            // History button (floating)
//            Button(action: {
//                isHistoryPresented = true
//            }) {
//                Text("View History")
//                    .font(.footnote)
//                    .fontWeight(.semibold)
//                    .padding(10)
//                    .background(Color.white)
//                    .foregroundColor(Color(hex: "#77BED1"))
//                    .cornerRadius(10)
//                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
//            }
//            .padding(.trailing, 16)
//            .padding(.top, 10)
//            .sheet(isPresented: $isHistoryPresented) {
//                HistoryLostView()
//            }
        }
    }
}

// MARK: - HistoryLostView
struct HistoryLostView: View {
    var body: some View {
        List {
            NavigationLink(
                destination: LostAndFoundDetailView(
                    pet: Pet.sampleData.first!
                )
            ) {
                HStack {
                    Image(systemName: "photo")
                    VStack(alignment: .leading) {
                        Text("Type: Dog")
                        Text("Status: Sick")
                        Text("Date: 02/04/2025")
                    }
                }
            }
        }
    }
}

#Preview {
    LostAndFoundView()
}
