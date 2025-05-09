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
    let ageDescription:Float32
    let background: String
    let personality: String
    let healthStatus: String
    let trainingStatus: String
    let breed: String
    let location: String
    let reward: String
    let isFound: Bool
}


extension Pet {
    static let sampleData: [Pet] = [
        Pet(
            id: UUID(),
            name: "Shiba",
            imageName: "dog1",
            type: "Dog",
            gender: "Male",
            ageDescription: 1,
            background: "Found on the street after being abandoned.",
            personality: "Friendly with people and other dogs.",
            healthStatus: "Up-to-date on vaccinations, no medical issues.",
            trainingStatus: "Basic commands: sit, stay.",
            breed: "Shiba Inu",
            location: "Bangkok",
            reward: "$100",
            isFound: false
        ),
        Pet(
            id: UUID(),
            name: "Milo",
            imageName: "cat1",
            type: "Cat",
            gender: "Female",
            ageDescription: 2,
            background: "Rescued from a high-kill shelter.",
            personality: "Calm, enjoys cuddles.",
            healthStatus: "Spayed, vaccinated.",
            trainingStatus: "Litter-trained.",
            breed: "Persian",
            location: "Chiang Mai",
            reward: "$80",
            isFound: false
        ),
        Pet(
            id: UUID(),
            name: "Buddy",
            imageName: "dog1",
            type: "Dog",
            gender: "Male",
            ageDescription: 3,
            background: "Owner couldn’t keep him due to moving.",
            personality: "Energetic, loves fetch.",
            healthStatus: "Minor allergies under treatment.",
            trainingStatus: "Advanced commands: roll over.",
            breed: "Golden Retriever",
            location: "Phuket",
            reward: "$150",
            isFound: true
        ),
        Pet(
            id: UUID(),
            name: "Luna",
            imageName: "cat1",
            type: "Cat",
            gender: "Female",
            ageDescription: 0.5,
            background: "Born in a barn, very curious.",
            personality: "Playful and mischievous.",
            healthStatus: "Vaccinations scheduled.",
            trainingStatus: "Working on scratching post use.",
            breed: "Siamese",
            location: "Ayutthaya",
            reward: "$50",
            isFound: false
        ),
        Pet(
            id: UUID(),
            name: "Daisy",
            imageName: "dog1",
            type: "Dog",
            gender: "Female",
            ageDescription: 4,
            background: "Surrendered by previous owner.",
            personality: "Gentle, great with kids.",
            healthStatus: "Healthy, spayed.",
            trainingStatus: "House-trained.",
            breed: "Beagle",
            location: "Khon Kaen",
            reward: "$120",
            isFound: false
        ),
        Pet(
            id: UUID(),
            name: "Max",
            imageName: "dog1",
            type: "Dog",
            gender: "Male",
            ageDescription: 5,
            background: "Found wandering near park.",
            personality: "Loyal, a bit shy at first.",
            healthStatus: "Hip dysplasia – needs gentle play.",
            trainingStatus: "Basic commands.",
            breed: "Labrador",
            location: "Udon Thani",
            reward: "$70",
            isFound: false
        ),
        Pet(
            id: UUID(),
            name: "Willow",
            imageName: "cat1",
            type: "Cat",
            gender: "Female",
            ageDescription: 1.5,
            background: "Owner allergic, rehomed.",
            personality: "Affectionate lap cat.",
            healthStatus: "Spayed, healthy.",
            trainingStatus: "Litter-trained.",
            breed: "Bengal",
            location: "Nakhon Pathom",
            reward: "$90",
            isFound: true
        ),
        Pet(
            id: UUID(),
            name: "Charlie",
            imageName: "dog1",
            type: "Dog",
            gender: "Male",
            ageDescription: 2,
            background: "Rescued from flood zone.",
            personality: "Brave, loves water.",
            healthStatus: "Vaccinated, microchipped.",
            trainingStatus: "Working on leash manners.",
            breed: "Border Collie",
            location: "Hat Yai",
            reward: "$110",
            isFound: false
        )
    ]
}


