import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var loginError: String? = nil // エラーメッセージ

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Text("ログイン")
                    .font(.largeTitle)
                    .bold()

                VStack(spacing: 12) {
                    TextField("ユーザー名", text: $username)
                        .textContentType(.username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                    SecureField("パスワード", text: $password)
                        .textContentType(.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                }

                // エラーメッセージ表示
                if let error = loginError {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                }

                Button(action: {
                    loginError = nil // リセット

                    APIClient.shared.login(username: username, password: password) { success in
                        DispatchQueue.main.async {
                            if success {
                                isLoggedIn = true
                            } else {
                                loginError = "ユーザー名またはパスワードが間違っています。"
                            }
                        }
                    }
                }) {
                    Text("ログイン")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }

                Divider()
                    .padding(.vertical, 10)

                Text("アカウントをお持ちでない方はこちら")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                NavigationLink(destination: RegisterView()) {
                    Text("新規アカウントを作成")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .ignoresSafeArea(edges: .bottom)
            .fullScreenCover(isPresented: $isLoggedIn) {
                DemonstrationView()
            }
        }
    }
}
