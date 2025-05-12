// MARK: - LostAndFoundDetailView
import SwiftUI

struct LostAndFoundDetailView: View {
    let pet: LostPet
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: pet.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 240, height: 240)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 240, height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(radius: 10)
                    case .failure:
                        Image("placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 240, height: 240)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(radius: 10)
                    @unknown default:
                        EmptyView()
                    }
                }


                Text(pet.name)
                    .font(.headline)

                VStack(spacing: 6) {
                    Text("Last Seen: \(pet.lastSeen)")
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("Reward: \(pet.reward)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }

                Divider().padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    Text("**Breed:** \(pet.breed)")
                    Text("**Age:** \(formattedAge(pet.age))")
                    Text("**Gender:** \(pet.gender)")
                    Text("**Color:** \(pet.color)")
                    Text("**Size:** \(pet.size)")
                    Text("**Wearing:** \(pet.wearing)")
                    Text("**Found?:** \(pet.status ? "Yes" : "No")")
                    Text("**Personality:** \(pet.personality)")
                    Text("**Health:** \(pet.healthStatus)")
                    Text("**Description:**\n\(pet.description)")
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                Button(action: {
                    // Optional: Call or message functionality here
                }) {
                    Text("\u{2706} \(pet.contact)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 209 / 255, green: 119 / 255, blue: 119 / 255))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.height > 50 {
                        dismiss()
                    }
                }
        )
    }

    private func formattedAge(_ age: Float) -> String {
        if age < 1 {
            let months = Int(round(age * 12))
            return "\(months) month\(months == 1 ? "" : "s")"
        } else {
            return String(format: "%.1f year%@", age, age == 1.0 ? "" : "s")
        }
    }
}
