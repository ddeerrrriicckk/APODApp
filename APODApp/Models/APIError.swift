//
//  APIError.swift
//  APODApp
//
//

import Foundation

enum APIError: Error {
    case requestFailed
    case jsonDecodingFailure
    case invalidData
    case responseUnsuccessful
    case invalidURL
    case noInternetConnection
    case rateLimitExceeded
    case noDataAvailable
    
    var localizedDescription: String {
        switch self {
            case .requestFailed:
                return "Request Failed"
            case .jsonDecodingFailure:
                return "JSON Decoding Failure"
            case .invalidData:
                return "Invalid Data"
            case .responseUnsuccessful:
                return "Response Unsuccessful"
            case .invalidURL:
                return "Invalid URL"
            case .noInternetConnection:
                return "No Internet Connection"
            case .rateLimitExceeded:
                return "Exceeded Rate Limit"
            case .noDataAvailable:
                return "No data available for date"
        }
    }
}
