import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var session: SessionManager

    var body: some View {
        VStack(spacing: 24) {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.brandBrown)

            Circle()
                .fill(Color.brandYellow.opacity(0.2))
                .frame(width: 140, height: 140)
                .overlay(
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.brandYellow)
                )

            // Username
            Text(session.currentUser?.username ?? "User")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.brandBrown)

            // Phone number
            if let phone = session.currentUser?.phone {
                Text(phone)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(spacing: 12) {
                NavigationLink(destination: EditProfileView()) {
                    ProfileActionButton(label: "Edit Profile", icon: "pencil", bgColor: Color.brandBlue.opacity(0.7))
                }

                NavigationLink(destination: InstructionsView()) {
                    ProfileActionButton(label: "How to Use", icon: "info.circle", bgColor: Color.brandBlue.opacity(0.5))
                }

                Button(action: {
                    session.signOut()
                }) {
                    ProfileActionButton(label: "Log Out", icon: "arrow.right.square", bgColor: Color.brandBlue.opacity(0.4))
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ProfileActionButton: View {
    var label: String
    var icon: String
    var bgColor: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
            Text(label)
                .fontWeight(.medium)
            Spacer()
        }
        .foregroundColor(.white)
        .padding()
        .background(bgColor)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
