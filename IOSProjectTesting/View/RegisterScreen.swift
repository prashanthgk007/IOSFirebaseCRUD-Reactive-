import SwiftUI

struct RegisterScreen: View {
    
    @State var register_vm = LoginVM()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {

            VStack(spacing: 25) {
                Group {

                    // Email Field

                    TextField("Email", text: $register_vm.email)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1))

                    // Email validation error
                    if register_vm.showValidation, let emailError = register_vm.emailError {
                        Text(emailError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    // Password Field with eye icon
                    ZStack {
                        Group {
                            if register_vm.isSecure {
                                SecureField("Password", text: $register_vm.password)
                            } else {
                                TextField("Password", text: $register_vm.password)
                            }
                        }
                        .autocapitalization(.none)
                        .padding(.trailing, 40)
                        .padding()
                        .foregroundColor(.black)

                        HStack {
                            Spacer()
                            Button(action: { register_vm.isSecure.toggle() }) {
                                Image(systemName: register_vm.isSecure ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 16)
                        }
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                    // Password validation error
                    if register_vm.showValidation, let passwordError = register_vm.passwordError {
                        Text(passwordError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // Register Button
                Button(action: {
                    register_vm.showValidation = true
                    if register_vm.emailError == nil && register_vm.passwordError == nil {
                        register_vm.register()
                    }
                }) {
                    Text("Register")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
                }

                Spacer()
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 30)
            .padding(.top, 30)
            .alert("Registered Successfully", isPresented: $register_vm.registerSuccessMessage) {
                Button("OK") {
                    dismiss()
                }
            }
            .alert("Registration Failed", isPresented: $register_vm.registerErrorMessage) {
                Button("Retry") { }
            }
        }
    }
}
