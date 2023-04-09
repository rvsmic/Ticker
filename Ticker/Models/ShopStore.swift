//
//  ShopStore.swift
//  Ticker
//
//  Created by Michał Rusinek on 27/08/2022.
//

import Foundation
import SwiftUI

class ShopStore: ObservableObject {
    @Published var shops: [Shop] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
        .appendingPathComponent("shops.data")
    }
    
    static func load() async throws -> [Shop] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let shops):
                    continuation.resume(returning: shops)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Shop], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let decodedShops = try JSONDecoder().decode([Shop].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(decodedShops))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(shops: [Shop]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(shops: shops) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let shopsSaved):
                    continuation.resume(returning: shopsSaved)
                }
            }
        }
    }
    
    static func save(shops: [Shop], completion: @escaping (Result<Int, Error>)->Void) {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try JSONEncoder().encode(shops)
                    let outfile = try fileURL()
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(shops.count))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    
}
