import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RequestAdoptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var requestSent: Bool

    let petId: String // Pass the pet's ID into this view

    @State private var showingAlert = false
    @State private var sending = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.brandYellow)

            Text("Request to adopt")
                .font(.largeTitle).bold()
                .foregroundColor(.brandBlue)

            Text("After requesting, the foundation will contact you back in a few days.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

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
            .padding(.horizontal)
            .disabled(sending)
            .alert("Your request was sent", isPresented: $showingAlert) {
                Button("OK") {
                    requestSent = true
                    dismiss()
                }
            } message: {
                Text("Foundation will contact you soon")
            }
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }

    private func sendAdoptionRequest() {
        guard let user = Auth.auth().currentUser else { return }
        let docId = "\(user.uid)_\(petId)"
        let db = Firestore.firestore()

        let requestData: [String: Any] = [
            "userId": user.uid,
            "petId": petId,
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
                // Optionally: trigger email via backend or cloud function
                showingAlert = true
            }
        }
    }
}
