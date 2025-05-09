import SwiftUI

struct FloatingTabBar: View {
    @Binding var selectedTab: Int

    let icons = [
        "house.fill",
        "heart.fill",
        "exclamationmark.triangle.fill",
        "magnifyingglass",
        "person.circle.fill"
    ]

    @Namespace private var animation

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<icons.count, id: \.self) { index in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                } label: {
                    ZStack {
                        if selectedTab == index {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(hex: "#FDBC33"))
                                .matchedGeometryEffect(id: "tabHighlight", in: animation)
                                .frame(width: 44, height: 44)
                        }

                        Image(systemName: icons[index])
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#77BED1"))
                .shadow(radius: 5)
        )
        .padding(.horizontal, 20)
    }
}
