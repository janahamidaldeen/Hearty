//
//  ProfileSetUpView.swift
//  Hearty
//
//  Created by Jana Hamidaldeen on 2025-02-08.
//

import SwiftUI

struct ProfileSetupView: View {
    @Binding var userName: String
    @Binding var userRestrictions: [String]
    @Binding var userCity: String
    @Binding var userLocationSharing: Bool
    @State private var currentPage = 0 // Controls survey navigation

    var body: some View {
        VStack {
            if currentPage == 0 {
                NamePage(name: $userName, nextPage: $currentPage)
            } else if currentPage == 1 {
                RestrictionsPage(selectedRestrictions: $userRestrictions, nextPage: $currentPage)
            } else if currentPage == 2 {
                CityAndLocationPage(city: $userCity, locationSharing: $userLocationSharing, nextPage: $currentPage)
            } else if currentPage == 3 {
                ProfileSummaryPage(name: $userName, restrictions: $userRestrictions, city: $userCity, locationSharing: $userLocationSharing)
            }
            // Debugging to check current page
            Text("Current Page: \(currentPage)")
        }
    }
}




struct NamePage: View {
    @Binding var name: String
    @Binding var nextPage: Int

    var body: some View {
        VStack {
            Text("What's your name?")
                .font(.largeTitle)
                .padding()

            TextField("Enter your name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Spacer()

            Button(action: {
                nextPage += 1 // Go to the next page
            }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding()
            }
        }
    }
}
struct RestrictionsPage: View {
    @Binding var selectedRestrictions: [String]
    private let allRestrictions = ["Dairy", "Eggs", "Gluten", "Nuts", "Shellfish", "Soy", "Sugar-Free"]
    @Binding var nextPage: Int // Added to control navigation flow

    var body: some View {
        VStack {
            Text("Select Your Restrictions")
                .font(.largeTitle)
                .padding()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(allRestrictions, id: \.self) { restriction in
                    Button(action: {
                        toggleRestriction(restriction)
                    }) {
                        Text(restriction)
                            .restrictionButtonStyle(selected: selectedRestrictions.contains(restriction))
                    }
                }
            }
            .padding()

            Spacer()

            Button(action: {
                nextPage += 1 // Navigates to the next page (CityAndLocationPage)
            }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding()
        }
    }

    private func toggleRestriction(_ restriction: String) {
        if let index = selectedRestrictions.firstIndex(of: restriction) {
            selectedRestrictions.remove(at: index)
        } else {
            selectedRestrictions.append(restriction)
        }
    }
}

// Reusable button style
extension Text {
    func restrictionButtonStyle(selected: Bool) -> some View {
        self.foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(selected ? Color.green : Color.gray)
            .cornerRadius(8)
    }
}


struct CityAndLocationPage: View {
    @Binding var city: String
    @Binding var locationSharing: Bool
    @Binding var nextPage: Int // Added to control navigation flow

    var body: some View {
        VStack {
            Text("Where are you located?")
                .font(.largeTitle)
                .padding()

            TextField("Enter your city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Toggle(isOn: $locationSharing) {
                Text("Allow Location Sharing")
            }
            .padding()

            Text(locationSharing ? "Location Sharing Enabled" : "Location Sharing Disabled")
                .font(.subheadline)
                .foregroundColor(.gray)

            Spacer()

            Button(action: {
                nextPage += 1 // Navigate to ProfileSummaryPage
            }) {
                Text("Finish")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
}


struct ProfileSummaryPage: View {
    @Binding var name: String
    @Binding var restrictions: [String]
    @Binding var city: String
    @Binding var locationSharing: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Profile")
                .font(.largeTitle)
                .padding()

            Text("Name: \(name)")
                .font(.headline)

            Text("Restrictions: \(restrictions.isEmpty ? "No restrictions selected" : restrictions.joined(separator: ", "))")
                .font(.headline)

            Text("City: \(city.isEmpty ? "Not Set" : city)")
                .font(.headline)

            Text("Location Sharing: \(locationSharing ? "Enabled" : "Disabled")")
                .font(.headline)

            Spacer()

            NavigationLink(
                destination: MainMenuView(
                    name: name,
                    restrictions: restrictions,
                    city: city,
                    locationSharing: locationSharing
                )
            ) {
                Text("Complete")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding()
            }
        }
    }
}
