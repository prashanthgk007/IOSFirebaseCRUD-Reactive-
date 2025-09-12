import FirebaseAuth
import Observation
import Combine

@Observable
class LoginVM {
    // 🔹 UI State
    var email: String = "" { didSet { emailSubject.send(email) } }
    var password: String = "" { didSet { passwordSubject.send(password) } }
    var loginError: String = ""
    
    var isSecure: Bool = true
    var isLoading: Bool = false
    var showValidation = false
    var isCheckingAuth: Bool = true
    var showToast = false
    
    var registerSuccessMessage: Bool = false { didSet { registerSuccessSubject.send(registerSuccessMessage) } }
    var registerErrorMessage: Bool = false
    var loginSuccessMessage: Bool = false
    var loginErrorMessage: Bool = false
    
    var errorMessage: String = ""
    var userLoggedIn = false
    
    // MARK: - Combine Publishers
    let emailSubject = CurrentValueSubject<String, Never>("")
    let passwordSubject = CurrentValueSubject<String, Never>("")
    let registerSuccessSubject = PassthroughSubject<Bool, Never>()
    let userLoggedInSubject = CurrentValueSubject<Bool, Never>(false)
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init() {
        // Example Combine pipeline: validate email live
        emailSubject
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { value in
                print("📩 Live email entered: \(value)")
            }
            .store(in: &cancellables)
        
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                let loggedIn = (user != nil)
                self?.userLoggedIn = loggedIn
                self?.userLoggedInSubject.send(loggedIn)
                self?.isCheckingAuth = false
            }
        }
    }
    
    // MARK: - Firebase Auth
    func register() {
        guard validateForm() else {
            registerErrorMessage = true
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }
            if let error = error {
                self.errorMessage = error.localizedDescription
                self.registerErrorMessage = true
            } else {
                self.registerSuccessMessage = true
                self.registerSuccessSubject.send(true)  // 🔹 Fire Combine
            }
        }
    }
    
    func login() {
        guard isEmailValid(), isPasswordValid() else { return }
        
        isLoading = true
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    self.loginErrorMessage = true
                    
                    if let error = error as NSError? {
                        switch AuthErrorCode(rawValue: error.code) {
                        case .invalidEmail:
                            self.loginError = "The email address is badly formatted."
                        case .userNotFound:
                            self.loginError = "No account found with this email."
                        case .wrongPassword:
                            self.loginError = "The password is incorrect."
                        case .userDisabled:
                            self.loginError = "This account has been disabled."
                        case .networkError:
                            self.loginError = "Network error. Please try again."
                        default:
                            self.loginError = error.localizedDescription
                        }
                    }
                } else {
                    self.userLoggedIn = true
                    self.showToast = true
                    NotificationHelper.showNotification(
                        title: "Login Successful",
                        body: "Welcome back, \(self.email)"
                    )

                }
            }
        }
    }

    
    func logout() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                self.userLoggedIn = false
                self.userLoggedInSubject.send(false)
                NotificationHelper.showNotification(
                    title: "Alert",
                    body: "You've been logged out"
                )
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Validation
    func isEmailValid() -> Bool {
        let emailRegex = #"^\S+@\S+\.\S+$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func isPasswordValid() -> Bool {
        return password.count >= 6
    }
    
    func validateForm() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Email and Password must not be empty."
            return false
        } else if !isEmailValid() {
            errorMessage = "Enter a valid email address."
            return false
        } else if !isPasswordValid() {
            errorMessage = "Password must be at least 6 characters."
            return false
        }
        return true
    }
    
    // MARK: - Additional Validation Errors
    var emailError: String? {
        if email.isEmpty {
            return "Email is required"
        } else if !isEmailValid() {
            return "Enter a valid email address"
        }
        return nil
    }
    
    var passwordError: String? {
        if password.isEmpty {
            return "Password is required"
        } else if password.count < 6 {
            return "Password must be at least 6 characters"
        }
        return nil
    }
}
