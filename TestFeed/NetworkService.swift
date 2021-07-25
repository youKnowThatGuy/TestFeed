//
//  NetworkService.swift
//  TestFeed
//
//  Created by Клим on 21.07.2021.
//

import UIKit

class NetworkService{
    private init() {}
    static let shared = NetworkService()
    
    private var baseUrlComponent: URLComponents {
        var _urlComps = URLComponents(string: "https://api.tjournal.ru/v2.0/timeline")!
        _urlComps.queryItems = [
            URLQueryItem(name: "allSite", value: "true"),
            URLQueryItem(name: "sorting", value: "hotness"),
            URLQueryItem(name: "subsitesIds", value: "1, 2"),
            URLQueryItem(name: "hashtag", value: "интернет")
        ]
        return _urlComps
    }
    
    func fetchSingleStockData(lastId: String, lastSortingValue: String ,completion: @escaping (Result<FeedEntries, SessionError>) -> Void){
        
        var urlComps = baseUrlComponent
        if lastId != "none"{
        urlComps.queryItems? += [
        URLQueryItem(name: "lastId", value: lastId),
        URLQueryItem(name: "lastSortingValue", value: lastSortingValue)
        ]
            
        }
        
        guard let url = urlComps.url else {
            DispatchQueue.main.async {
                completion(.failure(.invalidUrl))
            }
            return
        }
        //print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.other(error)))
                }
                return
            }
            let response = response as! HTTPURLResponse
            
            guard let data = data, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(response.statusCode)))
                }
                return
            }
            do {
                let networkResponse = try JSONDecoder().decode(ServerResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(networkResponse.result))
                }
            }
            catch let decodingError{
                DispatchQueue.main.async {
                    completion(.failure(.decodingError(decodingError)))
                }
                
            }
            
        }.resume()
    }
    
    
    func loadImage(from imageId: String, completion: @escaping (UIImage?) -> Void){
        guard let url = URL(string: "https://leonardo.osnova.io/\(imageId)/") else {  DispatchQueue.main.async {
            completion(nil)
        }
        return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data{
                    completion(UIImage(data: data))
                }
                else{
                    completion(nil)
                }
            }
        }.resume()
    }
}
