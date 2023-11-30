//
//  APODViewModel.swift
//  APODApp
//
//

import Foundation
import SwiftUI
import Combine

class APODViewModel: ObservableObject {
    @Published var apod: APOD?
    @Published var errorMessage: String?

    private let networkManager = NetworkManager()

    init() {
        fetchAPODData(for: Date())
    }


    func fetchAPODData(for date: Date) {
        errorMessage = nil

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)

        networkManager.fetchAPODData(date: dateString) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let apodData):
                        self?.apod = apodData
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
            }
        }
    }
    
    func fetchPreviousAPODData() {
        guard let currentAPODDateString = apod?.date else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let currentAPODDate = dateFormatter.date(from: currentAPODDateString),
           let date = Calendar.current.date(byAdding: .day, value: -1, to: currentAPODDate) {
            fetchAPODData(for: date)
        }
    }

    func fetchNextAPODData() {
        guard let currentAPODDateString = apod?.date else {
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let currentAPODDate = dateFormatter.date(from: currentAPODDateString),
           let date = Calendar.current.date(byAdding: .day, value: 1, to: currentAPODDate) {
            fetchAPODData(for: date)
        }
    }
}
