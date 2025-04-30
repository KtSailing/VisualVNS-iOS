import SwiftUI

struct NewCityView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("都市名")
                            .font(.headline)
                        TextField("都市名を入力", text: $viewModel.updatedCurrentCity.name)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("住所")
                            .font(.headline)
                        TextField("住所を入力", text: $viewModel.updatedCurrentCity.address)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("担当セールスマン")
                            .font(.headline)
                        Picker("セールスマンを選択", selection: $viewModel.updatedCurrentCity.salesman) {
                            ForEach(viewModel.salesmen, id: \.id) { salesman in
                                Text(salesman.name).tag(salesman as Salesman)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        
                        Text("備考")
                            .font(.headline)
                        TextField("備考を入力", text: $viewModel.updatedCurrentCity.description)
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
            .navigationTitle("新しい都市")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("登録") {
                        viewModel.createNewCity(city: viewModel.updatedCurrentCity)
                        viewModel.isShowingNewCity.toggle()
                    }
                    .bold()
                    .disabled(viewModel.updatedCurrentCity.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onDisappear {
                viewModel.fetchAllCities()
            }
        }
    }
}
//共有都市であることを示します。
