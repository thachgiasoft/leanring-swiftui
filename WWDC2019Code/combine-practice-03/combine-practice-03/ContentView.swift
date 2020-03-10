import SwiftUI
import Combine

class SignUpInfo: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordAgain: String = ""

    var validatedPassword: AnyPublisher<String?, Never> {
        return Publishers.CombineLatest($password, $passwordAgain).map { password, passwordAgain in
            guard password == passwordAgain, password.count >= 8 else { return nil }
            return password
        }
        .eraseToAnyPublisher()
    }

    func usernameAvailable(_ username: String, completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
            if username.count < 8 {
                completion(false)
            } else {
                completion(true)
            }
        }
    }

    var validatedUserName: AnyPublisher<String?, Never> {
        return $username
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { username in
                return Future<String?, Never> { promise in
                    self.usernameAvailable(username) { available in
                        promise(.success(available ? username : nil))
                    }
                }
        }
        .eraseToAnyPublisher()
    }

    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        return Publishers.CombineLatest(validatedUserName, validatedPassword)
            .map { username, password in
                guard let uname = username, let pwd = password else { return nil }
                return (uname, pwd)
        }.eraseToAnyPublisher()
    }
}

struct ContentView: View {

    func continueButtonAction() {

    }

    @ObservedObject var info: SignUpInfo = SignUpInfo()

    @State var validated: Bool = false

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 20) {
                Text("Wizard School Signup")
                    .padding()

                HStack(spacing: 10) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    TextField("Wizard name", text: self.$info.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.name)
                        .keyboardType(.emailAddress)
                }

                HStack(spacing: 10) {
                    Image(systemName: "lock.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    SecureField("Password", text: self.$info.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                HStack(spacing: 10) {
                    Image(systemName: "lock.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)

                    SecureField("Repeat password", text: self.$info.passwordAgain)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                }

                Button(action: self.continueButtonAction) {
                    Text("Create Account")
                        .bold()
                        .padding(5)
                        .frame(maxWidth: geometry.size.width - 50, maxHeight: 40)
                }
                .foregroundColor(Color.white)
                .background(self.validated ? Color.blue : Color.secondary)
                .cornerRadius(10)
                .disabled(!self.validated)
                .padding()
                .onReceive(self.info.validatedCredentials.map({ $0 != nil}).eraseToAnyPublisher()) { output in
                    withAnimation {
                        self.validated = output
                    }
                }
            }
            .frame(maxWidth: geometry.size.width - 50)
        }
    }
}


#if DEBUG

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            .environment(\.colorScheme, .light)
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))

            ContentView()
                .environment(\.colorScheme, .dark)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
        }
    }
}
#endif
