//
//  EditProfile.swift
//  newHere
//
//  Created by TRACY LI on 2023/12/7.
//

import SwiftUI

struct EditProfile: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: UserProfileViewModel
    @State private var image: Image? = Image(systemName: "person.crop.circle.fill")
    @State private var isShowingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var username: String = ""
    @State private var email: String = ""

    var body: some View {
        VStack {
            // Top bar with close button
            HStack {
                Spacer()
                Button(action: {
                    isPresented.toggle()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .shadow(radius: 2.0)
                }
                .padding(.trailing, 20)
            }
            .padding(.vertical, 8)

            // Edit Profile: Avatar photo, Name, Bio
            VStack(alignment: .leading) {
                // User Avatar
                Button(action: {
                    self.isShowingImagePicker = true
                }) {
                    VStack {
                        image?
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .frame(width: 100, height: 100)
                            .shadow(radius: 3)
                            .foregroundColor(Color.white)

                        Text("Edit Profile Picture")
                            .foregroundColor(.white)
                    }
                }
                .sheet(isPresented: $isShowingImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: self.$inputImage)
                }

                // Username Input
                Text("Username:")
                    .foregroundColor(.white)
                TextField("Enter new username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                // Bio Input
                Text("Email:")
                    .foregroundColor(.white)
                TextField("Enter new email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            
            // Save Button
                        Button(action: {
                            // Action to save the profile details
                            saveProfile(userId: userId)
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.5))
                                .cornerRadius(10)
                        }
                        .padding()

            Spacer()
        }
        .frame(width: 350, height: 600)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        viewModel.profileImage = inputImage
    }
    func saveProfile(userId: String) {
        let userId = userId // Replace with actual user ID

        let userNameToUpdate: String? = username.isEmpty ? nil : username
        let emailToUpdate: String? = email.isEmpty ? nil : email
        let avatarToUpdate: String? = nil // Replace with actual logic to handle avatar updates

        updateUserProfile(userId: userId, userName: userNameToUpdate, email: emailToUpdate, avatar: avatarToUpdate) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Profile updated successfully.")
                    // Handle successful update (e.g., show confirmation message)
                    self.viewModel.username = self.username
                    self.viewModel.email = self.email
                case .failure(let error):
                    print("Error updating profile: \(error.localizedDescription)")
                    // Handle error (e.g., show error message)
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


