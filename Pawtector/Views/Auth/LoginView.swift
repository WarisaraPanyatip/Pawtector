import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var rememberMe = false
    @State private var errorMessage: String?
    @State private var showAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var session: SessionManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Title
                Text("Welcome back!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(red: 0.57, green: 0.76, blue: 0.85))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)

                // Email field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email address")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color(red: 0.95, green: 0.70, blue: 0.16))

                    TextField("Enter your email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.95, green: 0.70, blue: 0.16), lineWidth: 1)
                        )
                }

                // Password field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color(red: 0.95, green: 0.70, blue: 0.16))

                    HStack {
                        if isSecure {
                            SecureField("Password", text: $password)
                        } else {
                            TextField("Password", text: $password)
                        }

                        Button(action: {
                            isSecure.toggle()
                        }) {
                            Image(systemName: isSecure ? "eye.slash" : "eye")
                                .foregroundColor(Color(red: 0.95, green: 0.70, blue: 0.16))
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.95, green: 0.70, blue: 0.16), lineWidth: 1)
                    )
                }

                // Remember me and forgot password
                HStack {
                    Button(action: {
                        rememberMe.toggle()
                    }) {
                        Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                            .foregroundColor(Color(red: 0.49, green: 0.77, blue: 0.89))
                    }

                    Text("Remember me")
                        .font(.system(size: 13))
                        .foregroundColor(Color(red: 0.49, green: 0.77, blue: 0.89))

                    Spacer()

                    Button(action: {
                        sendPasswordReset()
                    }) {
                        Text("Forgot password?")
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 0.57, green: 0.76, blue: 0.85))
                    }
                }

                // Error message
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }

                // Login button
                Button(action: {
                    loginUser()
                }) {
                    Text("Login")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.57, green: 0.76, blue: 0.85))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                // -------------------------------------------No socials login-------------------------------------------
                // Divider with "Login with"
//                HStack {
//                    Rectangle()
//                        .fill(Color(red: 0.95, green: 0.70, blue: 0.16))
//                        .frame(height: 1)
//                    Text("Login with")
//                        .font(.system(size: 14, weight: .bold))
//                        .foregroundColor(Color(red: 0.95, green: 0.70, blue: 0.16))
//                    Rectangle()
//                        .fill(Color(red: 0.95, green: 0.70, blue: 0.16))
//                        .frame(height: 1)
//                }
//
//                // Social login icons (placeholder)
//                HStack(spacing: 32) {
//                    Image("facebook_icon")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 36, height: 36)
//
//                    Image("google_icon")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 36, height: 36)
//
//                    Image(systemName: "apple.logo")
//                        .font(.system(size: 30))
//                        .foregroundColor(.black)
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 4)

                // Signup link
                HStack {
                    Text("Don’t have an account?")
                        .font(.footnote)
                        .foregroundColor(Color.gray)

                    NavigationLink(destination: SignupDetailsView().environmentObject(session)) {
                        Text("Sign up")
                            .font(.footnote)
                            .bold()
                            .foregroundColor(Color(red: 0.57, green: 0.76, blue: 0.85))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                Spacer()
            }
            .padding(24)
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadSavedCredentials()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Password Reset"),
                      message: Text(alertMessage),
                      dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Functions

    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                if rememberMe {
                    saveCredentials()
                } else {
                    clearSavedCredentials()
                }
                session.isLoggedIn = true
                dismiss()
            }
        }
    }

    private func sendPasswordReset() {
        guard !email.isEmpty else {
            self.alertMessage = "Please enter your email address to reset your password."
            self.showAlert = true
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.alertMessage = error.localizedDescription
            } else {
                self.alertMessage = "A password reset email has been sent to \(email)."
            }
            self.showAlert = true
        }
    }

    private func saveCredentials() {
        UserDefaults.standard.set(email, forKey: "savedEmail")
        UserDefaults.standard.set(password, forKey: "savedPassword")
    }

    private func loadSavedCredentials() {
        if let savedEmail = UserDefaults.standard.string(forKey: "savedEmail"),
           let savedPassword = UserDefaults.standard.string(forKey: "savedPassword") {
            email = savedEmail
            password = savedPassword
            rememberMe = true
        }
    }

    private func clearSavedCredentials() {
        UserDefaults.standard.removeObject(forKey: "savedEmail")
        UserDefaults.standard.removeObject(forKey: "savedPassword")
    }
}
