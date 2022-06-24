//
//  GeneralState.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import Foundation
import XHYCategories

class GeneralState {

    @UserDefault(key: "hasCreatedUniverse", defaultValue: false)
    static var hasCreatedUniverse : Bool

    @UserDefault(key: "hasIntroducedBlackHole", defaultValue: false)
    static var hasIntroducedBlackHole : Bool

    @UserDefault(key: "blackHoleName", defaultValue: Constant.DefaultBlackHoleName)
    static var blackHoleName : String
}
