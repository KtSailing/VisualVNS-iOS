//
//  ResultView.swift
//  UserAuthSample
//
//  Created by Mac on 2025/04/07.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.loadHTMLString(htmlContent, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}


//struct WebView: UIViewRepresentable {
//    @ObservedObject var viewModel: ViewModel
//    let url: URL
//
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(self)
//    }
//
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        webView.navigationDelegate = context.coordinator
//        webView.load(URLRequest(url: url))
//        return webView
//    }
//
//    func updateUIView(_ webView: WKWebView, context: Context) {
//        // 必要に応じて更新処理を追加
//    }
//
//    class Coordinator: NSObject, WKNavigationDelegate {
//        var parent: WebView
//
//        init(_ parent: WebView) {
//            self.parent = parent
//        }
//
////        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
////            DispatchQueue.main.async {
////                self.parent.viewModel.fetchAllSolutionsToDetail()
////                self.parent.viewModel.isLoading = false
////            }
////        }
//    }
//}

//struct ResultView: View {
//    @ObservedObject var viewModel: ViewModel
//        var body: some View {
//            ScrollView {
//                if viewModel.htmlContent.isEmpty {
//                    ProgressView("経路作成中…")
//                } else {
//                    WebView(htmlContent: viewModel.htmlContent)
//                        .frame(height: 300)
//
//                    Divider()
//
//                    Text("探索経路一覧")
//                        .font(.headline)
//                        .padding(.top)
//
//                    ForEach(viewModel.currentPathes, id: \.self) { path in
//                        ForEach(path, id: \.self) {city in
//                            VStack(alignment: .leading) {
//                                Text(city).font(.title3)
//                            }
//                            .padding(.vertical, 4)
//                            Divider()
//                        }
//                    }
//
//                    Text("セールスマン一覧")
//                        .font(.headline)
//                        .padding(.top)
//                    ForEach(viewModel.currentSalesmen) { salesman in
//                        VStack(alignment: .leading) {
//                            Text(salesman.name)
//                                .font(.title3)
//                            if !salesman.description.isEmpty {
//                                Text("備考: \(salesman.description)")
//                                    .font(.subheadline)
//                                    .foregroundColor(.gray)
//                            }
//                        }
//                        .padding(.vertical, 4)
//                        Divider()
//                    }
//                }
//            }
//            .padding()
//            .onAppear {
//                viewModel.loadData(for: viewModel.updatedCurrentRoute.id)
//            }
//            .navigationTitle("最適経路")
//        }
//}


struct ResultView: View {
    @ObservedObject var viewModel: ViewModel
    let colors: [Color] = [.blue, .red, .green, .purple, .orange]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                if viewModel.htmlContent.isEmpty {
                    ProgressView("経路作成中…")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                } else {
                    // 経路図セクション
                    VStack(alignment: .leading, spacing: 12) {
                        Text("経路図")
                            .font(.headline)

                        WebView(htmlContent: viewModel.htmlContent)
                            .frame(height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 2)
                    }

                    // 探索経路一覧セクション
                    VStack(alignment: .leading, spacing: 8) {
                        Text("探索経路一覧")
                            .font(.headline)
                        
                        ForEach(Array(zip(viewModel.currentSalesmen.indices, viewModel.currentPathes)), id: \.0) { index, path in
                            let salesman = viewModel.currentSalesmen[index]
                            let pathText = path.joined(separator: " → ")
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(salesman.name)
                                    .font(.subheadline)
                                    .foregroundColor(colors[index])
                                
                                Text(pathText)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(8)
                            .background(Color(.secondarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("最適経路")
        .onAppear {
            viewModel.loadData(for: viewModel.updatedCurrentRoute.id)
        }
    }
}




//struct ResultView: View {
//    @ObservedObject var viewModel: ViewModel
//    @State private var shouldLoadWebView = false
//
//    var body: some View {
//        NavigationStack{
//            VStack{
//                if shouldLoadWebView {
//                    WebView(viewModel: viewModel, url: URL(string: "http://127.0.0.1:8000/api/result/\(viewModel.currentRoute.id.uuidString.lowercased())/")!)
//                        .navigationTitle(viewModel.currentRoute.name)
//                        .edgesIgnoringSafeArea(.all)
//                }
//                if viewModel.isLoading {
//                    Text("Loading")
//                }
//                else {
//                    List{
//                        ForEach(0..<viewModel.currentPath.count, id: \.self){ cities in
//                            Section(header: Text("salesman_name")) {
//                                ForEach(viewModel.currentPath[cities], id: \.self){ city in
//                                    Text(city)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            .onAppear{
//                shouldLoadWebView = true
//            }
//            .navigationTitle("最適経路")
//        }
//    }
//}

struct LoadingView: View {
    var body: some View {
            VStack {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle()) // iOS標準のローディング
                    .scaleEffect(2) // サイズを大きくする
                Text("経路を計算中...")
                    .padding(.top, 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.3)) // 半透明の背景
            .edgesIgnoringSafeArea(.all)
        }
}

