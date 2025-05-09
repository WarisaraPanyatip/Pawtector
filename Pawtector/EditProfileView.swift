import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct EditProfileView: View {
    @State private var username = ""
    @State private var showToast = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                Text("Edit Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.brandBlue)
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.brandBlue.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Username")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("Enter your username", text: $username)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                
                Button(action: {
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
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandYellow)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                
                // Toast Notification
                if showToast {
                    VStack {
                        Spacer()
                        Text("✅ Profile saved successfully")
                            .font(.subheadline)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.bottom, 50)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
