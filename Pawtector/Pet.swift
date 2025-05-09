//
//  Pet.swift
//  Pawtector
//
//  Created by venuswaran on 7/5/2568 BE.
//

import Foundation

struct Pet: Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    let type: String
    let gender: String
    let ageDescription: String
    let background: String
    let personality: String
    let healthStatus: String
    let trainingStatus: String
}

extension Pet {
    static let sampleData: [Pet] = [
        Pet(
            id: UUID(),
            name: "Shiba",
            imageName: "dog1",
            type: "Dog",
            gender: "Male",
            ageDescription: "1 year",
            background: "Found on the street after being abandoned.",
            personality: "Friendly with people and other dogs.",
            healthStatus: "Up-to-date on vaccinations, no medical issues.",
            trainingStatus: "Basic commands: sit, stay."
        ),
        Pet(
            id: UUID(),
            name: "Milo",
            imageName: "cat1",
            type: "Cat",
            gender: "Female",
            ageDescription: "2 years",
            background: "Rescued from a high-kill shelter.",
            personality: "Calm, enjoys cuddles.",
            healthStatus: "Spayed, vaccinated.",
            trainingStatus: "Litter-trained."
        ),
        Pet(
            id: UUID(),
            name: "Buddy",
            imageName: "dog1",
            type: "Dog",
            gender: "Male",
            ageDescription: "3 years",
            background: "Owner couldn’t keep him due to moving.",
            personality: "Energetic, loves fetch.",
            healthStatus: "Minor allergies under treatment.",
            trainingStatus: "Advanced commands: roll over."
        ),
        Pet(
            id: UUID(),
            name: "Luna",
            imageName: "cat1",
            type: "Cat",
            gender: "Female",
            ageDescription: "6 months",
            background: "Born in a barn, very curious.",
            personality: "Playful and mischievous.",
            healthStatus: "Vaccinations scheduled.",
            trainingStatus: "Working on scratching post use."
        ),
        Pet(
            id: UUID(),
            name: "Daisy",
            imageName: "dog1",
            type: "Dog",
            gender: "Female",
            ageDescription: "4 years",
            background: "Surrendered by previous owner.",
            personality: "Gentle, great with kids.",
            healthStatus: "Healthy, spayed.",
            trainingStatus: "House-trained."
        ),
        Pet(
            id: UUID(),
            name: "Max",
            imageName: "dog1",
            type: "Dog",
            gender: "Male",
            ageDescription: "5 years",
            background: "Found wandering near park.",
            personality: "Loyal, a bit shy at first.",
            healthStatus: "Hip dysplasia – needs gentle play.",
            trainingStatus: "Basic commands."
        ),
        Pet(
            id: UUID(),
            name: "Willow",
            imageName: "cat1",
            type: "Cat",
            gender: "Female",
            ageDescription: "1.5 years",
            background: "Owner allergic, rehomed.",
            personality: "Affectionate lap cat.",
            healthStatus: "Spayed, healthy.",
            trainingStatus: "Litter-trained."
        ),
        Pet(
            id: UUID(),
            name: "Charlie",
            imageName: "dog1",
            type: "Dog",
            gender: "Male",
            ageDescription: "2 years",
            background: "Rescued from flood zone.",
            personality: "Brave, loves water.",
            healthStatus: "Vaccinated, microchipped.",
            trainingStatus: "Working on leash manners."
        )
    ]
}


