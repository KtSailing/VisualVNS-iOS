//
//  RegisterView.swift
//  UserAuthSample
//
//  Created by Mac on 2025/04/19.
//

import SwiftUI

struct RegisterView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var registrationSuccess = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("アカウント情報")) {
                        TextField("ユーザー名", text: $username)
                            .textContentType(.username)
                            .autocapitalization(.none)

                        TextField("メールアドレス", text: $email)
                            .keyboardType(.emailAddress)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)

                        SecureField("パスワード", text: $password)
                            .textContentType(.newPassword)
                    }

                    Section {
                        if isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else {
                            Button("登録", action: registerUser)
                                .disabled(isLoading)
                        }
                    }
                }

                if registrationSuccess {
                    Text("登録が完了しました！")
                        .foregroundColor(.green)
                        .padding(.top)
                }

//                HStack {
//                    Text("すでにアカウントをお持ちですか？")
//                    NavigationLink(destination: {
//                        LoginView()
//                    }, label: {
//                        Text("ログイン")
//                            .foregroundColor(.blue)
//                    })
//                }
//                .font(.footnote)
//                .foregroundColor(.secondary)
//                .padding()

            }
            .navigationTitle("新規登録")
            .navigationBarTitleDisplayMode(.inline)
            .alert("エラー", isPresented: .constant(errorMessage != nil), actions: {
                Button("OK", role: .cancel) {
                    errorMessage = nil
                }
            }, message: {
                Text(errorMessage ?? "")
            })
        }
    }

    func registerUser() {
        guard !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "すべての項目を入力してください。"
            return
        }

        isLoading = true
        APIClient.shared.register(username: username, password: password, email: email) { success, error in
            DispatchQueue.main.async {
                isLoading = false
                if success {
                    registrationSuccess = true
                } else {
                    errorMessage = error ?? "登録に失敗しました。"
                }
            }
        }
    }
}
