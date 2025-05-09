import SwiftUI

struct ReportStraytView: View {
    @State private var petType = "Dog"
    @State private var condition = ""
    @State private var description = ""
    @State private var location = ""
    @State private var dateTime = ""
    @State private var isStillThere = false
    @State private var contact = ""
    @State private var submitted = false

    let conditionOptions = [
        "Injured", "Sick", "Starving", "Aggressive", "Can't Move", "Abandoned", "Other"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                
                HStack(alignment: .center) {
                    Image("logo_white")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.leading, 16)

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Lost & Found")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("help them find the way home")
                            .font(.footnote)
                            .foregroundColor(Color(hex: "#FDBC33"))
                    }
                    .padding(.trailing, 16)
                }
                .padding(.top, 16)

                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        Text("Pet Type")
                            .font(.subheadline)

                        Picker("Pet Type", selection: $petType) {
                            Text("Cat").tag("Cat")
                            Text("Dog").tag("Dog")
                        }
                        .pickerStyle(SegmentedPickerStyle())

                        Text("Condition")
                            .font(.subheadline)

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

                        Text("Description")
                            .font(.subheadline)
                        TextEditor(text: $description)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    }

                    Group {
                        Text("Location")
                            .font(.subheadline)
                        TextField("e.g. Soi 22 near 7-11", text: $location)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Text("Date & Time Seen")
                            .font(.subheadline)
                        TextField("e.g. 09/05/2025 15:30", text: $dateTime)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Toggle("Is the animal still at the location?", isOn: $isStillThere)

                        Text("Contact Info")
                            .font(.subheadline)
                        TextField("Phone or social", text: $contact)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Text("Upload Photo")
                            .font(.subheadline)
                        Button(action: {
                            // Photo picker logic here
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
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
                .padding(.horizontal)

                Button(action: {
                    // Submit action
                    submitted = true
                }) {
                    Text("Submit Report")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#E74C3C")) // Red for urgency
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .alert(isPresented: $submitted) {
            Alert(
                title: Text("Thank you"),
                message: Text("Your report has been sent to the rescue team."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    ReportStraytView()
}

