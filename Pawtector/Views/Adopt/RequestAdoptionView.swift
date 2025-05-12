import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RequestAdoptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var requestSent: Bool

    let petId: String
    let petName: String 
    @State private var showingAlert = false
    @State private var sending = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // MARK: - Dismiss Button
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.brandBrown)
                            .padding(10)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding()
                }

                Spacer()

                // MARK: - Logo
                Image("logo_soidog")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 4)

                // MARK: - Title
                Text("Request to adopt")
                    .font(.largeTitle).bold()
                    .foregroundColor(.brandBrown)

                Text("After requesting, the foundation will contact you back in a few days.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 32)

                Spacer()

                // MARK: - Confirmation Button
                Button(action: {
                    sendAdoptionRequest()
                }) {
                    if sending {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Request confirmation")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.brandYellow)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 32)
                .padding(.bottom, 40) // give breathing space
                .disabled(sending)
            }
            .background(Color(.systemGray6))
            .ignoresSafeArea()
            .alert("Your request was sent", isPresented: $showingAlert) {
                Button("OK") {
                    requestSent = true
                    dismiss()
                }
            } message: {
                Text("Foundation will contact you soon")
            }
        }
    }

    private func sendAdoptionRequest() {
        guard let user = Auth.auth().currentUser else { return }
        let docId = "\(user.uid)_\(petId)"
        let db = Firestore.firestore()

        let rid = UUID().uuidString

        let requestData: [String: Any] = [
            "rid": rid,
            "userId": user.uid,
            "petId": petId,
            "petName": petName, // ✅ Save pet name
            "status": "pending",
            "timestamp": Timestamp(date: Date())
        ]

        sending = true
        db.collection("AdoptionRequest").document(docId).setData(requestData) { error in
            sending = false
            if let error = error {
                print("Failed to send adoption request: \(error.localizedDescription)")
            } else {
                print("Adoption request stored in Firestore")
                showingAlert = true
            }
        }
    }
}
