import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct EditProfileView: View {
    @State private var username = ""
    @State private var showToast = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground).ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 1) {
                        Text("Edit Profile")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.brandBrown)

                        Text("Update your username")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    // Profile Icon
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


                    // Input Card
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Username")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        TextField("Enter your username", text: $username)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)

                    // Save Button
                    Button(action: saveProfile) {
                        Text("Save Changes")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.brandYellow)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 3)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 40)
            }

            // Toast Notification
            if showToast {
                VStack {
                    Spacer()
                    Text("✅ Profile updated")
                        .font(.subheadline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial)
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .padding(.bottom, 50)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.easeInOut, value: showToast)
            }
        }
    }

    private func saveProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(uid).updateData([
            "username": username
        ]) { error in
            if let error = error {
                print("Error updating profile: \(error.localizedDescription)")
            } else {
                withAnimation {
                    showToast = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showToast = false
                    }
                }
            }
        }
    }
}
