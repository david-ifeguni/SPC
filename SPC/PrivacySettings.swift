//
//  Song.swift
//  Tunes
//
//  Created by Abraham Omorogbe on 2018-10-20.
//  Copyright © 2018 Abraham Omorogbe. All rights reserved.
//// MARK - Instance
import Foundation
struct Song: Codable{
    
    let artistName: String
    let trackName: String
    
    let previewUrl: String
    let artworkUrl100:String
    
    var artworkUrl: String {
        return artworkUrl100.replacingOccurrences(of: "100", with: "1000")
    }
}

// MARK: - Downloader
extension Song{
    
    private struct SongResponse: Codable{
        let resultCount: Int
        let results: [Song]
    }
    
    static func search(
        with query: String,
        completionHandler: @escaping ([Song]) -> Void)
    {
        
        let safeQuery = query.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed)!
        
        let path = "https://itunes.apple.com/search"
        + "?entity=song"
        + "&term=\(safeQuery)"
        
        let url = URL(string: path)!
        
////        var request = URLRequest(url: url)
////        request.httpMethod = "POST"
////        let postString = "postDataKey=value"
////        request.httpBody = postString.data(using: .utf8)
////        let task = URLSession.shared.dataTask(with: request)
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            do {
//                guard let data = data else {
//                    throw JSONError.NoData
//
//                }
//                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
//                    throw JSONError.ConversionFailed
//                }
//                completionHandler(json)
//            } catch let error as JSONError {
//                print(error.rawValue)
//
//            } catch let error as NSError {
//                print(error.debugDescription)
//            }
//        }
//        task.resume()
        URLSession.shared.dataTask(with:url, completionHandler: {data, _, _ in
            
            guard let data = data,
                let response = try? JSONDecoder().decode(SongResponse.self, from: data),
                response.resultCount != 0
                else {
                    // error handling??
                completionHandler([])
                return
            }
            
            completionHandler(response.results)
            
            print(data)
        }).resume()

    }
}
