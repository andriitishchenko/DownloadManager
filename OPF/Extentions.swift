//
//  Extentions.swift
//  OPF
//
//  Created by Andrii Tishchenko on 01.09.15.
//  Copyright (c) 2015 Andrii Tishchenko. All rights reserved.
//

import Cocoa

extension Double {
    var bit: Double { return self * 8.0 }
    var Byte: Double { return self}
    var kB: Double { return self / 1024.0 }
    var MB: Double { return self / 1024.0 / 1024.0}
    var GB: Double { return self / 1024.0 / 1024.0 / 1024.0 }
    var TB: Double { return self / 1024.0 / 1024.0 / 1024.0 / 1024.0 }
}

extension Double {
    var km: Double { return self * 1000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1000.0 }
    var ft: Double { return self / 3.28084 }
}

