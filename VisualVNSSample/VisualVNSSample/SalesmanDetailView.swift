//
//  SalesmanDetailView.swift
//  UserAuthSample
//
//  Created by Mac on 2025/04/20.
//

import SwiftUI

struct SalesmanDetailView: View {
    @ObservedObject var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("名前")
                        .font(.headline)
                    TextField("名前を入力", text: $viewModel.currentSalesman.name)
//                        .onChange(of: viewModel.currentSalesman.name){newValue in
//                            viewModel.updateSalesmanByName(name: newValue)
//                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    
                    Text("備考")
                        .font(.headline)
                    TextField("備考を入力", text: $viewModel.currentSalesman.description)
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
        .navigationTitle(viewModel.updatedCurrentSalesman.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("更新") {
                    viewModel.updateExistingSalesman(salesman: viewModel.updatedCurrentSalesman)
                    dismiss()
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
