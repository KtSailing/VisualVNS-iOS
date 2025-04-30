//
//  DemonstrationView.swift
//  UserAuthSample
//
//  Created by Mac on 2025/04/20.
//

import SwiftUI

// ホーム画面
struct DemonstrationView: View {
    @StateObject var viewModel = ViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        NavigationLink(destination: RouteListView(viewModel: viewModel)) {
                            ReminderTile(icon: "calendar", color: .blue, title: "探索セット", count: viewModel.routes.count)
                        }
                        NavigationLink(destination: CityListView(viewModel: viewModel)) {
                            ReminderTile(icon: "calendar.circle.fill", color: .red, title: "都市", count: viewModel.cities.count)
                        }
                        NavigationLink(destination: SalesmanListView(viewModel: viewModel)) {
                            ReminderTile(icon: "tray.full.fill", color: .gray, title: "セールスマン", count: viewModel.salesmen.count)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .onAppear{
                viewModel.fetchAllSalesmen()
                viewModel.fetchAllCities()
                viewModel.fetchAllRoutes()
            }
            .navigationTitle("ビジュアルVNS")
        }
    }
}

// クイックアクセスのタイル
struct ReminderQuickAccessView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            NavigationLink(destination: RouteListView(viewModel: viewModel)) {
                ReminderTile(icon: "calendar", color: .blue, title: "探索セット", count: viewModel.routes.count)
            }
            NavigationLink(destination: CityListView(viewModel: viewModel)) {
                ReminderTile(icon: "calendar.circle.fill", color: .red, title: "都市", count: viewModel.cities.count)
            }
            NavigationLink(destination: SalesmanListView(viewModel: viewModel)) {
                ReminderTile(icon: "tray.full.fill", color: .gray, title: "セールスマン", count: viewModel.salesmen.count)
            }
        }
        .padding(.horizontal)
    }
}

// タイルビュー
struct ReminderTile: View {
    var icon: String
    var color: Color
    var title: String
    var count: Int

    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.white)
                .padding(8)
                .background(color)
                .clipShape(Circle())

            Text(title)
                .font(.headline)

            Text("\(count)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// リスト行ビュー
struct ReminderListRow: View {
    var icon: String
    var color: Color
    var title: String
    var count: Int

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(10)
                .background(color)
                .clipShape(Circle())

            Text(title)
                .font(.headline)

            Spacer()

            Text("\(count)")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
    }
}



struct DemonstrationView_Previews: PreviewProvider {
    static var previews: some View {
        DemonstrationView()
    }
}
