//
//  Civilization.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

// stores info related to civilizations in Realm

import Foundation
//import RealmSwift

class Civilization : Codable {

    var name : String = ""
    var dominantSpecies : String = ""
    var population : String = ""
    var mapUrl : String = ""
    var technologyLevel : Double = 0
    var civilizationType : Double = 0
    var mostRecentInvention : String = ""
    var almostInvented : String = ""
    var size : Double = 0
    var colorSchemeIndex : Int = 0

    var consumedAt : Date? = nil

//  var energyConsumption : Double {
//    get {
//      // https://en.wikipedia.org/wiki/Kardashev_scale
//      return pow(10, 10 * civilizationType) + 6
//    }
//  }
//
//  override static func primaryKey() -> String? {
//    return "name"
//  }

}
