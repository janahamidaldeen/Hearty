//
//  IntroAnimationView.swift
//  Hearty
//
//  Created by Jana Hamidaldeen on 2025-02-08.
//

import SwiftUI

struct IntroAnimationView: View {
    @State private var isAnimating = false
    @State private var navigateToNext = false // Tracks navigation state
    var body: some View {
        NavigationView {
            if navigateToNext {
                SignInSignUpView() // Navigate to Sign In/Sign Up view
            } else {
                VStack {
                    Spacer()
                    Text("Welcome to Hearty!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.easeInOut(duration: 1), value: isAnimating)
                    
                    Spacer()
                    Button(action: {
                        navigateToNext = true // Change state to navigate
                    }) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    Spacer()
                }
                .onAppear {
                    withAnimation {
                        isAnimating = true
                    }
                }
            }
        }
    }
}

#Preview {
    IntroAnimationView()
}
