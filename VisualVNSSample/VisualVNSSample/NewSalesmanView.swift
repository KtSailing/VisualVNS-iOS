import SwiftUI

struct NewSalesmanView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        NavigationView{
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("名前")
                            .font(.headline)
                        TextField("名前を入力", text: $viewModel.updatedCurrentSalesman.name)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                        
                        Text("備考")
                            .font(.headline)
                        TextField("備考を入力", text: $viewModel.updatedCurrentSalesman.description)
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
            .navigationTitle("新しいセールスマン")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("登録") {
                        viewModel.createNewSalesman(salesman: viewModel.updatedCurrentSalesman)
                        viewModel.isShowingNewSalesman.toggle()
                    }
                    .bold()
                    .disabled(viewModel.updatedCurrentSalesman.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onDisappear {
                viewModel.fetchAllSalesmen()
            }
        }
    }
}
