//
//  ContentView.swift
//  KekaDemo
//
//  Created by Webappclouds on 26/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel: ViewModel = ViewModel()
    @State private var showAlert = false // Track if the alert is presented
    @State private var isLoading = false // Track if we are loading data from API
    @State private var showContent = false // Control whether to show content (either offline or fetched data)
    
    var body: some View {
        NavigationStack {
            if isLoading {
                ProgressView("Loading...") // Loading spinner for API fetch
                    .progressViewStyle(CircularProgressViewStyle())
                    .font(.title)
            } else if showContent {
                documentList
            } else {
                // Show nothing behind the alert
                Color.clear
            }
        }
        .onAppear {
            // Check if there is offline data available
            if !viewModel.result.isEmpty {
                showAlert = true // Show the alert if offline data exists
            } else {
                // Automatically fetch if no offline data
                Task {
                    await fetchFromAPI()
                }
            }
        }
        .alert("Data Fetching", isPresented: $showAlert) {
            Button("Fetch from API") {
                Task {
                    await fetchFromAPI()
                }
            }
            Button("Show Offline Data", role: .cancel) {
                showContent = true // Just show the offline data (no fetch needed)
            }
        } message: {
            Text("Do you want to fetch the latest data from the API or show the offline data?")
        }
    }
    
    @ViewBuilder
    private var documentList: some View {
        List(viewModel.result, id: \.self) { item in
            HStack {
                AsyncImage(url: URL(string: item.imageUrl ?? "")) { phase in
                    switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                        case .failure(let error):
                            VStack {
                                Image(systemName: "photo.fill")
                                    .frame(width: 50, height: 50)
                                Text("Unable to load, Invalid URL")
                                    .font(.system(size: 14, weight: .regular))
                                    .multilineTextAlignment(.center)
                            }
                        @unknown default:
                            EmptyView()
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(item.abstract ?? "No Abstract")
                    Text(item.webUrl ?? "")
                }
                .font(.system(size: 14, weight: .regular))
            }
        }
        .navigationTitle("Documents")
    }
    
    // Function to handle fetching data from the API with a loading delay
    private func fetchFromAPI() async {
        isLoading = true // Start loading spinner
        showContent = false // Hide content while loading
        
        // Simulate 2-second loading delay
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 seconds
        
        await viewModel.getDocument() // Fetch the document from API
        
        isLoading = false // Stop loading spinner
        showContent = true // Show the fetched data
    }
}
