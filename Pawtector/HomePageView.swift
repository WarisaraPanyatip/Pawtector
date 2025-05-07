import SwiftUI

struct HomePageView: View {
    @State private var selectedCategory = "All"
    @State private var showFilter = false
    @EnvironmentObject var session: SessionManager // Get current user info

    let categories = ["All", "Cats", "Dogs"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // HEADER
                HStack {
                    Image(systemName: "pawprint.fill") // Replace with your pug image
                        .resizable()
                        .frame(width: 40, height: 40)
                        .padding(.leading)

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("Hi, \(session.currentUser?.username ?? "Friend")")
                            .font(.system(size: 24, weight: .bold))
                        Text("choose your lovely pet !")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.1))
                    }
                    .padding(.trailing)
                }
                .padding(.top)

                // CATEGORY FILTERS + FILTER BUTTON
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            selectedCategory = category
                        }) {
                            Text(category)
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedCategory == category ? Color(red: 0.7, green: 0.9, blue: 1.0) : .white)
                                .cornerRadius(10)
                                .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                        }
                    }

                    Spacer()

                    Button(action: {
                        showFilter.toggle()
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.black)
                            .padding(10)
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: .gray.opacity(0.3), radius: 2, x: 0, y: 2)
                    }
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal)
                .padding(.bottom, 8)

                // PET CARDS GRID
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(0..<6) { index in
                            PetCardView(
                                imageName: index % 2 == 0 ? "dog1" : "cat1", // Placeholder names
                                name: "Shiba",
                                gender: index % 2 == 0 ? "♂︎" : "♀︎",
                                age: "1 year old"
                            )
                        }
                    }
                    .padding()
                }

                // BOTTOM NAVIGATION BAR
                HStack {
                    Spacer()
                    Image(systemName: "book.fill")
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName: "heart")
                    Spacer()
                    Image(systemName: "bell")
                    Spacer()
                    Image(systemName: "film")
                    Spacer()
                    Image(systemName: "person")
                    Spacer()
                }
                .padding()
                .background(Color(red: 0.85, green: 0.95, blue: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 3)
                .padding(.top, 8)
            }
            .background(Color(.systemGroupedBackground))
            .sheet(isPresented: $showFilter) {
                FilterPopupView()
            }
        }
    }
}

//-----------------------------PetCardView-----------------------------

struct PetCardView: View {
    var imageName: String
    var name: String
    var gender: String
    var age: String

    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 140)
                    .clipped()
                    .cornerRadius(16)

                Button(action: {
                    // Favorite toggle logic here
                }) {
                    Image(systemName: "heart")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.white.opacity(0.7))
                        .clipShape(Circle())
                        .padding(6)
                }
            }

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(name)\(gender)")
                        .bold()
                    Text(age)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {
                    // Handle More
                }) {
                    Text("More")
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.7, green: 0.9, blue: 1.0))
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}
