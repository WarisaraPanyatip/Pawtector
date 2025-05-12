import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct ReportStraytView: View {
    @EnvironmentObject var session: SessionManager
    @State private var petType = "Dog"
    @State private var condition = ""
    @State private var description = ""
    @State private var location = ""
    @State private var dateTime = ""
    @State private var isStillThere = false
    @State private var contact = ""
    @State private var imageName = "placeholder"
    @State private var imageData: Data? = nil
    @State private var submitted = false
    @State private var isSubmitting = false
    @State private var showImagePicker = false

    let conditionOptions = [
        "Injured", "Sick", "Starving", "Aggressive", "Can't Move", "Abandoned", "Other"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                formSection

                Button(action: submitReport) {
                    if isSubmitting {
                        ProgressView()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(12)
                    } else {
                        Text("Submit Report")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#E74C3C"))
                            .cornerRadius(12)
                    }
                }
                .disabled(isSubmitting)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(data: $imageData)
        }
        .alert(isPresented: $submitted) {
            Alert(
                title: Text("Thank you"),
                message: Text("Your report has been sent to the rescue team."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            Image("logo_black")
                .resizable()
                .frame(width: 60, height: 60)
                .padding(.leading, 16)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("Report a Stray")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text("rescue them by SoiDog")
                    .font(.footnote)
                    .foregroundColor(Color.brown)
            }
            .padding(.trailing, 16)
        }
        .padding(.top, 16)
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Picker("Pet Type", selection: $petType) {
                Text("Cat").tag("Cat")
                Text("Dog").tag("Dog")
            }
            .pickerStyle(SegmentedPickerStyle())

            Menu {
                ForEach(conditionOptions, id: \.self) { option in
                    Button(option) {
                        condition = option
                    }
                }
            } label: {
                HStack {
                    Text(condition.isEmpty ? "Select condition" : condition)
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }

            TextEditor(text: $description)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))

            TextField("e.g. Soi 22 near 7-11", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("e.g. 09/05/2025 15:30", text: $dateTime)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Toggle("Is the animal still at the location?", isOn: $isStillThere)

            TextField("Phone or social", text: $contact)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                showImagePicker = true
            }) {
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }

    private func submitReport() {
        guard let uid = session.currentUser?.uid else { return }
        isSubmitting = true

        let sid = UUID().uuidString

        func saveToFirestore(imageURL: String) {
            let db = Firestore.firestore()
            let newReport: [String: Any] = [
                "sid": sid,
                "petType": petType,
                "condition": condition,
                "description": description,
                "location": location,
                "dateTime": dateTime,
                "isStillThere": isStillThere,
                "contact": contact,
                "imageName": imageURL,
                "user_id": uid,
                "createdAt": Timestamp(date: Date())
            ]

            db.collection("StrayReport").document(sid).setData(newReport) { error in
                isSubmitting = false
                submitted = true
            }
        }

        if let imageData = imageData {
            let ref = Storage.storage().reference().child("stray_images/\(sid).jpg")
            ref.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    print("❌ Image upload failed: \(error.localizedDescription)")
                    saveToFirestore(imageURL: "")
                } else {
                    ref.downloadURL { url, error in
                        saveToFirestore(imageURL: url?.absoluteString ?? "")
                    }
                }
            }
        } else {
            saveToFirestore(imageURL: "")
        }
    }
}


#Preview {
    ReportStraytView()
        .environmentObject(SessionManager())
}
