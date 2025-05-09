import SwiftUI

struct InstructionsView: View {
    let primaryColor = Color(hex: "#77bed1")
    let accentColor = Color(hex: "#fdbc33")

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("How to Use")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.brandBlue)
                    .padding(.bottom)

                InstructionStepView(
                    title: "1. Browse Pets",
                    description: "Use the search or browse features to view available pets ready for adoption.",
                    primaryColor: primaryColor,
                    accentColor: accentColor
                )

                InstructionStepView(
                    title: "2. Favourite Pet",
                    description: "Save your favourite pets for adoption to your personal list for easy access later.",
                    primaryColor: primaryColor,
                    accentColor: accentColor
                )
                
                InstructionStepView(
                    title: "3. Adopt a Pet",
                    description: "Once you find a pet you like, click adopt and confirm your interest.",
                    primaryColor: primaryColor,
                    accentColor: accentColor
                )

                InstructionStepView(
                    title: "4. Report a Stray",
                    description: "Report stray animals by providing details such as type, characteristics, location, and status.",
                    primaryColor: primaryColor,
                    accentColor: accentColor
                )
                
                InstructionStepView(
                    title: "5. Report Lost/Found Pet",
                    description: "Announce lost or found pets by providing details and attaching images. The system will notify volunteers in the area.",
                    primaryColor: primaryColor,
                    accentColor: accentColor
                )

                Spacer()
            }
            .padding()
        }
    }
}
struct InstructionStepView: View {
    let title: String
    let description: String
    let primaryColor: Color
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(primaryColor)

            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(accentColor.opacity(0.1))
        .cornerRadius(10)
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
