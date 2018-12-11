//
//  DataHelper.swift
//  Book Binder
//
//  Created by John Pavley on 11/10/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation

let defaultsKey = "savedJsonModel"

/// Creates a JsonModel from a JSON resouce in the application bundle.
///
/// - Parameters:
///   - forResource: Name of the JSON file.
///   - ofType: Type of the JSON file.
///
/// - Returns: Nil or a JsonModel object.
func initFromBundle(forResource: String, ofType: String) -> JsonModel? {
    if let path = Bundle.main.path(forResource: forResource, ofType: ofType) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(JsonModel.self, from: data)
                
            } catch {
                print(error)
                return nil
            }
            
        } catch {
            print(error)
            return nil
        }
    } else {
        print("no resource named \(forResource) of type \(ofType) in path")
        return nil
    }
}

/// Deletes data associated with a key from local phone storage.
///
/// - Parameter key: Name of the key assocated with the data.
func deleteUserDefaults(for key: String) {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: key)
    defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    defaults.synchronize()
}


/// Saves a JsonModel to local phone storage associated with a key.
///
/// - Parameters:
///   - key: Name of the key assocated with the data.
///   - model: The JSON object to save.
func saveUserDefaults(for key: String, with model: JsonModel) {
    let defaults = UserDefaults.standard
    
    do {
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(model)
        
        defaults.set(encoded, forKey: key)
        
    } catch {
        print(error)
    }
}

/// Reads data from local phone storage associated with a key and returns a JsonModel object.
///
/// - Parameter key: Name of the key assocated with the data.
/// - Returns: Nil or the JSON object read from storage.
func readUserDefaults(for key: String) -> JsonModel? {
    let defaults = UserDefaults.standard
    
    do {
        
        if let savedJsonModel = defaults.object(forKey: key) as? Data {
            
            let decoder = JSONDecoder()
            return try decoder.decode(JsonModel.self, from: savedJsonModel)
            
        } else {
            print("no data for key in user defaults")
            return nil
        }
        
    } catch {
        print(error)
        return nil
    }
    
}

