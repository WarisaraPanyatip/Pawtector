import SwiftUI
import FirebaseStorage

struct LostAndFoundView: View {
    @StateObject private var lostReportModel = LostReportModel()
    @State private var searchText = ""
    @State private var selectedTab = 0
    @Namespace private var tabNamespace
    
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    var filteredPets: [LostPet] {
        let activePets = lostReportModel.lostPets.filter { !$0.status } // Only not-found

        if searchText.isEmpty {
            return activePets
        } else {
            return activePets.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.breed.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header
                
                ScrollView {
                    if selectedTab == 0 {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(filteredPets) { pet in
                                LostPetTileView(pet: pet)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    } else {
                        ReportLostView()
                    }
                }
            }
            .onAppear {
                lostReportModel.fetchLostReports()
            }
        }
        .environmentObject(lostReportModel)
    }
    
    private var header: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                Color.brandYellow
                    .opacity(0.2)
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 90)
                
                VStack(spacing: 12) {
                    HStack {
                        Image("logo_black")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .padding(.leading)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Lost & Found")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.brandBrown)
                            
                            Text("Announce lost pets to help them home")
                                .font(.system(size: 14))
                                .foregroundColor(.brandBrown)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                }
            }
            
            tabSelector
            
            //            HStack {
            //                TextField("Search pets by Name, Type, Breed", text: $searchText)
            //                    .padding(8)
            //                    .background(Color.white)
            //                    .cornerRadius(10)
            //                    .padding(.horizontal)
            //            }
            //            .padding(.top, 8)
        }
    }
    
    private var tabSelector: some View {
        HStack(spacing: 12) {
            ForEach(["Lost Pets", "Report Lost"], id: \.self) { title in
                let index = title == "Lost Pets" ? 0 : 1
                Text(title)
                    .font(.headline)
                    .foregroundColor(selectedTab == index ? .black : .brandBrown)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8) // Inner horizontal padding
                    .frame(maxWidth: .infinity)
                    .background(selectedTab == index ? Color(.systemGray5) : Color.brandYellow.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            selectedTab = index
                        }
                    }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom, 16) // Space below the tab selector
    }
}

struct LostPetTileView: View {
    let pet: LostPet

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                let dogImages = ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"]
                let catImages = ["จี๊ด", "ส้มส้ม", "แหมว"]
                let imageName = pet.type == "Dog" ? dogImages.randomElement()! : catImages.randomElement()!

                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .frame(maxWidth: .infinity)
                    .clipped()

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pet.name)
                            .font(.headline)
                        Text("\(pet.lastSeen)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    NavigationLink(destination: LostAndFoundDetailView(pet: pet)) {
                        Text("View")
                            .font(.caption2).bold()
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.brandBlue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
                .padding(8)
                .background(Color.white)
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

            if !pet.reward.isEmpty {
                Text("\u{0E3F}\(pet.reward)")
                    .font(.caption2).bold()
                    .padding(6)
                    .background(Color.brown)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .offset(x: -12, y: 12)
            }
        }
    }
}


#Preview {
    LostAndFoundView()
        .environmentObject(SessionManager())
        .environmentObject(LostReportModel())
}
