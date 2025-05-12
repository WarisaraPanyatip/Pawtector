import SwiftUI

struct LostAndFoundDetailView: View {
    let pet: LostPet
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // Pet Image with Reward
                ZStack(alignment: .topTrailing) {
                    let dogImages = ["ใบบัว", "โบ้", "เปียกปูน", "พละ", "อูโน่"]
                    let catImages = ["จี๊ด", "ส้มส้ม", "แหมว"]
                    let imageName = pet.type == "Dog" ? dogImages.randomElement()! : catImages.randomElement()!
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 300)
                        .cornerRadius(20)
                        .clipped()

                    if !pet.reward.isEmpty {
                        Text("🎁 \(pet.reward)")
                            .font(.caption)
                            .padding(8)
                            .background(Color.brown.opacity(0.9))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .padding()
                    }
                }

                // Pet Name
                Text(pet.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.brandBrown)

                // Info Chips
                HStack(spacing: 16) {
                    infoChip(icon: "pawprint.fill", text: pet.type)
                    infoChip(icon: "calendar", text: formattedAge(pet.age))
                    infoChip(icon: pet.gender == "Male" ? "m.circle" : "f.circle", text: pet.gender)
                    infoChip(icon: "dot.radiowaves.left.and.right", text: pet.breed)
                }
                .padding()

                // Call Button
                Button(action: {
                    if let url = URL(string: "tel://\(pet.contact.filter { $0.isNumber })") {
                        UIApplication.shared.open(url)
                    }
                }) {
                    Text("📞 \(pet.contact)")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.brandYellow)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }

                // Detail Blocks
                VStack(spacing: 16) {
                    detailBlock(icon: "map.fill", title: "Last Seen", text: pet.lastSeen)
                    detailBlock(icon: "eye", title: "Color", text: pet.color)
                    detailBlock(icon: "scalemass", title: "Size", text: pet.size)
                    detailBlock(icon: "tshirt.fill", title: "Wearing", text: pet.wearing)
                    detailBlock(icon: "smiley.fill", title: "Personality", text: pet.personality)
                    detailBlock(icon: "heart.fill", title: "Health", text: pet.healthStatus)
                    detailBlock(icon: "doc.plaintext", title: "Description", text: pet.description)
                }

            }
            .padding()
        }
        .navigationTitle("Lost Pet Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: – Reusable Info Chip
    private func infoChip(icon: String, text: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.brandBlue)

            Text(text)
                .font(.caption)
                .multilineTextAlignment(.center)
        }
        .padding(8)
        .frame(minWidth: 70, maxWidth: 80, minHeight: 60)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.brandBrown, lineWidth: 1)
        )
    }

    // MARK: – Reusable Detail Block
    private func detailBlock(icon: String, title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundColor(.brandBrown)
                Text(title)
                    .font(.headline)
            }
            Text(text)
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(Color.brandBrown).opacity(0.1))
        )
    }

    // MARK: – Age Formatter
    private func formattedAge(_ age: Float) -> String {
        if age < 1 {
            let months = Int(round(age * 12))
            return "\(months) month\(months == 1 ? "" : "s")"
        } else {
            return String(format: "%.1f year%@", age, age == 1.0 ? "" : "s")
        }
    }
}
