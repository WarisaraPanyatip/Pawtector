import SwiftUI

struct EditProfileView: View {
    @State private var username = ""
    @State private var gender = "Male"
    @State private var email = ""
    @State private var phone = ""
    @State private var showToast = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 20) {
                    Text("Edit profile")
                        .font(.headline)

                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.purple)

                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Picker("Gender", selection: $gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Phone Number", text: $phone)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Save") {
                        print("Saved changes for \(username)")
                        withAnimation {
                            showToast = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showToast = false
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.3))
                    .cornerRadius(8)

                    Spacer()
                }
                .padding()

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
        }
    }
}


