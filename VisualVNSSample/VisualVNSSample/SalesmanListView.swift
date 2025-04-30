import SwiftUI

struct SalesmanListView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        List{
            Section(header: Text("Salesmen")){
                ForEach(viewModel.salesmen, id: \.id){salesman in
                    HStack{
                        Text(salesman.name)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        viewModel.setCurrentSalesman(salesman: salesman)
                        viewModel.isSalesmanDetailPresented = true
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false){
                        Button(action: {
                            viewModel.deleteExistingSalesman(deleteSalesmanID: salesman.id)
                        }, label: {
                            Text("削除")
                        })
                    }
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.isSalesmanDetailPresented){
            SalesmanDetailView(viewModel: viewModel)
        }
        .onAppear{
            viewModel.fetchAllSalesmen()
            viewModel.fetchAllCities()
            viewModel.fetchAllRoutes()
            viewModel.isLoading = false
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.setNewSalesman()
                    viewModel.isShowingNewSalesman = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $viewModel.isShowingNewSalesman) {
            NewSalesmanView(viewModel: viewModel)
        }
        .navigationTitle("セールスマン")
    }
}

