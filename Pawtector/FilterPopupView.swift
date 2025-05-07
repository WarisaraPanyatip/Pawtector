import SwiftUI

struct FilterPopupView: View {
    @Environment(\.dismiss) var dismiss

    // State variables
    @State private var selectedType = "All"
    @State private var selectedGender = "Male"
    @State private var isSterilized = false
    @State private var age = 2
    @State private var ageUnit = "Year"
    @State private var selectedColoration = ""
    @State private var selectedCity = ""

    let types = ["All", "Cats", "Dogs"]
    let genders = ["Male", "Female"]
    let units = ["Year", "Month"]
    let colorOptions = ["White", "Black", "Brown", "Golden"]
    let cityOptions = ["Bangkok", "Chiang Mai", "Phuket", "Khon Kaen"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    HStack {
                        Text("Filter")
                            .font(.system(size: 28, weight: .bold))
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.bottom, 10)

                    // Type
                    Group {
                        Text("Type").bold()
                        HStack {
                            ForEach(types, id: \.self) { type in
                                Button(action: {
                                    selectedType = type
                                }) {
                                    Text(type)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedType == type ? Color(red: 0.7, green: 0.9, blue: 1.0) : Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                        .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                                }
                            }
                        }
                    }

                    // Gender
                    Group {
                        Text("Gender").bold()
                        HStack {
                            ForEach(genders, id: \.self) { gender in
                                Button(action: {
                                    selectedGender = gender
                                }) {
                                    Text(gender)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(selectedGender == gender ? Color(red: 0.7, green: 0.9, blue: 1.0) : Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                        .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                                }
                            }
                        }
                    }

                    // Sterilization
                    Group {
                        Text("Vaccination").bold()
                        Text("Sterilization").bold()
                        Toggle("", isOn: $isSterilized)
                            .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.57, green: 0.76, blue: 0.85)))
                    }

                    // Age
                    Group {
                        Text("Age").bold()
                        HStack {
                            Button { if age > 0 { age -= 1 } } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                            Text("\(age)")
                                .frame(width: 40)
                            Button { age += 1 } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            ForEach(units, id: \.self) { unit in
                                Button(action: {
                                    ageUnit = unit
                                }) {
                                    Text(unit)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background(ageUnit == unit ? Color(red: 0.7, green: 0.9, blue: 1.0) : Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(8)
                                        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
                                }
                            }
                        }
                    }

                    // Coloration
                    Group {
                        Text("Coloration").bold()
                        Picker("Select an option", selection: $selectedColoration) {
                            ForEach(colorOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white).shadow(radius: 1))
                    }

                    // City
                    Group {
                        Text("City").bold()
                        Picker("Select an option", selection: $selectedCity) {
                            ForEach(cityOptions, id: \.self) { option in
                                Text(option).tag(option)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white).shadow(radius: 1))
                    }

                    // Filter button
                    Button(action: {
                        // Apply filters
                        dismiss()
                    }) {
                        Text("Filter")
                            .font(.system(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 1.0, green: 0.78, blue: 0.2))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                    }
                    .padding(.top, 20)

                }
                .padding()
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        }
    }
}
