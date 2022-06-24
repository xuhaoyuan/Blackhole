
//  DefaultRealm.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

//import RealmSwift
import Foundation
import XHYCategories


class DataBase: NSObject {

    private(set) var mapList: [Civilization] = []

    @UserDefault(key: "mapList", defaultValue: [])
    private var mapDataList: [Data]

    static let shared = DataBase()

    override init() {
        super.init()
        if self.mapDataList.isEmpty {
            update(maps: CivilizationGenerator.generateDefaultPlanets())
        } else {
            let jsonDecoder = JSONDecoder()
            do {
                mapList = try mapDataList.compactMap({
                    try jsonDecoder.decode(Civilization.self, from: $0)
                })
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func update(maps: Civilization...) {
        update(maps: Array(maps))
    }

    func update(maps: [Civilization]) {
        for item in maps {
            if let first = mapList.firstIndex(where: { $0.name == item.name }) {
                mapList[first] = item
            } else {
                mapList.append(item)
            }
        }

        let jsonEncoder = JSONEncoder()
        do {
            let maps = try mapList.map { try jsonEncoder.encode($0) }
            mapDataList = maps
        } catch {

        }
    }
}


//let DefaultRealm : Realm = {
//
//    let realmPath = DocumentsDirectory.appendingPathComponent("default.realm")
//
//    if !FileManager.default.fileExists(atPath: realmPath) {
//        let bundleRealm = BundleDirectory.path(forResource: "default", ofType: "realm")!
//        try! FileManager.default.copyItem(atPath: bundleRealm, toPath: realmPath)
//    }
//
//    var config = Realm.Configuration()
//    config.fileURL = URL(fileURLWithPath: realmPath)
//    config.schemaVersion = 3
//    config.migrationBlock = { migration, oldSchemaVersion in
//    }
//
////    Realm.Configuration.defaultConfiguration = config
//
//    print("Realm resides at:")
//    print(config.fileURL)
//    print()
//
//    return try! Realm(configuration: config)
//}()
