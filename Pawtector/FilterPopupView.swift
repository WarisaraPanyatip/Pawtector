import SwiftUI

enum AgeUnit: String, CaseIterable, Identifiable {
    case year, month
    var id: String { rawValue }
}

struct FilterPopupView: View {
    @Environment(\.dismiss) var dismiss

    // **Temp** bindings from HomePageView
    @Binding var filterTypes: Set<String>
    @Binding var filterGenders: Set<String>
    @Binding var vaccinatedOnly: Bool
    @Binding var sterilizedOnly: Bool
    @Binding var ageValue: Int
    @Binding var ageUnit: AgeUnit
    @Binding var selectedColor: String
    @Binding var selectedCity: String

    /// Called when “Apply” is tapped
    let onApply: () -> Void

    // Your real lists…
    private let colorationOptions = ["Any", "Black", "White", "Brown", "Golden", "Gray", "Tan", "Mixed/Other"]
    private let cityOptions       = ["Any", "Bangkok", "Chiang Mai", "Phuket", "Pattaya", "Khon Kaen", "Hat Yai"]
    
    //clear filter
    private func clearAllFilters() {
        filterTypes.removeAll()
        filterGenders.removeAll()
        vaccinatedOnly = false
        sterilizedOnly = false
        ageValue = 1
        ageUnit = .year
        selectedColor = "Any"
        selectedCity = "Any"
    }

    var body: some View {
        // Use a ScrollView for the content
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header + Close
                HStack {
                    Text("Filter")
                        .font(.title2).bold()
                    Spacer()
                    // Clear All Button
                     Button {
                         clearAllFilters()
                     } label: {
                         Text("Clear All")
                             .font(.subheadline).bold()
                             .foregroundColor(.brandBrown)
                     }
                     //cancle
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }

                // Type pills
                Text("Type").font(.headline)
                HStack {
                    pill("All",  isSelected: filterTypes.isEmpty)        { filterTypes.removeAll() }
                    pill("Cats", isSelected: filterTypes.contains("Cat")) { toggle(&filterTypes, "Cat") }
                    pill("Dogs", isSelected: filterTypes.contains("Dog")) { toggle(&filterTypes, "Dog") }
                }

                // Gender pills
                Text("Gender").font(.headline)
                HStack {
                    pill("Male",   isSelected: filterGenders.contains("Male"))   { toggle(&filterGenders, "Male") }
                    pill("Female", isSelected: filterGenders.contains("Female")) { toggle(&filterGenders, "Female") }
                }

                // Switches
                Toggle("Vaccinated Only", isOn: $vaccinatedOnly)
                Toggle("Sterilized Only", isOn: $sterilizedOnly)

                // Age selector
                Text("Age").font(.headline)
                HStack(spacing: 16) {
                    Button { if ageValue > 0 { ageValue -= 1 } } label: {
                        Image(systemName: "minus.circle")
                    }
                    Text("\(ageValue)").bold().frame(minWidth: 30)
                    Button { ageValue += 1 } label: {
                        Image(systemName: "plus.circle")
                    }
                    Spacer()
                    ForEach(AgeUnit.allCases) { unit in
                        Button(unit.rawValue.capitalized) {
                            ageUnit = unit
                        }
                        .padding(.vertical, 6).padding(.horizontal, 12)
                        .background(ageUnit == unit ? Color.brandBlue : Color.gray.opacity(0.2))
                        .foregroundColor(ageUnit == unit ? .white : .primary)
                        .cornerRadius(8)
                    }
                }

                // Pickers
                Text("Coloration").font(.headline)
                Picker("Coloration", selection: $selectedColor) {
                    ForEach(colorationOptions, id: \.self) { Text($0) }
                }
                .pickerStyle(MenuPickerStyle())

                Text("City").font(.headline)
                Picker("City", selection: $selectedCity) {
                    ForEach(cityOptions, id: \.self) { Text($0) }
                }
                .pickerStyle(MenuPickerStyle())

                // Just add some bottom padding—actual button is in safeAreaInset
                Spacer().frame(height: 80)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(20, corners: [.topLeft, .topRight])
        
      

        // MARK: pin Apply button above the safe area
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                Divider().background(Color.gray.opacity(0.3))
                Button(action: {
                    onApply()
                }) {
                    Text("Apply")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandYellow)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 16)
                .background(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
            }
        }
    }

    // MARK: – Helpers

    private func pill(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline).bold()
                .padding(.vertical, 6).padding(.horizontal, 12)
                .background(isSelected ? Color.brandBlue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(8)
        }
    }

    private func toggle(_ set: inout Set<String>, _ val: String) {
        if set.contains(val) { set.remove(val) } else { set.insert(val) }
    }
}

struct FilterPopup_Previews: PreviewProvider {
    static var previews: some View {
        FilterPopupView(
            filterTypes: .constant([]),
            filterGenders: .constant([]),
            vaccinatedOnly: .constant(false),
            sterilizedOnly: .constant(false),
            ageValue: .constant(1),
            ageUnit: .constant(.year),
            selectedColor: .constant("Any"),
            selectedCity: .constant("Any")
        ) { }
        .previewLayout(.sizeThatFits)
    }
}
import UIKit
/// A Shape that rounds only the specified corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let uiPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(uiPath.cgPath)
    }
}
public extension View {
    /// Rounds only the given corners of this view
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}
