//
//  LocalStorage.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation

protocol DataSavable {
    func saveNewsResults(_ newsResults: [NewsResult])
}

protocol DataLoadable {
    func loadNewsResults() -> [NewsResult]?
}

class LocalStorageManager : DataSavable, DataLoadable {
    static let shared = LocalStorageManager()

    private init() {}

    func saveNewsResults(_ newsResults: [NewsResult]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(newsResults)
            let jsonString = String(data: encodedData, encoding: .utf8)
            UserDefaults.standard.set(jsonString, forKey: "newsResults")
        } catch {
            print("Error saving news results to UserDefaults: \(error.localizedDescription)")
        }
    }

    func loadNewsResults() -> [NewsResult]? {
        if let jsonString = UserDefaults.standard.string(forKey: "newsResults") {
            do {
                let decoder = JSONDecoder()
                let data = jsonString.data(using: .utf8)!
                let newsResults = try decoder.decode([NewsResult].self, from: data)
                return newsResults
            } catch {
                print("Error loading news results from UserDefaults: \(error.localizedDescription)")
            }
        }
        return nil
    }
}
