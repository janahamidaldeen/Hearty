//
//  MainMenuView.swift
//  Hearty
//
//  Created by Jana Hamidaldeen on 2025-02-08.
//

import SwiftUI

struct MainMenuView: View {
    var name: String
    var restrictions: [String]
    var city: String
    var locationSharing: Bool

    var body: some View {
        TabView {
            HomePageView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }

            GroupsView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Groups")
                }

            PersonalProfileView(name: name, restrictions: restrictions, city: city, locationSharing: locationSharing)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}
