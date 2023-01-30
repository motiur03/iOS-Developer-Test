//
//  DownloadManager.swift
//  iOS Developer Test
//
//  Created by Motiur Rahaman on 2023-01-22.
//

import Foundation
import AVKit

final class DownloadManager: ObservableObject {
    @Published var isDownloading = false
    @Published var isDownloaded = false
    @Published var urlString: String = ""
    @Published var task: URLSessionTask?
    @Published var observation: NSKeyValueObservation?
    @Published var progress: Double = 0

    func downloadFile() {
        print("downloadFile")
        isDownloading = true
        let ch = Character("/")
        let result = urlString.split(separator: ch)
        let ch1 = Character(".")
        let str = result.last
        let result1 = str?.split(separator: ch1)
        print("Result: \(result1?.first! ?? "")")
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("\(result1!.first!).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                print("File already exists")
                isDownloading = false
                
            } else {
                
                print("PrintURL: \(urlString)")
                let urlRequest = URLRequest(url: URL(string: urlString)!)

                task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                    print("progress1:")
                    if let error = error {
                        print("Request error: ", error)
                        DispatchQueue.main.async {
                            self.isDownloading = false
                        }
                        return
                    }

                    guard let response = response as? HTTPURLResponse else { return }
                    
                   
                    if response.statusCode == 200 {
                        guard let data = data else {
                            self.isDownloading = false
                            return
                        }
                        
                        DispatchQueue.main.async {
                            do {
                                try data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                
                                DispatchQueue.main.async {
                                    
                                    self.isDownloading = false
                                    self.isDownloaded = true
                                }
                                
                            } catch let error {
                                print("Error decoding: ", error)
                                self.isDownloading = false
                            }
                        }
                    }
                    
                }
                self.observation = self.task?.progress.observe(\.fractionCompleted) { observationProgress, _ in
                      DispatchQueue.main.async {
                          self.progress = observationProgress.fractionCompleted
                      }
                    }
                task?.resume()
                //self.task = dataTask
            }
        }
    }

    func deleteFile() {
        let ch = Character("/")
        let result = urlString.split(separator: ch)
        let ch1 = Character(".")
        let str = result.last
        let result1 = str?.split(separator: ch1)
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("\(result1!.first!).mp4")
        if let destinationUrl = destinationUrl {
            guard FileManager().fileExists(atPath: destinationUrl.path) else { return }
            do {
                try FileManager().removeItem(atPath: destinationUrl.path)
                print("File deleted successfully")
                isDownloaded = false
            } catch let error {
                print("Error while deleting video file: ", error)
            }
        }
    }
    func cancelDownloading() {

           task?.cancel()
           observation?.invalidate()
           progress = 0
        
 
    }

    func checkFileExists() {
        let ch = Character("/")
        let result = urlString.split(separator: ch)
        let ch1 = Character(".")
        let str = result.last
        let result1 = str?.split(separator: ch1)
       // print("Result: \(result1?.first! ?? "")")
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destinationUrl = docsUrl?.appendingPathComponent("\(result1!.first!).mp4")
        print("docsURL: \(destinationUrl!)")
        if let destinationUrl = destinationUrl {
            print("destinationUrl.path: \(FileManager().fileExists(atPath: destinationUrl.path))")
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                isDownloaded = true
            } else {
                isDownloaded = false
            }
        } else {
            isDownloaded = false
        }
    }

    func getVideoFileAsset() -> AVPlayerItem? {
        let ch = Character("/")
        let result = urlString.split(separator: ch)
        let ch1 = Character(".")
        let str = result.last
        let result1 = str?.split(separator: ch1)
        
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

        let destinationUrl = docsUrl?.appendingPathComponent("\(result1!.first!).mp4")
        if let destinationUrl = destinationUrl {
            if (FileManager().fileExists(atPath: destinationUrl.path)) {
                let avAssest = AVAsset(url: destinationUrl)
                return AVPlayerItem(asset: avAssest)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
