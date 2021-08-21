//
//  SwiftRadio-Settings.swift
//  Swift Radio
//
//  Created by Matthew Fecher on 7/2/15.
//  Copyright (c) 2015 Dzmitry Veliaskevich. All rights reserved.
//

import Foundation
import UIKit

let adRemovalPurchased = UserDefaults.standard

//**************************************
// GENERAL SETTINGS
//**************************************

// Display Comments
let kDebugLog = true

// AirPlayButton Color
let globalTintColor = UIColor(red: 0, green: 189/255, blue: 233/255, alpha: 1);

//**************************************
// STATION JSON
//**************************************

// If this is set to "true", it will use the JSON file in the app
// Set it to "false" to use the JSON file at the stationDataURL

let useLocalStations = true
let stationDataURL   = "http://yoururl.com/json/stations.json"

//**************************************
// SEARCH BAR
//**************************************

// Set this to "true" to enable the search bar
var searchable = true
var hideNextPreviousButtons = false
var hideAirPlayButton = false
