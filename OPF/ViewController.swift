//
//  ViewController.swift
//  OPF
//
//  Created by Andrii Tishchenko on 31.08.15.
//  Copyright (c) 2015 Andrii Tishchenko. All rights reserved.
//

import Cocoa
//import NSDragView

class ViewController: NSViewController,NSDragViewProtocol , DownloaderProtocol,
NSTableViewDataSource,NSTableViewDelegate{
    var dataProvider:DataSource!
    var savePath:NSURL!
    var fileManager : NSFileManager!
    var sourceOpened:Bool = false
    var isProcessing:Bool = false
    
    @IBOutlet var labelSavePath: NSTextField!
    @IBOutlet var tableView: NSTableView!
    
    lazy var configuration : NSURLSessionConfiguration = {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        config.allowsCellularAccess = false
        config.URLCache = nil
        config.HTTPMaximumConnectionsPerHost = 5;
        config.timeoutIntervalForResource = 60*5;
        config.timeoutIntervalForRequest = 60*5;
        return config
        }()
    
    lazy var downloader : DownloadManager = {
        return DownloadManager(configuration:self.configuration,delegate:self)
        }()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fileManager = NSFileManager.defaultManager()

        (self.view as? NSDragView)!.delegate = self

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        if (self.dataProvider == nil || self.dataProvider.dataSource?.count == 0)
        {
            self.view.window?.releasedWhenClosed = true
            self.view.window?.close()
            var a:AppDelegate = NSApplication.sharedApplication().delegate as! AppDelegate
            a.killWindod(self.view.window!)
        }
    }
    
    @IBAction func buttonStartCLick(sender: AnyObject) {

        
        if (self.savePath != nil && !self.isProcessing){
            for (var index:Int=0; index<self.dataProvider!.dataSource!.count; index++){
            self.isProcessing = true
                let item:DownloadItem = self.dataProvider!.dataSource![index] as DownloadItem
                
                self.downloader.download(item,index:index) { obj in
                    if (obj == nil)
                    {
                        return
                    }

                    println(obj.filename);
                    var error:NSError?
                    self.fileManager.moveItemAtURL(obj.temporaryURL!,toURL: self.savePath.URLByAppendingPathComponent(obj.filename),error: &error)
                    
                    if ((error) != nil) {
                        println(error);
                        obj.error = error;
                    }
                }
            }
        }
        else
        {
            self.selectSavePath();
        }
        
    }
    

    func NSDragViewOnNewFile(file:String!){
        println(file);
        
        self.dataProvider = DataSource(path:file)
        
        if(self.dataProvider != nil)
        {
            self.dataProvider?.parce({()->() in
                self.tableView.reloadData()
                println("reloaded")
            })
        }
        else
        {
            tableView.reloadData()
        }
        
    }
    
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        if(self.dataProvider != nil)
        {
            return dataProvider!.dataSource!.count
        }
        return 0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

        var cellView: NSTableCellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: self) as! NSTableCellView
        var item:DownloadItem = self.dataProvider!.dataSource![row] as DownloadItem
        let url:String = item.filename
        if tableColumn!.identifier == "id_status" {
            cellView.textField!.stringValue =  String(format: "%.2f%%", item.progress) 
        }
        if tableColumn!.identifier == "id_title" {
            cellView.textField!.stringValue = url
        }
        if tableColumn!.identifier == "id_size" {
            cellView.textField!.stringValue =  String(format: "%.2fMB", item.size.MB)
        }
        
        
        

//         2
//        if tableColumn!.identifier == "id_status" {

            // 3
//            let bugDoc = self.bugs[row]
//            cellView.imageView!.image = bugDoc.thumbImage
//            cellView.textField!.stringValue = bugDoc.data.title
//            return cellView
//        }
        
        
        
        return cellView
    }
    
    
    func tableViewSelectionDidChange(notification: NSNotification) {
//        let selectedDoc = selectedBugDoc()
//        updateDetailInfo(selectedDoc)
//        
//        // Enable/disable buttons based on the selection
//        let buttonsEnabled = (selectedDoc != nil)
//        deleteButton.enabled = buttonsEnabled
//        changePictureButton.enabled = buttonsEnabled
//        bugRating.editable = buttonsEnabled
//        bugTitleView.enabled = buttonsEnabled
        
    }
    
    
    func selectSavePath()
    {
        if self.sourceOpened == true {return}
        self.sourceOpened = true
        let savePanel = NSOpenPanel()
        savePanel.canCreateDirectories = true
        savePanel.canChooseDirectories = true
        savePanel.canChooseFiles = false
        savePanel.allowsMultipleSelection = false
        
        savePanel.beginWithCompletionHandler { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton {
                self.savePath =  savePanel.URL
                self.labelSavePath.stringValue = self.savePath.path!
            }
            self.sourceOpened == false
        }
    }
    
    func openFile()
    {
        let savePanel = NSOpenPanel()
        savePanel.canCreateDirectories = false
        savePanel.canChooseDirectories = false
        savePanel.canChooseFiles = true
        savePanel.allowsMultipleSelection = false
        
        savePanel.beginWithCompletionHandler { (result: Int) -> Void in
            if result == NSFileHandlingPanelOKButton {
                
                self.NSDragViewOnNewFile(savePanel.URL?.path)
//                self.savePath =  savePanel.URL
//                self.labelSavePath.stringValue = self.savePath.path!
            }
            self.sourceOpened == false
        }
    }

    
    
    @IBAction func buttonPathClick(sender: AnyObject) {
        self.selectSavePath();
    }
    
    
    func downloaderProtocolProgress(index:Int, obj:DownloadItem){
        self.dataProvider!.dataSource![index] = obj;
        self.tableView.reloadDataForRowIndexes( NSIndexSet(index: index),
                                                columnIndexes: NSIndexSet(indexesInRange: NSMakeRange(0, 2))
            )
    }
    
    
    
}

