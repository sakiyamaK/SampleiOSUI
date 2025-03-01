//
//  SwiftUIHositing03View.swift
//  Modules
//
//  Created by sakiyamaK on 2025/01/22.
//

import SwiftUI
import Observation

// モデル: JSONレスポンスをデコードするための構造体
struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

// データ取得ロジックを持つViewModel
@Observable
class PostViewModel {
    var posts: [Post] = []
    var isLoading: Bool = false
    var errorMessage: String?

    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            self.errorMessage = "無効なURLです。"
            return
        }

        Task {
            self.isLoading = true
            self.errorMessage = nil

            do {
                try await Task.sleep(for: .seconds(2))
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
                self.posts = decodedPosts
            } catch {
                self.errorMessage = "データ取得に失敗しました: \(error.localizedDescription)"
            }

            self.isLoading = false
        }
    }
}

// SwiftUIのビュー
struct SwiftUIHosting03View: View {
    private(set) var viewModel: PostViewModel

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(viewModel.posts) { post in
                        VStack(alignment: .leading) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Posts")
            .onAppear {
                viewModel.fetchPosts()
            }
            .refreshable {
                viewModel.fetchPosts()
            }
        }
    }
}

#Preview {
    SwiftUIHosting03View(viewModel: .init())
}
