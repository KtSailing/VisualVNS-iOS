//
//  DetailView.swift
//  UserAuthSample
//
//  Created by Mac on 2025/04/07.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        NavigationStack{
            VStack{
                Text("拠点: \(viewModel.currentRoute.depot.name)")

                List{
                    Section(header: Text("訪問場所")){
                        ForEach(viewModel.currentRoute.cities, id: \.id){city in
                            HStack{
                                Text(city.name)
                                Spacer()
                                Text(city.salesman.name)
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                Button(action: {
                                    viewModel.updateRouteByCity(city: city)
                                }, label: {
                                    Text("削除")
                                })
                            }
                        }
                        

                        HStack{
                            Spacer()
                            Menu{
                                ForEach(viewModel.notSelectedCityArray, id: \.id){ notselectedcity in
                                    Button(action: {
                                        viewModel.updateRouteByCity(city: notselectedcity)
                                    }, label: {
                                        Text(notselectedcity.name).tag(notselectedcity as City?)
                                    })
                                }
                            }label: {
                                Label("Add city", systemImage: "menucard")
                            }
                            Spacer()
                        }
                    }
                }

                List{
                    Section(header: Text("訪問する人")){
                        ForEach(viewModel.currentRoute.salesmen, id: \.id){salesman in
                            HStack{
                                Text(salesman.name)
                                Spacer()
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false){
                                Button(action: {
                                    viewModel.updateRouteBySalesman(salesman: salesman)
                                }, label: {
                                    Text("削除")
                                })
                            }
                        }
                        

                        HStack{
                            Spacer()
                            Menu{
                                ForEach(viewModel.notSelectedSalesmanArray, id: \.id){ notselectedsalesman in
                                    Button(action: {
                                        viewModel.updateRouteBySalesman(salesman: notselectedsalesman)
                                    }, label: {
                                        Text(notselectedsalesman.name).tag(notselectedsalesman as Salesman?)
                                    })
                                }
                            }label: {
                                Label("Add salesman", systemImage: "menucard")
                            }
                            Spacer()
                        }
                    }
                }
                
                NavigationLink(destination: {
                    ResultView(viewModel: viewModel)
                }, label: {
                    Text("Solve")
                })

            }
            .navigationTitle(viewModel.currentRoute.name)
            .onAppear{
                viewModel.setNotSelectedCities()
                viewModel.setNotSelectedSalesmen()
            }
        }
    }
}
