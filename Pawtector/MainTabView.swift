import SwiftUI
import FirebaseAuth

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var favorites: Set<String> = []
    @StateObject private var petViewModel = PetViewModel()
    @State private var sessionManager = SessionManager()
    @StateObject private var lostReportModel = LostReportModel()

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    NavigationStack {
                        HomePageView(
                            pets: petViewModel.pets,
                            favorites: $favorites,
                            selectedTab: $selectedTab
                        )
                        .environmentObject(sessionManager)
                    }

                case 1:
                    NavigationStack {
                            FavoriteView(
                                pets: petViewModel.pets,
                                favorites: $favorites,
                                selectedTab: $selectedTab
                            )
                        }
                case 2:
                    NavigationStack {
                        ReportStraytView()
                    }
                case 3:
                    NavigationStack {
                        LostAndFoundView()
                            .environmentObject(lostReportModel)
                    }
                case 4:
                    NavigationStack {
                        ProfileView()
                    }

                default:
                    NavigationStack {
                        HomePageView(
                            pets: petViewModel.pets,
                            favorites: $favorites,
                            selectedTab: $selectedTab
                        )
                        .environmentObject(sessionManager)
                    }
                }
            }
            .padding(.bottom, 80)
            .ignoresSafeArea(.keyboard)

            VStack {
                Spacer()
                FloatingTabBar(selectedTab: $selectedTab)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            loadFavoritesForCurrentUser()
        }
    }

    private func loadFavoritesForCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService().fetchFavorites(for: uid) { petIDs in
            favorites = Set(petIDs)
        }
    }
}
