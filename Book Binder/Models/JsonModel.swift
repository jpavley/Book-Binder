//
//  JsonModel.swift
//  BookBinderLab1
//
//  Created by John Pavley on 11/3/18.
//  Copyright © 2018 John Pavley. All rights reserved.
//

import Foundation
/**
 Models a serializable `Publisher` list with `Series`, `Volumes`, `Works`, and `Variants` in JSON.
 See [schema] for JSON schema. See [sample1.json] for example implementation.
 - Note:
    - A publisher is an entity that creates and publically distributes works of art (books, movies, games, etc).
    - A series is a set of related works published in succession (trilogy, sequals, serial, etc).
    - A volume is a marketed subset of a series (boxed set, collected issues, vol. II).
    - A work is a creative product published and distributed.
    - A variant is a particular expression of work in a medium (paperback, hardcover, digital, disc).
*/
struct JsonModel: Codable {
    
    /// The URI object the user has selected.
    /// - URI formet: version/publisher/series/volume/work/variant
    var selectedURI: String
    
    /// A list of publishers contained in this model.
    var publishers: [JsonPublisher]
    
    /**
     Creates a new `JsonModel` with the provided URI and publishers.
     - Parameters: 
        - selectedURI: The URI object the user has selected.
        - publishers: A list of publishers contained in this model.
    */
    init(selectedURI: String, publishers: [JsonPublisher]) {
        self.selectedURI = selectedURI
        self.publishers = publishers
    }
    
    /// Models a serializable `Publisher` in JSON.
    /// A publisher is an entity that creates and publically distributes works of art (books, movies, games, etc).
    struct JsonPublisher: Codable {
        
        /// The name of this publisher.
        var name: String
        
        /// A list of series associated with this publisher.
        var series: [JsonSeries]
        
        /**
         Creates a new `JsonPublisher` with the provided name and series.
         - Parameters:
             - name: The name of this publisher.
             - series: A list of series associated with this publisher.
        */
        init(name: String, series: [JsonSeries]) {
            self.name = name
            self.series = series
        }
        
        /// Models a serializable `Series` in JSON.
        /// A series is a set of related works published in succession (trilogy, sequals, serial, etc).
        struct JsonSeries: Codable {
            
            /// The title of this series.
            var title: String
            
            /// The major characters found in this series.
            var characters: [String]
            
            /// A list of volumes associated with this series.
            var volumes: [JsonVolume]
            
            /**
             Creates a new `JsonSeries` with the provided title, characters, and volumes.
             - Parameters:
                 - title: The title of this series.
                 - characters: The major characters found in this series.
                 - volunes: A list of volumes associated with this series.
            */
            init(title: String, characters: [String], volumes: [JsonVolume]) {
                self.title = title
                self.characters = characters
                self.volumes = volumes
            }
            
            /// Models a serializable `Volume` in JSON.
            /// A volume is a marketed subset of a series (boxed set, collected issues, vol. II).
            struct JsonVolume: Codable {
                
                /// The kind or type of Volume modeled (on-going, one-shot, mini-series, annual, etc).
                var kind: String
                
                /// The year of the historical era when this volume was printed and distributed.
                var era: Int
                
                /// The ordinal number of this volume.
                var number: Int
                
                /// The number of the first work published in the this volume.
                var firstWorkNumber: Int
                
                /// The number of the most recent or last work published in this volume.
                var currentWorkNumber: Int
                
                /// A list of work numbers representing works that were skipped or not published in this volume.
                var skippedWorkNumbers: [Int]
                
                /// A list of the works associated with this volume.
                var works: [JsonWork]
                
                /**
                 Creates a new `JsonVolume` with the provided kind, era, number, firstWorkNumber,
                 currentWorkNumber, skippedWorkNumber, and volumes.
                 - Parameters:
                     - kind: The kind or type of Volume modeled (on-going, one-shot, mini-series, annual, etc).
                     - era: The year of the historical era when this volume was printed and distributed.
                     - number: A list of volumes associated with this series.
                     - firstWorkNumber: The number of the first work published in the this volume.
                     - currentWorkNumber: The number of the most recent or last work published in this volume.
                     - skippedWorkNumbers: A list of work numbers representing works that were skipped or not published in this volume.
                     - works: A list of the works associated with this volume.
                */
                init(kind: String, era: Int, number: Int, firstWorkNumber: Int,
                     currentWorkNumber: Int, skippedWorkNumbers: [Int], works: [JsonWork]) {
                    self.kind = kind
                    self.era = era
                    self.number = number
                    self.firstWorkNumber = firstWorkNumber
                    self.currentWorkNumber = currentWorkNumber
                    self.skippedWorkNumbers = skippedWorkNumbers
                    self.works = works
                }
                
                /// Models a serializable `Work` in JSON.
                /// A work is a creative product published and distributed.
                struct JsonWork: Codable {
                    
                    /// The ordinal number of this work with a volume.
                    var number: Int
                    
                    /// A list of the of the variants associated with this work.
                    var variants: [JsonVariant]
                    
                    /**
                     Creates a new `JsonWork` with the provided number and variants.
                     - Parameters:
                         - number: The ordinal number of this work with a volume.
                         - variants: A list of the of the variants associated with this work.
                    */
                    init(number: Int, variants: [JsonVariant]) {
                        self.number = number
                        self.variants = variants
                    }
                    
                    /// Models a serializable `Variant` in JSON.
                    /// A variant is a particular expression of work in a medium (paperback, hardcover, digital, disc).
                    struct JsonVariant: Codable {
                        
                        /// The date when this variant was released and disributed to the public.
                        var datePublished: String
                        
                        /// The kind of medium of this variant.
                        var kind: String
                        
                        /// The ordinal number of this variant's impression or encoding.
                        var printing: Int
                        
                        /// The ordinal letter of this variant's cover or packaging.
                        var letter: String
                        
                        /// The image ID of this variant's cover or packaging.
                        var coverID: String
                        
                        /// The date the user purchased, licensed, or leased this variant.
                        var dateCollected: String
                        
                        /// The date the user experienced this variant.
                        var dateConsumed: String
                        
                        /**
                         Creates a new `JsonVariant` with the provided datePublished, kind, printing,
                         letter, coverID, dateCollected, and dateConsumed.
                         fir.
                         - Parameters:
                             - datePublished: The date when this variant was released and disributed to the public.
                             - kind: The kind of medium of this variant.
                             - printing: The ordinal number of this variant's impression or encoding.
                             - letter: The ordinal letter of this variant's cover or packaging.
                             - coverID: The image ID of this variant's cover or packaging.
                             - dateCollected: The date the user purchased, licensed, or leased this variant.
                             - dateConsumed: The date the user experienced this variant.
                        */
                        init(datePublished: String, kind: String, printing: Int, letter: String,
                             coverID: String, dateCollected: String, DateConsumed: String) {
                            self.datePublished = datePublished
                            self.kind = kind
                            self.printing = printing
                            self.letter = letter
                            self.coverID = coverID
                            self.dateCollected = dateCollected
                            self.dateConsumed = DateConsumed
                        }
                    }
                }
            }
        }
    }
}
