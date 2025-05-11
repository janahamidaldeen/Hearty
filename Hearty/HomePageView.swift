//
//  HomePageView.swift
//  Hearty
//
//  Created by Jana Hamidaldeen on 2025-02-08.
//

import SwiftUI

struct HomePageView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Cuisine Types")) {
                    ForEach(["Italian", "Chinese", "Mexican", "Indian"], id: \.self) { cuisine in
                        Text(cuisine)
                    }
                }
            }
            .navigationBarTitle("Home", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Search functionality
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }
}

