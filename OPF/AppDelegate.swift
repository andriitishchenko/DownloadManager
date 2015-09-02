//
//  AppDelegate.swift
//  OPF
//
//  Created by Andrii Tishchenko on 31.08.15.
//  Copyright (c) 2015 Andrii Tishchenko. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func test(sender:AnyObject)
    {
        NSLog("1");
    }



}

