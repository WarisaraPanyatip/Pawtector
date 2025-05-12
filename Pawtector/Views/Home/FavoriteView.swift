import SwiftUI
import FirebaseAuth

struct FavoriteView: View {
    let pets: [Pet]
    @Binding var favorites: Set<String>
    @Binding var selectedTab: Int
    
    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]
    
    // Filter pets that are favorited by pid
    var favoritePets: [Pet] {
        pets.filter { favorites.contains($0.pid) }
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Background
                Color(.systemGray6).ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // MARK: - Header
                    ZStack(alignment: .top) {
                        Color.brandYellow
                            .opacity(0.2)
                            .ignoresSafeArea(edges: .top)
                            .frame(height: 90) // Increased height for spacing
                        
                        HStack {
                            Image("logo_black")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .padding(.leading)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Favorites")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.brandBrown)
                                
                                Text("your favorite pets <3")
                                    .font(.system(size: 14))
                                    .foregroundColor(.brandBrown)
                            }
                            .padding(.trailing)
                        }
                        .padding(.top, 20) // Push content up closer to status bar
                        .padding(.horizontal)
                    }
                    
                    // MARK: - Content
                    
                    if favoritePets.isEmpty {
                        Spacer()
                        Text("You have no favorites yet.")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    } else {
                        ScrollView {
                            VStack(spacing: 0) {
                                Spacer().frame(height: 16)
                                LazyVGrid(columns: columns, spacing: 16) {
                                    ForEach(favoritePets) { pet in
                                        PetTileView(
                                            pet: pet,
                                            isFavorite: true,
                                            onFavoriteTap: {
                                                favorites.remove(pet.pid)
                                                if let uid = Auth.auth().currentUser?.uid {
                                                    UserService().updateFavorite(for: uid, petID: pet.pid, isAdding: false)
                                                }
                                            }
                                        )
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom)
                            }
                        }
                    }
                }
                .onAppear {
                    // Refresh favorites on appear
                    if let uid = Auth.auth().currentUser?.uid {
                        UserService().fetchFavorites(for: uid) { petIDs in
                            favorites = Set(petIDs)
                        }
                    }
                }
            }
        }
    }
}
