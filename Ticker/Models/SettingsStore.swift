//
//  SettingsStore.swift
//  Ticker
//
//  Created by Michał Rusinek on 02/09/2022.
//

import Foundation

class SettingsStore: ObservableObject {
    @Published var settings: TickerSettings = TickerSettings.sampleSettings
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("settings.data")
    }
    
    static func load() async throws -> TickerSettings {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let settings): continuation
                        .resume(returning: settings)
                }
            }
        }
    }
    
    static func load(completion: @escaping(Result<TickerSettings, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL)
                else {
                    DispatchQueue.main.async {
                        completion(.success(TickerSettings.sampleSettings))
                    }
                    return
                }
                let decodedSettings = try JSONDecoder().decode(TickerSettings.self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(decodedSettings))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
    }
    
    @discardableResult
    static func save(settings: TickerSettings) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(settings: settings) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let settingsSaved):
                    continuation.resume(returning: settingsSaved)
                }
            }
        }
    }
    
    static func save(settings: TickerSettings, completion: @escaping (Result<Int, Error>)->Void) {
            DispatchQueue.global(qos: .background).async {
                do {
                    let data = try JSONEncoder().encode(settings)
                    let outfile = try fileURL()
                    try data.write(to: outfile)
                    DispatchQueue.main.async {
                        completion(.success(1))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
}

