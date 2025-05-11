//
//  PersonalProfilesView.swift
//  Hearty
//
//  Created by Jana Hamidaldeen on 2025-02-08.
//

import SwiftUI

struct PersonalProfileView: View {
    var name: String
    var restrictions: [String]
    var city: String
    var locationSharing: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Profile")
                .font(.largeTitle)
                .padding()

            Text("Name: \(name)")
                .font(.headline)

            Text("Restrictions: \(restrictions.isEmpty ? "None" : restrictions.joined(separator: ", "))")
                .font(.headline)

            Text("City: \(city.isEmpty ? "Not Set" : city)")
                .font(.headline)

            Text("Location Sharing: \(locationSharing ? "Enabled" : "Disabled")")
                .font(.headline)

            Spacer()
        }
        .padding()
    }
}
