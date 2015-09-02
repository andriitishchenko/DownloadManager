//
//  WindowController.swift
//  OPF
//
//  Created by Andrii Tishchenko on 02.09.15.
//  Copyright (c) 2015 Andrii Tishchenko. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
    deinit {
        println("farewell from WindowController")
    }

}
