//
//  CityListView.swift
//  UserAuthSample
//
//  Created by Mac on 2025/04/02.
//

import SwiftUI

struct CityListView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        List{
            Section(header: Text("Cities")){
                ForEach(viewModel.cities, id: \.id){city in
                    HStack{
                        Text(city.name)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        viewModel.setCurrentCity(city: city)
                        viewModel.isCityDetailPresented = true
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false){
                        Button(action: {
                            viewModel.deleteExistingCity(deleteCityID: city.id)
                        }, label: {
                            Text("削除")
                        })
                    }
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.isCityDetailPresented){
            CityDetailView(viewModel: viewModel)
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
                    viewModel.setNewCity()
                    viewModel.isShowingNewCity = true
                }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $viewModel.isShowingNewCity) {
            NewCityView(viewModel: viewModel)
        }
        .navigationTitle("都市")
    }
}
