import SwiftUI
import FirebaseAuth

struct WelcomeView: View {
    @StateObject private var sessionManager = SessionManager()
    @State private var rootViewId = UUID() // Used to reset the NavigationStack

    var body: some View {
        NavigationStack {
            if sessionManager.isLoggedIn {
                MainTabView()
            } else {
                // Show login/signup
                ZStack {
                    // Background gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.63, green: 0.85, blue: 0.92),
                            Color(red: 0.98, green: 0.88, blue: 0.55)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()

                    VStack(spacing: 30) {
                        // Header label
                        HStack {
                            Text("Sign up")
                                .foregroundColor(Color(red: 0.64, green: 0.81, blue: 1.0))
                                .font(.system(size: 18, weight: .medium))
                                .padding(.top, 50)
                                .padding(.leading, 20)
                            Spacer()
                        }

                        Spacer()

                        // Icon
                        Image("logo_white")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 150)

                        // App name
                        Text("Pawtector")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)

                        // Tagline
                        VStack(spacing: 5) {
                            Text("From Lost to Loved")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            Text("— Pawtector's Got Their Back")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 30)
                        }

                        // Buttons
                        HStack(spacing: 20) {
                            NavigationLink(destination: LoginView().environmentObject(sessionManager)) {
                                Text("Log in")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding()
                                    .frame(width: 130)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                    .foregroundColor(.white)
                            }

                            NavigationLink(destination: SignupDetailsView().environmentObject(sessionManager)) {
                                Text("Sign up")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding()
                                    .frame(width: 130)
                                    .background(Color.white)
                                    .foregroundColor(Color(red: 0.36, green: 0.67, blue: 0.78))
                                    .cornerRadius(12)
                            }
                        }
                        .padding(.top, 10)

                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .id(rootViewId) // Reset NavigationStack when rootViewId changes
        .environmentObject(sessionManager)
        .onChange(of: sessionManager.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                rootViewId = UUID() // Trigger NavigationStack reset
            }
        }
    }
}

#Preview {
    WelcomeView()
}
