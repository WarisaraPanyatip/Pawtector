import SwiftUI




/// PET TILE VIEW ////////

struct PetTileView: View {
    let pet: Pet
    let isFavorite: Bool
    let onFavoriteTap: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Image(pet.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .clipped()

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(pet.name)
                            .font(.headline)
                        Text(formattedAge(pet.ageDescription))
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

    private func formattedAge(_ age: Float) -> String {
        if age < 1 {
            let months = Int(round(age * 12))
            return "\(months) month\(months == 1 ? "" : "s")"
        } else {
            return String(format: "%.1f year%@", age, age == 1.0 ? "" : "s")
        }
    }
}



///////HOMEPAGE VIEW///////


struct HomePageView: View {
    let pets: [Pet]
    @EnvironmentObject var session: SessionManager
    @Binding var favorites: Set<UUID>
    @Binding var selectedTab: Int
    
    // Filter & temp filter states
    @State private var filterTypes       = Set<String>()
    @State private var filterGenders     = Set<String>()
    @State private var vaccinatedOnly    = false
    @State private var sterilizedOnly    = false
    @State private var ageValue          = 0
    @State private var ageUnit: AgeUnit  = .year
    @State private var selectedColor     = "Any"
    @State private var selectedCity      = "Any"
    @State private var tempFilterTypes   = Set<String>()
    @State private var tempFilterGenders = Set<String>()
    @State private var tempVaccinatedOnly = false
    @State private var tempSterilizedOnly = false
    @State private var tempAgeValue      = 0
    @State private var tempAgeUnit: AgeUnit = .year
    @State private var tempSelectedColor = "Any"
    @State private var tempSelectedCity  = "Any"
    @State private var showFilter = false
    
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    private var filteredPets: [Pet] {
        pets.filter { pet in
            (filterTypes.isEmpty || filterTypes.contains(pet.type)) &&
            (filterGenders.isEmpty || filterGenders.contains(pet.gender)) &&
            (!vaccinatedOnly || pet.healthStatus.localizedCaseInsensitiveContains("vaccinated")) &&
            (!sterilizedOnly || pet.healthStatus.localizedCaseInsensitiveContains("spayed") || pet.healthStatus.localizedCaseInsensitiveContains("neutered")) &&
            (selectedCity == "Any" || pet.location == selectedCity) &&
            ageMatches(pet)
        }
    }

    private func ageMatches(_ pet: Pet) -> Bool {
        if ageValue == 0 {
            return true // No filter
        }

        switch ageUnit {
        case .year:
            return Int(round(pet.ageDescription)) == ageValue
        case .month:
            let ageInMonths = Int(round(pet.ageDescription * 12))
            return ageInMonths == ageValue
        }
    }



    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                VStack(spacing: 0) {
                    header
                    ScrollView {
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
                }
                
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
                }
            }
            .navigationBarHidden(true)
        }
    }
    ////////header ///////
    private var header: some View {
        HStack {
            ZStack {

                Image("logo_black") // Use the name you gave the asset
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24) // Adjust size as needed
            }
            
            VStack(alignment: .trailing, spacing: 8) {
                // Greeting section
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Hi, \(session.currentUser?.username ?? "Friend")")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("choose your lovely pet !")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.brandBrown)
                    }
                }
                
                // Filter button row
                HStack {
                    Spacer()
                    Button {
                        // Copy current filters to temp filters
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
                            .foregroundColor(.brandBrown)
                    }
                }
            
            }
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

            
            
            

            
