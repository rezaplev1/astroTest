//
//  UserListView.swift
//  reza
//
//  Created by reza pahlevi on 03/08/25.
//

import SwiftUI

struct UserListView: View {
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Toolbar & Search
            VStack(alignment: .leading) {
                Text("GitHub Users").font(.headline)
                Text("Astro Test").font(.subheadline).foregroundColor(.gray)
            }

            TextField("Search username...", text: $viewModel.searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Sort buttons
            if !viewModel.users.isEmpty && !viewModel.isInitialLoading && !viewModel.isError {
                HStack {
                    Button(action: { viewModel.setSortType(.ascending) }) {
                        Text("Ascending")
                            .font(.footnote)
                            .padding(8)
                            .background(viewModel.sortType == .ascending ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    Button(action: { viewModel.setSortType(.descending) }) {
                        Text("Descending")
                            .font(.footnote)
                            .padding(8)
                            .background(viewModel.sortType == .descending ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                }
            }

            // Content Area
            Group {
                if viewModel.isInitialLoading {
                    Spacer()
                    HStack {
                        Spacer()
                        ActivityIndicator(isAnimating: .constant(true), style: .medium)
                        Spacer()
                    }
                    Spacer()
                } else if viewModel.isError {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                            Text("Failed to load users.")
                        }
                        Spacer()
                    }
                    Spacer()
                } else if viewModel.users.isEmpty && !viewModel.searchText.isEmpty {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.badge.questionmark")
                                .foregroundColor(.gray)
                            Text("No users found.")
                        }
                        Spacer()
                    }
                    Spacer()
                } else {
                    // User list + loading next page
                    List {
                        ForEach(viewModel.users, id: \.id) { user in
                            HStack {
                                Text(user.username)
                                Spacer()
                                Image(systemName: user.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(user.isFavorite ? .yellow : .gray)
                                    .onTapGesture {
                                        viewModel.toggleFavorite(user: user)
                                    }
                            }
                            .onAppear {
                                viewModel.loadNextPageIfNeeded(currentItem: user)
                            }
                        }

                        if viewModel.isLoadingNextPage {
                            HStack {
                                Spacer()
                                ActivityIndicator(isAnimating: .constant(true), style: .medium)
                                Spacer()
                            }
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}
