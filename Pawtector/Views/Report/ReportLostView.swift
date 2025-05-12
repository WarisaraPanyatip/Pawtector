import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct ReportLostView: View {
    @EnvironmentObject var session: SessionManager
    @EnvironmentObject var lostReportModel: LostReportModel

    @State private var imageData: Data?
    @State private var showImagePicker = false

    // Pet Fields
    @State private var selectedPetType = "Dog"
    @State private var petName = ""
    @State private var lastSeen = ""
    @State private var description = ""
    @State private var color = ""
    @State private var size = ""
    @State private var wearing = ""
    @State private var contact = ""
    @State private var reward = ""
    @State private var gender = "Male"
    @State private var age: Float = 1.0
    @State private var breed = ""
    @State private var personality = ""
    @State private var healthStatus = ""
    @State private var status = false

    // Upload State
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Stepper UI
                //stepper

                // Form UI
                formCard

                // Submit Button
                submitButton
            }
            .padding(.top)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(data: $imageData)
        }
        .alert("Report Status", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }

    // MARK: - Components
//
//    private var stepper: some View {
//        HStack(spacing: 24) {
//            stepCircle("1", active: true)
//            stepCircle("2", active: false)
//            stepCircle("3", active: false)
//        }
//        .frame(maxWidth: .infinity)
//    }
//
//    private func stepCircle(_ number: String, active: Bool) -> some View {
//        Text(number)
//            .font(.headline)
//            .foregroundColor(.white)
//            .frame(width: 36, height: 36)
//            .background(active ? Color.orange : Color.gray.opacity(0.4))
//            .clipShape(Circle())
//    }

    private var formCard: some View {
        VStack(spacing: 16) {
            groupField("Pet Name", text: $petName)
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Type").font(.subheadline).foregroundColor(.gray)
                    Picker("", selection: $selectedPetType) {
                        Text("Dog").tag("Dog")
                        Text("Cat").tag("Cat")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                VStack(alignment: .leading, spacing: 6) {
                    Text("Last Seen").font(.subheadline).foregroundColor(.gray)
                    TextField("mm/dd/yyyy", text: $lastSeen)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
            }

            groupEditor("Description", text: $description)
            groupField("Color", text: $color)
            groupField("Size", text: $size)
            groupField("Wearing", text: $wearing)
            groupField("Contact", text: $contact)
            groupField("Reward (optional)", text: $reward)
            groupField("Breed", text: $breed)

            VStack(alignment: .leading, spacing: 6) {
                Text("Gender").font(.subheadline).foregroundColor(.gray)
                Picker("", selection: $gender) {
                    Text("Male").tag("Male")
                    Text("Female").tag("Female")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Age (Years)").font(.subheadline).foregroundColor(.gray)
                Slider(value: $age, in: 0.1...20, step: 0.1)
                Text(String(format: "%.1f years", age))
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            groupField("Personality", text: $personality)
            groupField("Health Status", text: $healthStatus)

            Button(action: {
                showImagePicker = true
            }) {
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .cornerRadius(12)
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray)
                        .frame(height: 200)
                        .overlay(Text("Tap to select image").foregroundColor(.gray))
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .padding(.horizontal)
    }

    private func groupField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextField(label, text: text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }

    private func groupEditor(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            TextEditor(text: text)
                .frame(height: 100)
                .padding(4)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }

    private var submitButton: some View {
        Button(action: submitReport) {
            if isSubmitting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
            } else {
                Text("Submit")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal)
        .padding(.bottom)

    }

    // MARK: - Logic

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

        print("🧠 Image data size: \(imageData.count) bytes")

        let newID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("lost_images/\(newID).jpg")

        let uploadTask = storageRef.putData(imageData, metadata: nil)

        uploadTask.observe(.success) { _ in
            storageRef.downloadURL { url, error in
                if let url = url {
                    print("✅ Uploaded image URL: \(url)")
                    saveReportToFirestore(imageURL: url.absoluteString)
                } else {
                    print("⚠️ Failed to get download URL, saving locally instead")
                    fallbackToLocalSave()
                }
            }
        }

        uploadTask.observe(.failure) { snapshot in
            print("❌ Upload to Firebase failed, falling back to local save")
            fallbackToLocalSave()
        }

        func fallbackToLocalSave() {
            let filename = "\(newID).jpg"
            if let localURL = saveImageLocally(imageData, fileName: filename) {
                saveReportToFirestore(imageURL: localURL.absoluteString)
            } else {
                alertMessage = "Failed to upload or save image."
                showAlert = true
                isSubmitting = false
            }
        }

        func saveReportToFirestore(imageURL: String) {
            let db = Firestore.firestore()
            let newReport: [String: Any] = [
                "user_id": userID,
                "pid": newID,
                "name": petName,
                "type": selectedPetType,
                "breed": breed,
                "gender": gender,
                "age": age,
                "imageURL": imageURL,
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

    private func resetForm() {
        petName = ""
        breed = ""
        gender = "Male"
        age = 1.0
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
        imageData = nil
    }
}

func saveImageLocally(_ data: Data, fileName: String) -> URL? {
    let fileManager = FileManager.default
    let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let fileURL = directory.appendingPathComponent(fileName)

    do {
        try data.write(to: fileURL)
        print("✅ Image saved locally at: \(fileURL)")
        return fileURL
    } catch {
        print("❌ Failed to save image locally: \(error.localizedDescription)")
        return nil
    }
}

//import SwiftUI
//import FirebaseFirestore
//import FirebaseStorage
//
//struct ReportLostView: View {
//    @EnvironmentObject var session: SessionManager
//    @EnvironmentObject var lostReportModel: LostReportModel
//
//    // Form data
//    @State private var petName = ""
//    @State private var breed = ""
//    @State private var gender = "Male"
//    @State private var age: Float = 1.0
//    @State private var size = "Medium"
//    @State private var personality = ""
//    @State private var healthStatus = ""
//    @State private var lastSeenDate = Date()
//    @State private var wearing = ""
//    @State private var color = ""
//    @State private var description = ""
//    @State private var contact = ""
//    @State private var reward = ""
//    @State private var imageData: Data?
//    @State private var showImagePicker = false
//
//    // Step navigation
//    @State private var step = 1
//    @State private var isSubmitting = false
//    @State private var showAlert = false
//    @State private var alertMessage = ""
//
//    let sizes = ["Small", "Medium", "Large"]
//
//    var body: some View {
//        VStack(spacing: 24) {
//            HStack(spacing: 24) {
//                stepCircle("1", active: step == 1)
//                stepCircle("2", active: step == 2)
//                stepCircle("3", active: step == 3)
//            }
//            .padding(.top)
//
//            ScrollView {
//                VStack(spacing: 20) {
//                    Group {
//                        if step == 1 { dogDetails }
//                        else if step == 2 { lostDetails }
//                        else if step == 3 { contactReward }
//                    }
//
//                    if step < 3 {
//                        Button(action: {
//                            withAnimation { step += 1 }
//                        }) {
//                            Image(systemName: "arrow.right.circle.fill")
//                                .resizable()
//                                .frame(width: 56, height: 56)
//                                .foregroundColor(.orange)
//                        }
//                        .padding()
//                    } else {
//                        Button(action: submitReport) {
//                            Text(isSubmitting ? "Submitting..." : "Submit Report")
//                                .fontWeight(.bold)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.orange)
//                                .foregroundColor(.white)
//                                .cornerRadius(12)
//                        }
//                        .padding(.horizontal)
//                        .disabled(isSubmitting)
//                    }
//                }
//                .padding()
//            }
//        }
//        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(data: $imageData)
//        }
//        .alert("Report Status", isPresented: $showAlert) {
//            Button("OK", role: .cancel) { }
//        } message: {
//            Text(alertMessage)
//        }
//    }
//
//    // MARK: - UI Components
//
//    func stepCircle(_ number: String, active: Bool) -> some View {
//        Text(number)
//            .font(.headline)
//            .foregroundColor(.white)
//            .frame(width: 36, height: 36)
//            .background(active ? Color.orange : Color.gray.opacity(0.4))
//            .clipShape(Circle())
//    }
//
//    private var dogDetails: some View {
//        Group {
//            labeledTextField("Pet Name", text: $petName)
//            labeledTextField("Breed", text: $breed)
//
//            Picker("Gender", selection: $gender) {
//                Text("Male").tag("Male")
//                Text("Female").tag("Female")
//            }
//            .pickerStyle(SegmentedPickerStyle())
//
//            HStack {
//                Text("Size")
//                ForEach(sizes, id: \.self) { s in
//                    Button(action: { size = s }) {
//                        Text(s)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 6)
//                            .background(size == s ? Color.orange : Color.gray.opacity(0.2))
//                            .foregroundColor(size == s ? .white : .black)
//                            .cornerRadius(8)
//                    }
//                }
//            }
//
//            VStack(alignment: .leading) {
//                Text("Age: \(String(format: "%.1f", age)) years")
//                    .font(.subheadline).foregroundColor(.gray)
//                Slider(value: $age, in: 0.1...20, step: 0.1)
//            }
//
//            labeledTextField("Personality", text: $personality)
//            labeledTextField("Health Status", text: $healthStatus)
//        }
//    }
//
//    private var lostDetails: some View {
//        Group {
//            VStack(alignment: .leading) {
//                Text("Last Seen Date")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                DatePicker("Date", selection: $lastSeenDate, displayedComponents: .date)
//                    .datePickerStyle(.compact)
//            }
//
//            labeledTextField("Wearing", text: $wearing)
//            labeledTextField("Color", text: $color)
//
//            VStack(alignment: .leading) {
//                Text("Description")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                TextEditor(text: $description)
//                    .frame(height: 100)
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//            }
//
//            Button(action: {
//                showImagePicker = true
//            }) {
//                if let data = imageData, let uiImage = UIImage(data: data) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(height: 200)
//                        .clipped()
//                        .cornerRadius(12)
//                } else {
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(Color.gray)
//                        .frame(height: 200)
//                        .overlay(Text("Tap to select image").foregroundColor(.gray))
//                }
//            }
//        }
//    }
//
//    private var contactReward: some View {
//        Group {
//            TextField("Phone Number", text: $contact)
//                .keyboardType(.phonePad)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//
//            TextField("Reward", text: $reward)
//                .keyboardType(.numberPad)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//        }
//    }
//
//    private func labeledTextField(_ label: String, text: Binding<String>) -> some View {
//        VStack(alignment: .leading, spacing: 6) {
//            Text(label)
//                .font(.subheadline)
//                .foregroundColor(.gray)
//            TextField(label, text: text)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)
//        }
//    }
//
//    // MARK: - Logic
//
//    private func submitReport() {
//        guard let userID = session.currentUser?.uid else {
//            alertMessage = "You must be logged in."
//            showAlert = true
//            return
//        }
//
//        guard let imageData = imageData else {
//            alertMessage = "Please select an image."
//            showAlert = true
//            return
//        }
//
//        isSubmitting = true
//        let newID = UUID().uuidString
//        let ref = Storage.storage().reference().child("lost_images/\(newID).jpg")
//
//        ref.putData(imageData, metadata: nil) { _, error in
//            if let error = error {
//                alertMessage = "Upload failed: \(error.localizedDescription)"
//                showAlert = true
//                isSubmitting = false
//                return
//            }
//
//            ref.downloadURL { url, error in
//                guard let url = url else {
//                    alertMessage = "Image URL error"
//                    showAlert = true
//                    isSubmitting = false
//                    return
//                }
//
//                let db = Firestore.firestore()
//                let report: [String: Any] = [
//                    "user_id": userID,
//                    "pid": newID,
//                    "name": petName,
//                    "breed": breed,
//                    "gender": gender,
//                    "age": age,
//                    "size": size,
//                    "personality": personality,
//                    "healthStatus": healthStatus,
//                    "lastSeen": formattedDate(lastSeenDate),
//                    "wearing": wearing,
//                    "color": color,
//                    "description": description,
//                    "contact": contact,
//                    "reward": reward,
//                    "imageURL": url.absoluteString,
//                    "status": false
//                ]
//
//                db.collection("LostReport").document(newID).setData(report) { error in
//                    isSubmitting = false
//                    if let error = error {
//                        alertMessage = "Failed to save: \(error.localizedDescription)"
//                    } else {
//                        alertMessage = "Report submitted!"
//                        resetForm()
//                        lostReportModel.fetchLostReports()
//                    }
//                    showAlert = true
//                }
//            }
//        }
//    }
//
//    private func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        return formatter.string(from: date)
//    }
//
//    private func resetForm() {
//        petName = ""
//        breed = ""
//        gender = "Male"
//        age = 1.0
//        size = "Medium"
//        personality = ""
//        healthStatus = ""
//        lastSeenDate = Date()
//        wearing = ""
//        color = ""
//        description = ""
//        contact = ""
//        reward = ""
//        imageData = nil
//        step = 1
//    }
//}


#Preview {
    ReportLostView()
        .environmentObject(SessionManager())
        .environmentObject(LostReportModel())
}
