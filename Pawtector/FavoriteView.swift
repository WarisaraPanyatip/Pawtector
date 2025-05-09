
// MARK: - Favorite View
import SwiftUI

struct FavoriteView: View {
    let pets: [Pet]
    @Binding var favorites: Set<UUID>
    @Binding var selectedTab: Int

    private let columns = [GridItem(.adaptive(minimum: 150), spacing: 16)]

    var favoritePets: [Pet] {
        pets.filter { favorites.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button {
                        selectedTab = 0 // Back to home
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }

                    Spacer()

                    Text("Favorites")
                        .font(.largeTitle).bold()

                    Spacer()
                    Image(systemName: "chevron.left")
                        .opacity(0) // Spacer
                }
                .padding()

                if favoritePets.isEmpty {
                    Spacer()
                    Text("You have no favorites")
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
                                        favorites.remove(pet.id)
                                    }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

