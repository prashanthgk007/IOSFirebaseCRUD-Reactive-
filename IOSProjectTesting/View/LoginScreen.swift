import SwiftUI

struct LoginScreen: View {
    @State var loginVM = LoginVM()
    
    var body: some View {
        Group {
            if loginVM.isCheckingAuth {
                ProgressView("Checking session...")

            } else {
                if loginVM.userLoggedIn {
                    ListView()
                } else {
                    login_view
                }
            }
        }
    }


    
    var login_view: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                VStack(spacing: 30) {
                    Text("Welcome Back!")
                        .font(.largeTitle.bold())
                        .foregroundColor(.black)
                        .padding(.top, 40)


                    // Input Fields

                    VStack(spacing: 20) {
                        TextField("Username or Email", text: $loginVM.email)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1))

                        if loginVM.showValidation, let emailError = loginVM.emailError {
                            Text(emailError)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        ZStack {
                            Group {
                                if loginVM.isSecure {
                                    SecureField("Password", text: $loginVM.password)
                                } else {
                                    TextField("Password", text: $loginVM.password)
                                }
                            }
                            .autocapitalization(.none)
                            .padding(.trailing, 40)
                            .padding()
                            .foregroundColor(.black)

                            HStack {
                                Spacer()
                                Button(action: { loginVM.isSecure.toggle() }) {
                                    Image(systemName: loginVM.isSecure ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing, 16)
                            }
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1))

                        if loginVM.showValidation, let passwordError = loginVM.passwordError {
                            Text(passwordError)
                                .font(.caption)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            // Handle forgot password
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                    }

                    // Login Button
                    Button(action: {
                        loginVM.showValidation = true
                        loginVM.login()
                    }) {
                        if loginVM.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Login")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 2, y: 2)
                    .disabled(loginVM.isLoading)
                    .padding(.top, 10)

                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)

                        NavigationLink(destination: RegisterScreen()) {
                            Text("Register")
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 10)


                    Spacer()
                }
                .padding(.horizontal, 30)
                .alert("Login Failed", isPresented: $loginVM.loginErrorMessage) {

                    Spacer()
                }
                .padding(.horizontal, 30)
                .alert(loginVM.loginError, isPresented: $loginVM.loginErrorMessage) {

                    Button("Retry", role: .cancel) { }
                }
                .disabled(loginVM.isLoading)
//                .onReceive(loginVM.userLoggedInSubject) { loggedIn in
//                    if loggedIn {
//                        loginVM.showToast = true
//                    }
//                }

            }
        }
    }

    
    var home_view: some View {
        NavigationStack {
            List {
                ForEach(1...5, id: \.self) { index in
                    Text("Item \(index)")
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Logout") {
                        self.loginVM.logout()
                    }
                }
            }
        }
    }

}
