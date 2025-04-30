//
//  RouteListView.swift
//  UserAuthSample
//
//  Created by Mac on 2025/04/03.
//

import SwiftUI

struct RouteListView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack{
            List{
                ForEach(viewModel.routes, id: \.id){route in
                    HStack{
                        Text(route.name)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture{
                        viewModel.setCurrentRoute(route: route)
                        viewModel.isRouteDetailPresented = true
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false){
                        Button(action: {
                            viewModel.deleteExistingRoute(deleteRouteID: route.id)
                        }, label: {
                            Text("削除")
                        })
                    }
                }
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
                        viewModel.setNewRoute()
                        viewModel.isShowingNewRoute = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .sheet(isPresented: $viewModel.isShowingNewRoute) {
                NewRouteView(viewModel: viewModel)
            }
            .navigationTitle("探索セット")
        }
        .navigationDestination(isPresented: $viewModel.isRouteDetailPresented){
            RouteDetailView(viewModel: viewModel)
        }
    }
}

//admin
//1019kohta
