import SwiftUI

struct InstructionsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("How to Use")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom)

                InstructionStepView(
                    title: "1. Create Your Profile",
                    description: "Start by editing your profile. Add your name, contact details."
                )

                InstructionStepView(
                    title: "2. Browse Pets",
                    description: "Use the search or browse features to view available pets ready for adoption."
                )

                InstructionStepView(
                    title: "3. Adopt a Pet",
                    description: "Once you find a pet you like, click adopt and confirm your interest."
                )

                InstructionStepView(
                    title: "4. Track Your Adoptions",
                    description: "Visit the 'Adoption History' page to see pets you’ve adopted."
                )

                InstructionStepView(
                    title: "5. Need Help?",
                    description: "Click on support or contact us for assistance through the app."
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

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)

            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(10)
    }
}
