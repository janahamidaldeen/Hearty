//
//  SignInSignUpView.swift
//  Hearty
//
//  Created by Jana Hamidaldeen on 2025-02-08.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var isSignUp = false
    @Published var loggedIn = false
    @Published var navigateToProfileSetup = false
    
    // User profile data
    @Published var userName = ""
    @Published var userRestrictions: [String] = []
    @Published var userCity = ""
    @Published var userLocationSharing = false

    func handleSignUp() {
        guard !email.isEmpty, !password.isEmpty, password == confirmPassword else {
            print("Invalid input or passwords do not match.")
            return
        }
        print("Sign Up Successful for email: \(email)")
        loggedIn = true
        navigateToProfileSetup = true // Navigate to Profile Setup
    }

    func handleSignIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("Invalid login input.")
            return
        }
        print("Sign In Successful for email: \(email)")
        
        // Example: Populate with default or fetched user profile data after login
        userName = "Default User"
        userRestrictions = ["Gluten-Free", "Dairy-Free"]
        userCity = "Toronto"
        userLocationSharing = true
        
        loggedIn = true
    }
}

struct SignInSignUpView: View {
    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {
        if viewModel.loggedIn {
            if viewModel.navigateToProfileSetup {
                ProfileSetupView(
                    userName: $viewModel.userName,
                    userRestrictions: $viewModel.userRestrictions,
                    userCity: $viewModel.userCity,
                    userLocationSharing: $viewModel.userLocationSharing
                ) // Navigate to Profile Setup
            } else {
                MainMenuView(
                    name: viewModel.userName,
                    restrictions: viewModel.userRestrictions,
                    city: viewModel.userCity,
                    locationSharing: viewModel.userLocationSharing
                ) // Navigate to Main Menu
            }
        } else {
            VStack(spacing: 20) {
                Text(viewModel.isSignUp ? "Sign Up" : "Sign In")
                    .font(.largeTitle)
                    .padding()

                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.horizontal)

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                if viewModel.isSignUp {
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                }

                Button(action: {
                    if viewModel.isSignUp {
                        viewModel.handleSignUp()
                    } else {
                        viewModel.handleSignIn()
                    }
                }) {
                    Text(viewModel.isSignUp ? "Sign Up" : "Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                Button(action: {
                    viewModel.isSignUp.toggle()
                }) {
                    Text(viewModel.isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
}

struct SignInSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignInSignUpView()
    }
}
