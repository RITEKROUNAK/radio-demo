//
//  DataManager.swift
//  Swift Radio
//
//  Created by Matthew Fecher on 3/24/15.
//  Copyright (c) 2015 Dzmitry Veliaskevich. All rights reserved.
//

import UIKit

struct DataManager {
    
    //*****************************************************************
    // Helper struct to get either local or remote JSON
    //*****************************************************************
    
    static func getStationDataWithSuccess(country: String, success: @escaping ((_ metaData: Data?) -> Void)) {

        DispatchQueue.global(qos: .userInitiated).async {
            if useLocalStations {
                getDataFromFileWithSuccess(country: country) { data in
                    success(data)
                }
            } else {
                guard let stationDataURL = URL(string: stationDataURL) else {
                    if kDebugLog { print("stationDataURL not a valid URL") }
                    success(nil)
                    return
                }
                
                loadDataFromURL(url: stationDataURL) { data, error in
                    success(data)
                }
            }
        }
    }
    
    //*****************************************************************
    // Load local JSON Data
    //*****************************************************************
    
    static func getDataFromFileWithSuccess(country: String, success: (_ data: Data?) -> Void) {
        guard let filePathURL = Bundle.main.url(forResource: country, withExtension: "json") else {
            if kDebugLog { print("The local JSON file could not be found") }
            success(nil)
            return
        }
        
        do {
            let data = try Data(contentsOf: filePathURL, options: .uncached)
            success(data)
        } catch {
            fatalError()
        }
    }
    
    static func getFavDataFromFileWithSuccess(success: (_ data: Data?) -> Void) {
        
        func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            return documentsDirectory
        }
        
        func dataFilePath() -> URL {
          return getDocumentsDirectory().appendingPathComponent("Radios.json")
        }
        
        let path = dataFilePath()

            
        do {
            let data = try Data(contentsOf: path, options: .uncached)
            success(data)
        } catch {
            fatalError()
        }
    }

    
    //*****************************************************************
    // REUSABLE DATA/API CALL METHOD
    //*****************************************************************
    
    static func loadDataFromURL(url: URL, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.allowsCellularAccess = true
        sessionConfig.timeoutIntervalForRequest = 15
        sessionConfig.timeoutIntervalForResource = 30
        sessionConfig.httpMaximumConnectionsPerHost = 1
        
        let session = URLSession(configuration: sessionConfig)
        
        // Use URLSession to get data from an NSURL
        let loadDataTask = session.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                completion(nil, error!)
                if kDebugLog { print("API ERROR: \(error!)") }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                completion(nil, nil)
                if kDebugLog { print("API: HTTP status code has unexpected value") }
                return
            }
            
            guard let data = data else {
                completion(nil, nil)
                if kDebugLog { print("API: No data received") }
                return
            }
            
            // Success, return data
            completion(data, nil)
        }
        
        loadDataTask.resume()
    }
}
