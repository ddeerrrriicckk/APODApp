//
//  NetworkManager.swift
//  APODApp
//
//

import Foundation

class NetworkManager {
    private let baseURL = "https://api.nasa.gov/planetary/apod"
    private let apiKey = "DEMO_KEY"

    func fetchAPODData(date: String, completion: @escaping (Result<APOD, APIError>) -> Void) {
        let urlString = "\(baseURL)?api_key=\(apiKey)&date=\(date)"

        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }

//            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                completion(.failure(.responseUnsuccessful))
//                return
//            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.responseUnsuccessful))
                return
            }
            
            if httpResponse.statusCode == 400 || httpResponse.statusCode == 404 {
                completion(.failure(.noDataAvailable))
                return
            } else if httpResponse.statusCode == 429 {
                completion(.failure(.rateLimitExceeded))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let apod = try decoder.decode(APOD.self, from: data)
                completion(.success(apod))
            } catch {
                completion(.failure(.jsonDecodingFailure))
            }
        }
        task.resume()
    }
}
