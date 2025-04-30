import SwiftUI

struct NewRouteView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 24) {
                    // ルート情報入力エリア
                    VStack(alignment: .leading, spacing: 16) {
                        Text("ルート名")
                            .font(.headline)
                        TextField("ルート名を入力", text: $viewModel.updatedCurrentRoute.name)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("拠点")
                            .font(.headline)
                        Picker("拠点を選択", selection: $viewModel.updatedCurrentRoute.depot) {
                            ForEach(viewModel.cities, id: \.id) { city in
                                Text(city.name).tag(city as City)
                            }
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
                    
                    // 訪問都市リスト
                    VStack(alignment: .leading, spacing: 16) {
                        Text("訪問場所")
                            .font(.title2)
                            .bold()
                        
                        ForEach(viewModel.currentRoute.cities, id: \.id) { city in
                            HStack {
                                Text(city.name)
                                Spacer()
                                Text(city.salesman.name)
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.updateRouteByCity(city: city)
                                } label: {
                                    Text("削除")
                                }
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Menu {
                                ForEach(viewModel.notSelectedCityArray, id: \.id) { notselectedcity in
                                    Button(notselectedcity.name) {
                                        viewModel.updateCurrentRouteByCity(city: notselectedcity)
                                    }
                                }
                            } label: {
                                Label("都市を追加", systemImage: "plus")
                                    .padding()
                                    .background(Color(.secondarySystemFill))
                                    .cornerRadius(8)
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    // 訪問セールスマンリスト
                    VStack(alignment: .leading, spacing: 16) {
                        Text("訪問する人")
                            .font(.title2)
                            .bold()
                        
                        ForEach(viewModel.currentRoute.salesmen, id: \.id) { salesman in
                            HStack {
                                Text(salesman.name)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.updateRouteBySalesman(salesman: salesman)
                                } label: {
                                    Text("削除")
                                }
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Menu {
                                ForEach(viewModel.notSelectedSalesmanArray, id: \.id) { notselectedsalesman in
                                    Button(notselectedsalesman.name) {
                                        viewModel.updateCurrentRouteBySalesman(salesman: notselectedsalesman)
                                    }
                                }
                            } label: {
                                Label("セールスマンを追加", systemImage: "plus")
                                    .padding()
                                    .background(Color(.secondarySystemFill))
                                    .cornerRadius(8)
                            }
                            Spacer()
                        }
                        Text("備考")
                            .font(.headline)
                        TextField("備考を入力", text: $viewModel.updatedCurrentRoute.description)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top, 20)
            }
            .navigationTitle("新しいルート")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("登録") {
                        viewModel.createNewRoute(route: viewModel.updatedCurrentRoute)
                        viewModel.isShowingNewRoute.toggle()
                    }
                    .bold()
                    .disabled(viewModel.currentRoute.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear {
                viewModel.setNotSelectedCities()
                viewModel.setNotSelectedSalesmen()
            }
            .onDisappear {
                viewModel.fetchAllRoutes()
            }
        }
    }
}
