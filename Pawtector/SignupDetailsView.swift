import SwiftUI
import FirebaseAuth

struct SignupDetailsView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var phone = ""
    @State private var isSecure = true
    @State private var agreedToTerms = false
    @State private var errorMessage: String?
    @EnvironmentObject var session: SessionManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                // Title
                Text("Get started")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(Color(red: 0.57, green: 0.76, blue: 0.85))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)

                // Username Field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Username")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color(red: 0.95, green: 0.70, blue: 0.16))

                    TextField("Enter your username", text: $username)
                        .autocapitalization(.none)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.95, green: 0.70, blue: 0.16), lineWidth: 1)
                        )
                }

                // Email Field
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

                // Phone Number Field
                VStack(alignment: .leading, spacing: 6) {
                    Text("Phone Number")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color(red: 0.95, green: 0.70, blue: 0.16))

                    TextField("Enter your phone number", text: $phone)
                        .keyboardType(.numberPad)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(red: 0.95, green: 0.70, blue: 0.16), lineWidth: 1)
                        )
                }

                // Password Field
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

                // Terms Checkbox
                HStack(alignment: .center) {
                    Button(action: {
                        agreedToTerms.toggle()
                    }) {
                        Image(systemName: agreedToTerms ? "checkmark.square.fill" : "square")
                            .foregroundColor(Color(red: 0.49, green: 0.77, blue: 0.89))
                    }

                    Text("I agree with the Terms of Service and Privacy policy")
                        .font(.system(size: 13))
                        .foregroundColor(Color(red: 0.49, green: 0.77, blue: 0.89))
                }

                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                }

                // Sign Up Button
                Button(action: {
                    signUpUser()
                }) {
                    Text("Sign up")
                        .font(.system(size: 16, weight: .bold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.57, green: 0.76, blue: 0.85))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 10)

                
                // -------------------------------------------No socials login-------------------------------------------
                // Divider with label
//                HStack {
//                    Rectangle()
//                        .fill(Color(red: 0.95, green: 0.70, blue: 0.16))
//                        .frame(height: 1)
//                    Text("Sign up")
//                        .font(.system(size: 14, weight: .bold))
//                        .foregroundColor(Color(red: 0.95, green: 0.70, blue: 0.16))
//                    Rectangle()
//                        .fill(Color(red: 0.95, green: 0.70, blue: 0.16))
//                        .frame(height: 1)
//                }
//
//                // Social Sign-Up Icons
//                HStack(spacing: 32) {
//                    Image("facebook_icon")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 36, height: 36)
//                        .accessibilityLabel("Sign up with Facebook")
//
//                    Image("google_icon")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 36, height: 36)
//                        .accessibilityLabel("Sign up with Google")
//
//                    Image(systemName: "apple.logo")
//                        .font(.system(size: 30))
//                        .foregroundColor(.black)
//                        .accessibilityLabel("Sign up with Apple")
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 4)

                // Login Link
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                        .foregroundColor(Color.gray)

                    NavigationLink(destination: LoginView().environmentObject(session)) {
                        Text("Login")
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
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
        }
    }

    private func signUpUser() {
        guard agreedToTerms else {
            errorMessage = "Please agree to the terms first"
            return
        }

        guard validatePhoneNumber(phone) else {
            errorMessage = "Please enter a valid 10-digit phone number"
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if let user = result?.user {
                UserService().createUserInFirestore(user: user, username: username, phone: phone)
                session.isLoggedIn = true
                dismiss() // Dismiss the SignupDeialsView after successful signup
            }
        }
    }

    private func validatePhoneNumber(_ number: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: number)
    }
}
