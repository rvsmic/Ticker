//
//  ItemStore.swift
//  Ticker
//
//  Created by Michał Rusinek on 31/08/2022.
//

import Foundation

class ItemStore: ObservableObject {
    @Published var items: [Item] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("items.data")
    }
    
    static func load() async throws -> [Item] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let items): continuation
                        .resume(returning: items)
                }
            }
        }
    }
    
    static func load(completion: @escaping(Result<[Item], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL)
                else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let decodedItems = try JSONDecoder().decode([Item].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(decodedItems))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
    }
    
    @discardableResult
    static func save(items: [Item]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(items: items) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let itemsSaved):
                    continuation.resume(returning: itemsSaved)
                }
            }
        }
    }
    
    static func save(items: [Item], completion: @escaping (Result<Int, Error>)->Void) {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try JSONEncoder().encode(items)
                    let outfile = try fileURL()
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(items.count))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
}
