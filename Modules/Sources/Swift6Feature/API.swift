//
//  API.swift
//  Modules
//
//  Created by sakiyamaK on 2024/12/02.
//

import UIKit

enum APIError: Error {
    case someError(String)
}

actor API {
    func fetch(value: Int, delay: UInt64) async -> String {
        try? await Task.sleep(nanoseconds: delay * 1_000_000_000)
        return "Result from \(value)"
    }
    
    func fetchThrow(value: Int, delay: UInt64, sendError: Bool = false) async throws -> String {
        if Int.random(in: 0...1) == 0 {
            throw CancellationError()
//            throw APIError.someError("error from \(value)")
        }
        try await Task.sleep(nanoseconds: delay * 1_000_000_000)
        return "Result from \(value)"
    }

    func fetchOnceSync(delays: [UInt64], sendError: Bool = false) async throws -> [String] {
        var rtn: [String] = []
        for (index, delay) in delays.enumerated() {
            print("fetch \(index)")
            if Task.isCancelled {
                print("cancel \(index)")
                break
            }
            let v = try await fetchThrow(value: index, delay: delay, sendError: sendError)
            rtn.append(v)
        }
        return rtn
    }
    
    func fetchOnceAsync(delays: [UInt64], sendError: Bool = false) async throws -> [String] {
        try await withThrowingTaskGroup(of: String.self) { group in
            // タスクグループを使用して並列処理を管理
            for (index, delay) in delays.enumerated() {
                print("fetch \(index)")
                group.addTask {
                    // 各タスクを独立して追加
                    try await self.fetchThrow(value: index, delay: delay, sendError: sendError)
                }
            }
            
            // 結果を収集
            var results: [String] = []
            for try await result in group {
                results.append(result)
            }
            
            return results
        }
    }

//    func fetchThumbnails1(for urlStrs: [String]) async throws -> [String: UIImage?] {
//        var thumbnails: [String: UIImage?] = [:]
//
//        for urlStr in urlStrs {
//            let request = URLRequest(url: URL(string: urlStr)!)
//            let (data, _) = try await URLSession.shared.data(for: request)
//            let image = await UIImage(data: data)?.byPreparingThumbnail(ofSize: .init(width: 100, height: 100))
//            thumbnails[urlStr] = image
//        }
//        return thumbnails
//    }
//    
//    func fetchThumbnailsAsyncLet(for urlStr: String) async throws -> UIImage? {
//        let request = URLRequest(url: URL(string: urlStr)!)
//        async let (data, _) = try await URLSession.shared.data(for: request)
//        let image = await UIImage(data: data)?.byPreparingThumbnail(ofSize: .init(width: 100, height: 100))
//        return image
//    }
}
