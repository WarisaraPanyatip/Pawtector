import SwiftUI

//----------------------------- Pet Tile Component -----------------------------

struct PetTileView: View {
    let pet: Pet
    let isFavorite: Bool
    let onFavoriteTap: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                // Pet image
                Image(pet.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()

                // Name, age, and "More" button
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pet.name)
                            .font(.headline)
                        Text(pet.ageDescription)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    NavigationLink {
                        PetDetailView(pet: pet)
                    } label: {
                        Text("More")
                            .font(.caption2).bold()
                            .padding(.vertical, 4).padding(.horizontal, 8)
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

            // Favorite heart button
            Button(action: onFavoriteTap) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .brandBlue)
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .offset(x: -12, y: 12)
        }
    }
}

//----------------------------- Home Page View -----------------------------

struct HomePageView: View {
    let pets: [Pet]
    @EnvironmentObject var session: SessionManager // For accessing current user's info

    // MARK: – Applied filters (used in pet list filtering)
    @State private var filterTypes       = Set<String>()
    @State private var filterGenders     = Set<String>()
    @State private var vaccinatedOnly    = false
    @State private var sterilizedOnly    = false
    @State private var ageValue          = 1
    @State private var ageUnit: AgeUnit  = .year
    @State private var selectedColor     = "Any"
    @State private var selectedCity      = "Any"
    
    // MARK: – Temporary filters (used inside the filter sheet)
    @State private var tempFilterTypes     = Set<String>()
    @State private var tempFilterGenders   = Set<String>()
    @State private var tempVaccinatedOnly  = false
    @State private var tempSterilizedOnly  = false
    @State private var tempAgeValue        = 1
    @State private var tempAgeUnit: AgeUnit = .year
    @State private var tempSelectedColor   = "Any"
    @State private var tempSelectedCity    = "Any"
    
    @State private var showFilter = false // Controls visibility of the filter sheet
    @State private var favorites  = Set<UUID>() // Stores favorite pet IDs
    
    // MARK: – Layout grid for pet tiles
    private let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    // MARK: – Filter logic for visible pets
    private var filteredPets: [Pet] {
        pets.filter { pet in
            (filterTypes.isEmpty   || filterTypes.contains(pet.type)) &&
            (filterGenders.isEmpty || filterGenders.contains(pet.gender))
        }
    }

    // MARK: – Main body
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea() // Background color
                
                VStack(spacing: 0) {
                    header // Top header with user greeting
                    
                    ScrollView {
                        // Pet grid
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(filteredPets) { pet in
                                PetTileView(
                                    pet: pet,
                                    isFavorite: favorites.contains(pet.id),
                                    onFavoriteTap: {
                                        if favorites.contains(pet.id) {
                                            favorites.remove(pet.id)
                                        } else {
                                            favorites.insert(pet.id)
                                        }
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }

//                    bottomNav // Bottom tab bar
//                        .padding(.bottom, 8)
                }
                
                // MARK: – Filter sheet
                .sheet(isPresented: $showFilter) {
                    FilterPopupView(
                        filterTypes: $tempFilterTypes,
                        filterGenders: $tempFilterGenders,
                        vaccinatedOnly: $tempVaccinatedOnly,
                        sterilizedOnly: $tempSterilizedOnly,
                        ageValue: $tempAgeValue,
                        ageUnit: $tempAgeUnit,
                        selectedColor: $tempSelectedColor,
                        selectedCity: $tempSelectedCity
                    ) {
                        // Apply temp filters → applied filters
                        filterTypes       = tempFilterTypes
                        filterGenders     = tempFilterGenders
                        vaccinatedOnly    = tempVaccinatedOnly
                        sterilizedOnly    = tempSterilizedOnly
                        ageValue          = tempAgeValue
                        ageUnit           = tempAgeUnit
                        selectedColor     = tempSelectedColor
                        selectedCity      = tempSelectedCity
                        showFilter        = false
                    }
                    .presentationDetents([.fraction(0.75)])
                    .presentationDragIndicator(.visible)
                }
            }
            .navigationBarHidden(true) // Hides the default nav bar
        }
    }

    // MARK: – Top Header View
    private var header: some View {
        HStack {
            // Left logo
            ZStack {
                Circle()
                    .fill(Color.brandBlue.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: "pawprint.fill")
                    .font(.title2)
                    .foregroundColor(.brandBlue)
            }

            // Right greeting with dynamic username
            VStack(alignment: .trailing) {
                Text("Hi, \(session.currentUser?.username ?? "Friend")")
                    .font(.system(size: 24, weight: .bold))
                Text("choose your lovely pet !")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.1))
            }
            .padding(.trailing)

            Spacer()

            // Filter button
            Button {
                // Copy applied filters to temp filters before showing filter UI
                tempFilterTypes     = filterTypes
                tempFilterGenders   = filterGenders
                tempVaccinatedOnly  = vaccinatedOnly
                tempSterilizedOnly  = sterilizedOnly
                tempAgeValue        = ageValue
                tempAgeUnit         = ageUnit
                tempSelectedColor   = selectedColor
                tempSelectedCity    = selectedCity
                showFilter.toggle()
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.title2)
                    .foregroundColor(.brandBlue)
            }
        }
        .padding()
    }

//    // MARK: – Bottom Tab Bar View
//    private var bottomNav: some View {
//        HStack(spacing: 32) {
//            navButton(icon: "house.fill",      isSelected: true)
//            navButton(icon: "heart",           isSelected: false)
//            navButton(icon: "bell",            isSelected: false)
//            navButton(icon: "magnifyingglass", isSelected: false)
//            navButton(icon: "person",          isSelected: false)
//        }
//        .padding(.vertical, 8)
//        .padding(.horizontal, 16)
//        .background(Color.brandBlue)
//        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//    }

    // MARK: – Navigation Button Component
    private func navButton(icon: String, isSelected: Bool) -> some View {
        Button {} label: {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.black)
                .padding(10)
                .background(isSelected ? Circle().fill(Color.brandYellow) : nil)
        }
    }
}

//----------------------------- Preview -----------------------------

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(pets: Pet.sampleData)
            .environmentObject(SessionManager())
    }
}
