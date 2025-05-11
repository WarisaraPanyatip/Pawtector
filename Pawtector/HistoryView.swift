////
////  HistoryView.swift
////  Pawtector
////
////  Created by Piyathida Changsuwan on 9/5/2568 BE.
////
//
//import SwiftUI
//
//struct HistoryView: View {
//    // สมมุติข้อมูลตัวอย่าง
//    let adoptionHistory: [Pet] = Pet.sampleData.prefix(2).map { $0 }
//    let reportStrayHistory: [StrayReport] = [
//        StrayReport(type: "Cat", condition: "Injured", date: "09/05/2025", location: "Soi 11")
//    ]
//    let reportLostHistory: [Pet] = Pet.sampleData.suffix(2).map { $0 }
//
//    var body: some View {
//        NavigationStack {
//            List {
//                // Section 1: Adoption
//                Section(header: Text("Adoption History")) {
//                    ForEach(adoptionHistory) { pet in
//                        NavigationLink(destination: LostAndFoundDetailView(pet: pet)) {
//                            HStack {
//                                Image(systemName: "pawprint.fill")
//                                    .foregroundColor(.green)
//                                VStack(alignment: .leading) {
//                                    Text(pet.name)
//                                    Text("Adopted: \(pet.ageDescription)")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                    }
//                }
//
//                // Section 2: Stray Report
//                Section(header: Text("Stray Reports")) {
//                    ForEach(reportStrayHistory) { report in
//                        HStack {
//                            Image(systemName: "exclamationmark.triangle.fill")
//                                .foregroundColor(.orange)
//                            VStack(alignment: .leading) {
//                                Text("Type: \(report.type)")
//                                Text("Condition: \(report.condition)")
//                                Text("Date: \(report.date) • \(report.location)")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                    }
//                }
//
//                // Section 3: Lost Reports
//                Section(header: Text("Lost Pet Reports")) {
//                    ForEach(reportLostHistory) { pet in
//                        NavigationLink(destination: LostAndFoundDetailView(pet: pet)) {
//                            HStack {
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundColor(.blue)
//                                VStack(alignment: .leading) {
//                                    Text(pet.name)
//                                    Text("Lost at \(pet.location)")
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("History")
//        }
//    }
//}
//
//// MARK: - Mock model for stray report
//struct StrayReport: Identifiable {
//    let id = UUID()
//    let type: String
//    let condition: String
//    let date: String
//    let location: String
//}
//
//#Preview {
//    HistoryView()
//}
