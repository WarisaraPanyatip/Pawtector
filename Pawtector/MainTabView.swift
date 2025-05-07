import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomePageView(pets: Pet.sampleData)
                .environmentObject(SessionManager()) // Adoption Marketplace
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Adopt")
                }

            ReportStrayView() // Stray animal reporting
                .tabItem {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Report Stray")
                }

            LostAndFoundView() // Lost/found pet listing
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Lost & Found")
                }

            ProfileView() // User profile / settings
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}
