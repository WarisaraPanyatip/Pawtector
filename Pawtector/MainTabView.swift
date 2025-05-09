import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var favorites: Set<UUID> = []

    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case 0:
                    NavigationStack {
                        HomePageView(
                            pets: Pet.sampleData,
                            favorites: $favorites,
                            selectedTab: $selectedTab
                        )
                        .environmentObject(SessionManager())
                    }
                case 1:
                    NavigationStack {
                        FavoriteView(
                            pets: Pet.sampleData,
                            favorites: $favorites,
                            selectedTab: $selectedTab
                        )
                    }
                case 2:
                    NavigationStack {
                        ReportStrayView()
                    }
                case 3:
                    NavigationStack {
                        LostAndFoundView()
                    }
                case 4:
                    NavigationStack {
                        ProfileView()
                    }
                default:
                    NavigationStack {
                        HomePageView(
                            pets: Pet.sampleData,
                            favorites: $favorites,
                            selectedTab: $selectedTab
                        )
                        .environmentObject(SessionManager())
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
    }
}
