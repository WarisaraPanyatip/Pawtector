import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct ReportStrayView: View {
    @EnvironmentObject var session: SessionManager

    @State private var petType = "Dog"
    @State private var selectedConditions: [String] = []
    @State private var description = ""
    @State private var location = ""
    @State private var dateTime = Date()
    @State private var isStillThere = false
    @State private var contact = ""
    @State private var imageData: Data? = nil
    @State private var showImagePicker = false
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    let conditionOptions = ["Injured", "Sick", "Starving", "Aggressive", "Can't Move", "Abandoned", "Other"]

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 32) {
                    // 🧾 Instruction Box
                    VStack(alignment: .leading, spacing: 8) {
                        Text("📢 How It Works")
                            .font(.headline)
                            .foregroundColor(.brandBrown)
                        Text("🐶 Report a stray dog or cat to help them. SoiDog Foundation will assist and notify you once the animal is rescued.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    petDetailsSection
                    conditionLocationSection
                    contactSubmitSection
                }
                .padding(.top)
            }
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

    private var header: some View {
        ZStack(alignment: .top) {
            Color.brandYellow.opacity(0.2)
                .ignoresSafeArea(edges: .top)
                .frame(height: 90)

            HStack {
                Image("logo_black")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .padding(.leading)

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Report a Stray")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.brandBrown)

                    Text("Rescue them with SoiDog")
                        .font(.system(size: 14))
                        .foregroundColor(.brandBrown)
                }
                .padding(.trailing)
            }
            .padding(.top, 20)
            .padding(.horizontal)
        }
    }

    private var petDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            //Text("Pet Details").font(.headline)
            Text("Pet Details").font(.subheadline).foregroundColor(.gray)
            HStack {
                ForEach(["Dog", "Cat"], id: \.self) { type in
                    Button(action: {
                        petType = type
                    }) {
                        Text(type)
                            .fontWeight(.medium)
                            .padding()
                            .background(petType == type ? Color.brandYellow : Color(.systemGray5))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                    }
                }
            }

            groupEditor("Description", text: $description)

            Button(action: { showImagePicker = true }) {
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
        .cornerRadius(16)
//        .shadow(radius: 4)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    private var conditionLocationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
//            Text("Condition & Location").font(.headline)
            Text("Condition").font(.subheadline).foregroundColor(.gray)
            WrapHStack(items: conditionOptions) { option in
                Button(action: {
                    toggleCondition(option)
                }) {
                    Text(option)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(selectedConditions.contains(option) ? Color.brandYellow : Color(.systemGray5))
                        .foregroundColor(.black)
                        .cornerRadius(16)
                }
            }

            groupField("Location", text: $location)

            VStack(alignment: .leading) {
                Text("Date & Time Seen").font(.subheadline).foregroundColor(.gray)
                DatePicker("Date & Time", selection: $dateTime, displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
                    .datePickerStyle(CompactDatePickerStyle())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
//        .shadow(radius: 4)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    private var contactSubmitSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Submit").font(.headline)

            Toggle("Is the dog/cat still there?", isOn: $isStillThere)

//            TextField("Phone", text: $contact)
//                .keyboardType(.phonePad)
//                .padding()
//                .background(Color(.systemGray6))
//                .cornerRadius(10)

            Button(action: submitReport) {
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width: 56, height: 56)
                        .background(Color.gray)
                        .clipShape(Circle())
                } else {
                    Text("Submit Report")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandYellow)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .disabled(isSubmitting)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .padding(.bottom)
    }

    private func groupField(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.subheadline).foregroundColor(.gray)
            TextField(label, text: text)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }

    private func groupEditor(_ label: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.subheadline).foregroundColor(.gray)
            TextEditor(text: text)
                .frame(height: 100)
                .padding(4)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
    }

    private func toggleCondition(_ option: String) {
        if let index = selectedConditions.firstIndex(of: option) {
            selectedConditions.remove(at: index)
        } else {
            selectedConditions.append(option)
        }
    }

    private func submitReport() {
        guard let uid = session.currentUser?.uid else {
            alertMessage = "You must be logged in."
            showAlert = true
            return
        }

        let sid = UUID().uuidString
        isSubmitting = true

        func saveToFirestore(imageURL: String) {
            let db = Firestore.firestore()
            let newReport: [String: Any] = [
                "sid": sid,
                "petType": petType,
                "condition": selectedConditions.joined(separator: ", "),
                "description": description,
                "location": location,
                "dateTime": formattedDate(dateTime),
                "isStillThere": isStillThere,
                "contact": contact,
                "imageName": imageURL,
                "user_id": uid,
                "createdAt": Timestamp(date: Date())
            ]

            db.collection("StrayReport").document(sid).setData(newReport) { error in
                isSubmitting = false
                if let error = error {
                    alertMessage = "Failed to submit: \(error.localizedDescription)"
                } else {
                    alertMessage = "Report sent to the rescue team."
                    resetForm()
                }
                showAlert = true
            }
        }

        if let imageData = imageData {
            let ref = Storage.storage().reference().child("stray_images/\(sid).jpg")
            ref.putData(imageData, metadata: nil) { _, error in
                if let error = error {
                    saveToFirestore(imageURL: "")
                } else {
                    ref.downloadURL { url, _ in
                        saveToFirestore(imageURL: url?.absoluteString ?? "")
                    }
                }
            }
        } else {
            saveToFirestore(imageURL: "")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }

    private func resetForm() {
        petType = "Dog"
        selectedConditions = []
        description = ""
        location = ""
        dateTime = Date()
        isStillThere = false
        contact = ""
        imageData = nil
    }
}

struct WrapHStack<Content: View, T: Hashable>: View {
    var items: [T]
    var spacing: CGFloat = 8
    var alignment: HorizontalAlignment = .leading
    var content: (T) -> Content

    @State private var totalHeight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
        .frame(height: totalHeight)
    }

    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: Alignment(horizontal: alignment, vertical: .top)) {
            ForEach(items, id: \.self) { item in
                content(item)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > geometry.size.width {
                            width = 0
                            height -= d.height + spacing
                        }
                        let result = width
                        if item == items.last {
                            width = 0
                        } else {
                            width -= d.width + spacing
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if item == items.last {
                            height = 0
                        }
                        return result
                    })
            }
        }
        .background(viewHeightReader())
    }

    private func viewHeightReader() -> some View {
        GeometryReader { geometry -> Color in
            DispatchQueue.main.async {
                self.totalHeight = geometry.size.height
            }
            return Color.clear
        }
    }
}
