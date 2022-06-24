//
//  DocumentsDirectory.swift
//  #000
//
//  Created by Matt Condon on 4/29/16.
//  Copyright © 2016 mattc. All rights reserved.
//

import Foundation

var DocumentsDirectory : NSString = {
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    return paths.first! as NSString
}()

var BundleDirectory : Bundle = {
    return Bundle.main
}()
