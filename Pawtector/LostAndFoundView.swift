//import SwiftUI
//
//// MARK: - Data Model
////struct Pet: Identifiable {
////    let id = UUID()
////    let imageName: String
////    let name: String
////    let age: String
////    let breed: String
////    let location: String
////    let reward: String
////    let isFound: Bool
////}
//
//// MARK: - Main View
//struct LostAndFoundView: View {
//    var body: some View {
//        NavigationStack {
//            AnnounceLostPetView()
//        }
//    }
//}
//
//// MARK: - AnnounceLostPetView
//struct AnnounceLostPetView: View {
//    @State private var isShowingDetail = false
//    @State private var selectedPet: Pet? = nil
//    @State private var selectedTab = 0
//    @State private var searchText = ""
//
//    let columns = [GridItem(.flexible()), GridItem(.flexible())]
//
////    let pets: [Pet] = (0..<10).map { _ in
////        Pet(
////            imageName: "dog1",
////            name: "Betty",
////            age: "18 months",
////            breed: "Shiba",
////            location: "",
////            reward: "$59",
////            isFound: false
////        )
////    }
//
//    var filteredPets: [Pet] {
//        if searchText.isEmpty {
//            return pets
//        } else {
//            return pets.filter {
//                $0.name.localizedCaseInsensitiveContains(searchText)
//                    || $0.breed.localizedCaseInsensitiveContains(searchText)
//                    || $0.imageName.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            // Header
//            VStack(spacing: 6) {
//                Image("Logo")
//                    .resizable()
//                    .frame(width: 60, height: 60)
//                    .padding(.top, 16)
//
//                Text("Lost & Found")
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//
//                Text("help them find the way home")
//                    .font(.footnote)
//                    .foregroundColor(Color(hex: "#FDBC33"))
//
//                // Tabs
//                HStack {
//                    Button(action: { selectedTab = 0 }) {
//                        VStack(spacing: 2) {
//                            Text("Lost Pet")
//                                .font(.subheadline)
//                                .fontWeight(.bold)
//                                .foregroundColor(
//                                    selectedTab == 0
//                                        ? .white : .white.opacity(0.7))
//
//                            if selectedTab == 0 {
//                                RoundedRectangle(cornerRadius: 2)
//                                    .fill(Color.white)
//                                    .frame(height: 2)
//                            } else {
//                                Color.clear.frame(height: 2)
//                            }
//                        }
//                    }
//
//                    Spacer()
//
//                    Button(action: { selectedTab = 1 }) {
//                        VStack(spacing: 2) {
//                            Text("Report Lost")
//                                .font(.subheadline)
//                                .fontWeight(.bold)
//                                .foregroundColor(
//                                    selectedTab == 1
//                                        ? .white : .white.opacity(0.7))
//
//                            if selectedTab == 1 {
//                                RoundedRectangle(cornerRadius: 2)
//                                    .fill(Color.white)
//                                    .frame(height: 2)
//                            } else {
//                                Color.clear.frame(height: 2)
//                            }
//                        }
//                    }
//                }
//                .padding(.horizontal)
//                .padding(.top, 4)
//            }
//            .padding(.bottom, 12)
//            .frame(maxWidth: .infinity)
//            .background(Color(hex: "#77BED1"))
//
//            if selectedTab == 0 {
//                ScrollView {
//                    VStack(spacing: 16) {
//                        // Search
//                        TextField(
//                            "Search by Name, Breed, or Prt Type",
//                            text: $searchText
//                        )
//                        .padding(10)
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//
//                        LazyVGrid(columns: columns, spacing: 16) {
//                            ForEach(filteredPets) { pet in
//                                Button {
//                                    selectedPet = pet
//                                    isShowingDetail = true
//                                } label: {
//                                    VStack(spacing: 8) {
//                                        ZStack(alignment: .topLeading) {
//                                            Image(pet.imageName)
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fill)
//                                                .frame(height: 140)
//                                                .clipped()
//                                                .cornerRadius(16)
//
//                                            Text("Reward \(pet.reward)")
//                                                .font(.caption2)
//                                                .fontWeight(.bold)
//                                                .padding(.horizontal, 8)
//                                                .padding(.vertical, 4)
//                                                .background(
//                                                    Color(hex: "#FBDC96")
//                                                )
//                                                .cornerRadius(10)
//                                                .padding(6)
//                                        }
//
//                                        VStack(spacing: 2) {
//                                            Text(pet.name)
//                                                .font(.subheadline)
//                                                .fontWeight(.bold)
//
//                                            Text("\(pet.breed), \(pet.age)")
//                                                .font(.caption)
//                                                .foregroundColor(.gray)
//                                        }
//                                    }
//                                    .padding(8)
//                                    .background(Color.white)
//                                    .cornerRadius(16)
//                                    .shadow(
//                                        color: Color.black.opacity(0.05),
//                                        radius: 4, x: 0, y: 2)
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    .padding(.bottom, 40)
//                }
//                .sheet(isPresented: $isShowingDetail) {
//                    if let selectedPet = selectedPet {
//                        LostAndFoundDetailView(pet: selectedPet)
//                    }
//                }
//            } else {
//                LostReportPage()
//                    .padding(.top)
//            }
//        }
//    }
//}
//
//// MARK: - Detail View
//struct LostAndFoundDetailView: View {
//    let pet: Pet
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        VStack(spacing: 20) {
//
//            ScrollView {
//                VStack(spacing: 20) {
//                    Image(pet.imageName)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 240, height: 240)
//                        .clipShape(RoundedRectangle(cornerRadius: 25))
//                        .shadow(radius: 10)
//
//                    Text(pet.name)
//                        .font(.headline)
//
//                    VStack(spacing: 6) {
//                        Text("Last Seen: \(pet.location)")
//                            .font(.subheadline)
//                            .fontWeight(.semibold)
//
//                        Text("\(pet.reward) Reward")
//                            .font(.title2)
//                            .fontWeight(.bold)
//                            .foregroundColor(.green)
//                    }
//
//                    Divider().padding(.horizontal)
//
//                    VStack(alignment: .leading, spacing: 12) {
//                        Text("**Breed:** \(pet.breed)")
//                        Text("**Age:** \(pet.age)")
//                        Text(
//                            "**Color:** Light golden with a white patch on chest"
//                        )
//                        Text("**Size:** Medium-large, about 70 lbs")
//                        Text("**Wearing:** Red collar with a bone-shaped tag")
//                    }
//                    .padding()
//                    .background(Color(UIColor.systemGray6))
//                    .cornerRadius(12)
//                    .padding(.horizontal)
//
//                    Button(action: {
//                        // call or message action
//                    }) {
//                        Text("\u{2706} XXXX-XXX-XXXX")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(
//                                Color(
//                                    red: 209 / 255, green: 119 / 255,
//                                    blue: 119 / 255)
//                            )
//                            .cornerRadius(12)
//                            .shadow(radius: 5)
//                    }
//                    .padding(.horizontal)
//                    .padding(.bottom, 40)
//                }
//            }
//        }
//        .gesture(
//            DragGesture(minimumDistance: 20, coordinateSpace: .global)
//                .onEnded { value in
//                    if value.translation.height > 50 {
//                        dismiss()
//                    }
//                }
//        )
//    }
//}
//
//// MARK: - LostReportPage
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
//
//// MARK: - Report View
//struct ReportLostView: View {
//    @State private var selectedPetType = "Dog"
//    @State private var description = ""
//    @State private var location = ""
//    @State private var isAnnouncePresented = false
//
//    var body: some View {
//        Form {
//            Section(header: Text("Upload Pictures")) {
//                Image(systemName: "photo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(height: 100)
//            }
//
//            Picker("Type", selection: $selectedPetType) {
//                Text("Dog").tag("Dog")
//                Text("Cat").tag("Cat")
//            }.pickerStyle(SegmentedPickerStyle())
//
//            TextField("Description", text: $description)
//            TextField("Location", text: $location)
//
//            Button("Send") {
//                // Submit logic
//            }
//
//            Button("Announce Lost Pet") {
//                isAnnouncePresented = true
//            }
//            .sheet(isPresented: $isAnnouncePresented) {
//                AnnounceLostPetView()
//            }
//        }
//    }
//}
//
//// MARK: - History View
//struct HistoryLostView: View {
//    var body: some View {
//        List {
//            NavigationLink(
//                destination: LostAndFoundDetailView(
//                    pet: Pet(
//                        imageName: "dog",
//                        name: "Name, 18 months",
//                        age: "4 years old",
//                        breed: "Shiba",
//                        location: "Phayathai",
//                        reward: "$2000",
//                        isFound: false
//                    ))
//            ) {
//                HStack {
//                    Image(systemName: "photo")
//                    VStack(alignment: .leading) {
//                        Text("Type: Dog")
//                        Text("Sick")
//                        Text("Date: 02/04/2025")
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    LostAndFoundView()
//}
//
//
//
