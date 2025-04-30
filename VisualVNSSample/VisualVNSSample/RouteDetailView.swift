import SwiftUI

struct RouteDetailView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // ルート名・拠点選択エリア
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ルート名")
                            .font(.headline)
                        TextField("ルート名を入力", text: $viewModel.currentRoute.name)
                            .onChange(of: viewModel.currentRoute.name) { newValue in
                                viewModel.updateRouteByName(name: newValue)
                                viewModel.isRouteEdited = true
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("拠点")
                            .font(.headline)
                        Picker("拠点を選択", selection: $viewModel.currentRoute.depot) {
                            ForEach(viewModel.cities, id: \.id) { city in
                                Text(city.name).tag(city as City)
                            }
                        }
                        .onChange(of: viewModel.currentRoute.depot) { newValue in
                            viewModel.updateRouteByDepot(depot: newValue)
                            viewModel.isRouteEdited = true
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    // 都市リスト（カード表示）
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("訪問場所")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Menu {
                                ForEach(viewModel.notSelectedCityArray, id: \.id) { notselectedcity in
                                    Button(notselectedcity.name) {
                                        viewModel.updateRouteByCity(city: notselectedcity)
                                    }
                                }
                            } label: {
                                Label("都市を追加", systemImage: "plus")
                            }
                        }
                        
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.currentRoute.cities, id: \.id) { city in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(city.name)
                                                .font(.headline)
                                            Text("担当: \(city.salesman.name)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Button(role: .destructive) {
                                            viewModel.updateRouteByCity(city: city)
                                        } label: {
                                            Image(systemName: "trash")
                                                .padding(8)
                                                .background(Color.red.opacity(0.1))
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                        }
                    }
                    .padding()
                    
                    // セールスマンリスト（カード表示）
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("セールスマン")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Menu {
                                ForEach(viewModel.notSelectedSalesmanArray, id: \.id) { notselectedsalesman in
                                    Button(notselectedsalesman.name) {
                                        viewModel.updateRouteBySalesman(salesman: notselectedsalesman)
                                    }
                                }
                            } label: {
                                Label("セールスマンを追加", systemImage: "plus")
                            }
                        }
                        
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.currentRoute.salesmen, id: \.id) { salesman in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(salesman.name)
                                            .font(.headline)
                                        Spacer()
                                        Button(role: .destructive) {
                                            viewModel.updateRouteBySalesman(salesman: salesman)
                                        } label: {
                                            Image(systemName: "trash")
                                                .padding(8)
                                                .background(Color.red.opacity(0.1))
                                                .clipShape(Circle())
                                        }
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .shadow(radius: 2)
                            }
                        }
                        Text("備考")
                            .font(.headline)
                        TextField("備考を入力", text: $viewModel.updatedCurrentRoute.description)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding()
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle(viewModel.currentRoute.name.isEmpty ? "ルート詳細" : viewModel.currentRoute.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
            NavigationLink(destination: {
                ResultView(viewModel: viewModel)
                }, label: {
                    Text("探索")
                })
            }
            .onAppear {
                viewModel.setNotSelectedCities()
                viewModel.setNotSelectedSalesmen()
            }
        }
    }
}
