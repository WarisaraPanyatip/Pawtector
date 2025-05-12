import SwiftUI
import Firebase

@main
struct PawtectorApp: App {
    @StateObject var sessionManager = SessionManager()
    @StateObject var petViewModel = PetViewModel()
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            WelcomeView()
                .environmentObject(sessionManager)
                .environmentObject(petViewModel)
        }
    }
}
