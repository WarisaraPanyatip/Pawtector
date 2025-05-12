import SwiftUI
import FirebaseStorage

// MARK: - LostAndFoundView
struct LostAndFoundView: View {
    @StateObject private var lostReportModel = LostReportModel()
    @StateObject private var sessionManager = SessionManager()
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
                
//                HStack {
//                    Image("logo_black")
//                        .resizable()
//                        .frame(width: 60, height: 60)
//                        .padding(.leading)
//                    
//                    Spacer()
//                    
//                    VStack(alignment: .trailing, spacing: 4) {
//                        Text("Lost & Found")
//                            .font(.system(size: 24, weight: .bold))
//                            .foregroundColor(.brandBrown)
//                        
//                        Text("help them find the way home")
//                            .font(.system(size: 14))
//                            .foregroundColor(.brandBrown)
//                    }
//                    .padding(.trailing)
//                }
//                .padding(.top, 20) // Push content up closer to status bar
//                .padding(.horizontal)

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
                                                AsyncImage(url: URL(string: pet.imageURL)) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                            .frame(width: 240, height: 240)
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 240, height: 240)
                                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                                            .shadow(radius: 10)
                                                    case .failure:
                                                        Image("placeholder")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fill)
                                                            .frame(width: 240, height: 240)
                                                            .clipShape(RoundedRectangle(cornerRadius: 25))
                                                            .shadow(radius: 10)
                                                    @unknown default:
                                                        EmptyView()
                                                    }
                                                }

                                                
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


#Preview {
    LostAndFoundView()
        .environmentObject(SessionManager())
        .environmentObject(LostReportModel())
}
