//
//  PetDetailView.swift
//  Pawtector
//
//  Created by venuswaran on 7/5/2568 BE.
//

import SwiftUI

struct PetDetailView: View {
    let pet: Pet
    
    // Dismiss the current view from the navigation stack (back to HomePageView)
    @Environment(\.dismiss) private var navDismiss
    
    @State private var showAdopt   = false // Controls the adoption request sheet
    @State private var requestSent = false // Tracks if the request was submitted

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // MARK: – Pet Image
                Image(pet.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .clipped()
                
                // MARK: – Pet Name
                Text(pet.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.brandBrown)
                
                // MARK: – Info Chips: Type, Age, Gender
                HStack(spacing: 16) {
                    infoChip(icon: "pawprint.fill", text: pet.type)
                    infoChip(icon: "calendar", text: pet.ageDescription)
                    infoChip(icon: pet.gender == "Male" ? "m.circle" : "f.circle",
                             text: pet.gender)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
                
                // MARK: – Detail Blocks: Background, Personality, Health, Training
                VStack(spacing: 16) {
                    detailBlock(
                        icon: "map.fill",
                        title: "Background",
                        text: pet.background
                    )
                    detailBlock(
                        icon: "smiley.fill",
                        title: "Personality",
                        text: pet.personality
                    )
                    detailBlock(
                        icon: "heart.fill",
                        title: "Health Status",
                        text: pet.healthStatus
                    )
                    detailBlock(
                        icon: "pawprint.circle.fill",
                        title: "Training Status",
                        text: pet.trainingStatus
                    )
                }
                
                // MARK: – Contact Foundation / Request Button
                Button {
                    showAdopt = true
                } label: {
                    Text(requestSent ? "Request Sent" : "Contact Foundation")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(requestSent ? Color.gray : Color.brandYellow)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .disabled(requestSent) // Prevent double-submission
            }
            .padding()
        }
        .navigationTitle("Pet Details")
        .navigationBarTitleDisplayMode(.inline)
        
        // MARK: – Adoption Sheet
        .sheet(isPresented: $showAdopt) {
            RequestAdoptionView(requestSent: $requestSent)
        }

        // MARK: – Auto-dismiss when request is sent
        .onChange(of: requestSent) { sent in
            if sent {
                navDismiss()
            }
        }
    }

    // MARK: – Reusable Info Chip View
    private func infoChip(icon: String, text: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.brandBlue)
            Text(text)
                .font(.subheadline).bold()
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.brandBrown, lineWidth: 1)
        )
    }
    
    // MARK: – Reusable Detail Block View
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
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: – Preview
struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PetDetailView(pet: Pet.sampleData[0])
        }
    }
}

