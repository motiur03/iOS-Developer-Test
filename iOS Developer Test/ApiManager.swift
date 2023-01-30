//
//  ApiManager.swift
//  iOS Developer Test
//
//  Created by Motiur Rahaman on 2023-01-16.
//

import Foundation
import SwiftUI
import Network

class ApiManager: ObservableObject{
    static let shared = ApiManager()
    let apiURL = "https://iphonephotographyschool.com/test-api/lessons"
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    @Published private(set) var connected: Bool = false
    
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                    self.connected = true
            } else {
                    self.connected = false
            }
        }
        monitor.start(queue: queue)
    }
    func generateLession() async throws -> ApiData {
       
        let url = URL(string: apiURL)
        var request = URLRequest(url: url!)
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
                    self.connected = true
                print("conected: \(connected)")
               // request.cachePolicy = .returnCacheDataDontLoad
                    request.cachePolicy = .reloadIgnoringLocalCacheData
                
            } else {
                    self.connected = false
                request.cachePolicy = .returnCacheDataDontLoad
                
                
            }
        }
        monitor.start(queue: queue)

        let task1 = URLSession.shared.dataTask(with: request) {  data, response, error in

           // You will get data from the source when internet is available
           // You will get data from your cache when internet isn't available
           if let data = data {
               print(data)
              // Reload your UI with new or cached data
           }

           // There is some error in your request or server
           // Or the internet isn't available and the cache is empty
           if let error = error {
              // Update your UI to show an error accordingly
               print(error)
           }

        }

        task1.resume()
        
        request.httpMethod = "GET"
        let (response, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ApiData.self, from: response)
        //print ("result \(result)")
       
        return result
    }
    
    
}
    

