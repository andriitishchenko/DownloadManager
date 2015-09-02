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
    
//   weak var windowW:NSWindow?
    
//    var window:WindowController?
    let storyboard = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    
    lazy var windows = [NSWindow]()
    
    
//    init(varq:String){
////                 var window:WindowController =
//        self.window = storyboard!.instantiateControllerWithIdentifier("WindowController") as! WindowController
//    }
//
//    func storyboard()->NSStoryboard
//    {
//        let storyboard = NSStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        return storyboard!
//    }


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.windows.append((NSApplication.sharedApplication().windows.last as! NSWindow))
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func openDocument(sender:AnyObject)
    {
        
        var active:NSWindow?
        for w:NSWindow in self.windows
        {
//            if (w != nil)
//            {
                if ((w.keyWindow) == true)
                {
                    active = w
                    break
                }
//            }
        }
        
        if (active == nil)
        {
            var v:WindowController = self.createNewWindow()
            v.showWindow(nil)
            active = v.window
        }
        
        active!.makeKeyAndOrderFront(nil)
        (active!.contentViewController as! ViewController).openFile()
    }
    
    
    func createNewWindow()->WindowController
    {
        var w:WindowController = (storyboard!.instantiateControllerWithIdentifier("WindowController") as! WindowController)
        self.windows.append(w.window!);
        return w
    }

    @IBAction func newDocument(sender:AnyObject)
    {
        var w:WindowController = self.createNewWindow()
        w.showWindow(nil)
    }
    
//    - (BOOL)validateMenuItem:(NSMenuItem *)theMenuItem
//    {
//    BOOL enable = [self respondsToSelector:[theMenuItem action]];
//    
//    // disable "New" if the window is already up
//    if ([theMenuItem action] == @selector(newDocument:))
//    {
//    if ([[myWindowController window] isKeyWindow])
//    {
//    enable = NO;
//    }
//    }
//    return enable;
//    }

    
//    - (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
//    {
//    if(!flag)
//    {
//    id window;
//    for(window in theApplication.windows)
//    {
//    NSWindow *w = window;
//    [w makeKeyAndOrderFront:self];
//    }
//    }
//    return YES;
//    }
    
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag{
            for window in sender.windows{
                if let w = window as? NSWindow{
                    w.makeKeyAndOrderFront(self)
                }
            }
        }
        
        if (self.windows.count == 0){
            self.newDocument(self)
        }
        
        return true
    }
    
    func killWindod(window:NSWindow)
    {
        var index:Int = (self.windows as NSArray).indexOfObject(window)
        if (index != NSNotFound)
        {
            self.windows.removeAtIndex(index)
        }
    }
}
//
//extension _ArrayType where Generator.Element : Equatable_ = _ = {
//    mutating func removeObject(object : Self.Generator.Element) {
//        while let index = self.indexOf(object){
//            self.removeAtIndex(index)
//        }
//    }
//}
//
//func find<C : CollectionType where C.Generator.Element : Equatable>(domain: C, value: C.Generator.Element) -> C.Index?

