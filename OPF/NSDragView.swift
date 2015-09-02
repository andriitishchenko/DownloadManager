//
//  NSDragView.swift
//  OPF
//
//  Created by Andrii Tishchenko on 31.08.15.
//  Copyright (c) 2015 Andrii Tishchenko. All rights reserved.
//

import Cocoa

protocol NSDragViewProtocol:NSObjectProtocol {
    // protocol definition goes here
    func NSDragViewOnNewFile(file:String!);
}

class NSDragView: NSView,
NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider {
    weak var delegate:NSDragViewProtocol?
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        
        let types = [NSFilenamesPboardType]
        self.registerForDraggedTypes(types)
    }
    
    
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation{
        println("draggingEntered: \(sender)")
        return NSDragOperation.Every
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool{
        //        println("draggingPerformed: \(sender)")
        //        let pboard = sender.draggingPasteboard()
        //        let url = NSURL.URLFromPasteboard(pboard)
        //        let appDelegate = NSApplication.sharedApplication().delegate as AppDelegate
        //        // TODO: check if file is of correct type
        //        appDelegate.setLocalSourceUrl(NSURL.URLFromPasteboard(pboard))
        
        if let board = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let imagePath = board[0] as? String {
                    self.delegate?.NSDragViewOnNewFile(imagePath)
                return true
            }
        }
        return false
        
        

    }
    
    
    //    func draggingSession(_session: NSDraggingSession,
    //        sourceOperationMaskForDraggingContext context: NSDraggingContext) -> NSDragOperation
    //    {
    //
    //        return NSDragOperation.Copy;
    //    }
    
    func pasteboard(pasteboard: NSPasteboard!, item: NSPasteboardItem!, provideDataForType type: String!){
        
    }
    
    
    // MARK: - NSDraggingSource
    
    // Since we only want to copy/delete the current image we register ourselfes
    // for .Copy and .Delete operations.
    func draggingSession(session: NSDraggingSession, sourceOperationMaskForDraggingContext context: NSDraggingContext) -> NSDragOperation {
        return .Copy | .Delete
    }
    
    // Clear the ImageView on delete operation; e.g. the image gets
    // dropped on the trash can in the dock.
    func draggingSession(session: NSDraggingSession, endedAtPoint screenPoint: NSPoint, operation: NSDragOperation) {
        if operation == .Delete {
            //            self.image = nil
        }
    }
    
    // Track mouse down events and safe the to the poperty.
    override func mouseDown(theEvent: NSEvent) {
        //        self.mouseDownEvent = theEvent
    }
    
    // Track mouse dragged events to handle dragging sessions.
    override func mouseDragged(theEvent: NSEvent) {
        // Calculate the drag distance...
        //        let mouseDown    = self.mouseDownEvent!.locationInWindow
        //        let dragPoint    = theEvent.locationInWindow
        //        let dragDistance = hypot(mouseDown.x - dragPoint.x, mouseDown.y - dragPoint.y)
        //
        //        // ...to cancel the dragging session in case of accidental drag.
        //        if dragDistance < 3 {
        //            return
        //        }
        
    }
}
