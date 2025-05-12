// MARK: - ReportLostView

import SwiftUI
import FirebaseFirestore

struct ReportLostView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var lostReportModel: LostReportModel
    @State private var imageData: Data?
    @State private var showImagePicker = false
    @State private var selectedPetType = "Dog"
    @State private var petName = ""
    @State private var lastSeen = ""
    @State private var description = ""
    @State private var color = ""
    @State private var size = ""
    @State private var wearing = ""
    @State private var contact = ""
    @State private var reward = ""
    @State private var imageURL = "placeholder" // Default placeholder image
    @State private var gender = "Male"
    @State private var age: Float = 1.0
    @State private var breed = ""
    @State private var personality = ""
    @State private var healthStatus = ""
    @State private var status = false
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Color.clear.frame(height: 40)

                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            Text("Pet Name").font(.subheadline)
                            TextField("Enter pet's name", text: $petName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Type").font(.subheadline)
                                    Picker("Type", selection: $selectedPetType) {
                                        Text("Cat").tag("Cat")
                                        Text("Dog").tag("Dog")
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                }

                                Spacer()

                                VStack(alignment: .leading) {
                                    Text("Last Seen").font(.subheadline)
                                    TextField("mm/dd/yyyy", text: $lastSeen)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .frame(width: 130)
                                }
                            }

                            Text("Description").font(.subheadline)
                            TextEditor(text: $description)
                                .frame(height: 100)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                        }

                        Group {
                            Text("Color").font(.subheadline)
                            TextField("Describe color", text: $color)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Size").font(.subheadline)
                            TextField("Small / Medium / Large", text: $size)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Wearing").font(.subheadline)
                            TextField("e.g. red collar, shirt", text: $wearing)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Contact Number").font(.subheadline)
                            TextField("Your phone number", text: $contact)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Reward (optional)").font(.subheadline)
                            TextField("$0", text: $reward)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numbersAndPunctuation)
                        }

                        Group {
                            Text("Breed").font(.subheadline)
                            TextField("Breed", text: $breed)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Gender").font(.subheadline)
                            Picker("Gender", selection: $gender) {
                                Text("Male").tag("Male")
                                Text("Female").tag("Female")
                            }
                            .pickerStyle(SegmentedPickerStyle())

                            Text("Age (Years)").font(.subheadline)
                            Slider(value: $age, in: 0.1...20, step: 0.1) {
                                Text("Age")
                            }
                            Text(String(format: "%.1f years", age))
                                .font(.caption)

                            Text("Personality").font(.subheadline)
                            TextField("e.g. friendly, shy", text: $personality)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Text("Health Status").font(.subheadline)
                            TextField("e.g. injured, healthy", text: $healthStatus)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                showImagePicker = true
                            }) {
                                if let data = imageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(12)
                                } else {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray)
                                        .frame(height: 200)
                                        .overlay(Text("Tap to select image"))
                                }
                            }
                            .sheet(isPresented: $showImagePicker) {
                                ImagePicker(data: $imageData)
                            }

                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top)

                    Button(action: submitReport) {
                        if isSubmitting {
                            ProgressView()
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .cornerRadius(12)
                        } else {
                            Text("Send Report")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#77BED1"))
                                .cornerRadius(12)
                        }
                    }
                    .disabled(isSubmitting)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .alert("Report Status", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    private func submitReport() {
        isSubmitting = true

        guard let userID = session.currentUser?.uid else {
            alertMessage = "You must be logged in to submit a report."
            showAlert = true
            isSubmitting = false
            return
        }

        guard let imageData = imageData else {
            alertMessage = "Please select an image."
            showAlert = true
            isSubmitting = false
            return
        }

        let newID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("lost_images/\(newID).jpg")

        let uploadTask = storageRef.putData(imageData, metadata: nil)

        uploadTask.observe(.success) { _ in
            storageRef.downloadURL { url, error in
                if let error = error {
                    alertMessage = "Failed to retrieve image URL: \(error.localizedDescription)"
                    showAlert = true
                    isSubmitting = false
                    return
                }

                guard let imageUrl = url?.absoluteString else {
                    alertMessage = "Invalid image URL."
                    showAlert = true
                    isSubmitting = false
                    return
                }

                let db = Firestore.firestore()
                let newReport: [String: Any] = [
                    "user_id": userID,
                    "pid": newID,
                    "name": petName,
                    "type": selectedPetType,
                    "breed": breed,
                    "gender": gender,
                    "age": age,
                    "imageURL": imageUrl, // ✅ CORRECT HERE
                    "healthStatus": healthStatus,
                    "personality": personality,
                    "status": status,
                    "reward": reward,
                    "lastSeen": lastSeen,
                    "description": description,
                    "contact": contact,
                    "color": color,
                    "size": size,
                    "wearing": wearing
                ]

                db.collection("LostReport").document(newID).setData(newReport) { error in
                    isSubmitting = false
                    if let error = error {
                        alertMessage = "Failed to submit report: \(error.localizedDescription)"
                    } else {
                        alertMessage = "Report submitted successfully."
                        resetForm()
                        lostReportModel.fetchLostReports()
                    }
                    showAlert = true
                }
            }
        }

        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error {
                alertMessage = "Image upload failed: \(error.localizedDescription)"
                showAlert = true
                isSubmitting = false
            }
        }

    }

    private func resetForm() {
        petName = ""
        breed = ""
        gender = "Male"
        age = 1.0
        imageURL = "placeholder"
        healthStatus = ""
        personality = ""
        status = false
        reward = ""
        lastSeen = ""
        description = ""
        contact = ""
        color = ""
        size = ""
        wearing = ""
    }
}
