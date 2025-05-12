import SwiftUI
import FirebaseAuth

struct FavoriteView: View {
    let pets: [Pet]
    @Binding var favorites: Set<String> // ✅ Now using String (pid)
    @Binding var selectedTab: Int

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    // Filter pets that are favorited by pid
    var favoritePets: [Pet] {
        pets.filter { favorites.contains($0.pid) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - Header
                HStack {
                    Button {
                        selectedTab = 0 // Back to Home tab
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.brandBrown)
                    }

                    Spacer()

                    Text("Favorites")
                        .font(.largeTitle.bold())

                    Spacer()

                    Image(systemName: "chevron.left")
                        .opacity(0) // Spacer
                }
                .padding()

                // MARK: - Content
                if favoritePets.isEmpty {
                    Spacer()
                    Text("You have no favorites yet.")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
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
            .background(Color(.systemGray6).ignoresSafeArea())
            .onAppear {
                // 🔄 Load user favorites from Firestore on open
                if let uid = Auth.auth().currentUser?.uid {
                    UserService().fetchFavorites(for: uid) { petIDs in
                        favorites = Set(petIDs)
                    }
                }
            }
        }
    }
}
