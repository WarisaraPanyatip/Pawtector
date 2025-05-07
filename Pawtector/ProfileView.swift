import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Profile")
                    .font(.largeTitle)
                    .bold()

                Circle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(width: 140, height: 140)
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.purple)
                    )

                // Username display
                Text(session.currentUser?.username ?? "User")
                    .font(.headline)

                // Phone number display
                if let phone = session.currentUser?.phone {
                    Text("\(phone)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Edit profile navigation
                NavigationLink(destination: EditProfileView()) {
                    ProfileActionButton(label: "Edit Profile", icon: "pencil", bgColor: .cyan.opacity(0.3))
                }

                // Adoption history (temporarily disabled)
                // NavigationLink(destination: AdoptionHistoryView()) {
                //     ProfileActionButton(label: "Adoption History", icon: "clock.arrow.circlepath", bgColor: .cyan.opacity(0.4))
                // }

                // Instructions navigation
                NavigationLink(destination: InstructionsView()) {
                    ProfileActionButton(label: "How to Use", icon: "info.circle", bgColor: .cyan.opacity(0.5))
                }

                // Logout button
                Button(action: {
                    session.signOut()
                }) {
                    ProfileActionButton(label: "Log Out", icon: "arrow.right.square", bgColor: .cyan.opacity(0.6))
                }

                Spacer()
            }
            .padding()
        }
    }
}

struct ProfileActionButton: View {
    var label: String
    var icon: String
    var bgColor: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(label)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(bgColor)
        .cornerRadius(8)
        .foregroundColor(.white)
        .padding(.horizontal)
    }
}
