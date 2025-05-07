//
//  RequestAdoptionView.swift
//  Pawtector
//
//  Created by venuswaran on 7/5/2568 BE.
//

import SwiftUI

struct RequestAdoptionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var requestSent: Bool
    @State private var showingAlert = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "heart.circle.fill")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.brandYellow)

            Text("Request to adopt")
                .font(.largeTitle).bold()
                .foregroundColor(.brandBlue)

            Text("After requesting, the foundation will contact you back in a few days.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            Button("Request confirmation") {
                // trigger the alert
                showingAlert = true
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.brandYellow)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
            // attach the alert
            .alert("Your request was sent", isPresented: $showingAlert) {
                Button("OK") {
                    // mark as sent & close the sheet
                    requestSent = true
                    dismiss()
                }
            } message: {
                Text("Foundation will contact you soon")
            }
        }
        .background(Color(.systemGray6))
        .ignoresSafeArea(edges: .bottom)
    }
}

