//
//  DownloadManager.swift
//  OPF
//
//  Created by Andrii Tishchenko on 31.08.15.
//  Copyright (c) 2015 Andrii Tishchenko. All rights reserved.
//

//import UIKit
import Cocoa

//protocol DownloadManagerDelegate:NSObjectProtocol {
//    func NSDragViewOnNewFile(file:String!);
//}
//
//class DownloadManager {
//    static let sharedInstance = DownloadManager()
//    private init() {}
//}

// must be @objc_block or we won't get memory management on background thread
typealias DownloadManagerCompletion = @objc_block (DownloadItem!) -> ()

protocol DownloaderProtocol:NSObjectProtocol {
    func downloaderProtocolProgress(index:Int, obj:DownloadItem);
}

class Wrapper {
    let p:DownloadManagerCompletion
    let index:Int
    var obj:DownloadItem
    init(_ p:DownloadManagerCompletion,index:Int,obj:DownloadItem){
        self.p = p;
        self.index = index;
        self.obj = obj;
    }
}


class DownloadManager: NSObject, NSURLSessionDownloadDelegate {
    
    weak var delegate:DownloaderProtocol?
    
    let config : NSURLSessionConfiguration
    let q = NSOperationQueue()
    let main = true // try false to move delegate methods onto a background thread
    
    lazy var session : NSURLSession = {
        let queue = (self.main ? NSOperationQueue.mainQueue() : self.q)
        return NSURLSession(configuration:self.config, delegate:self, delegateQueue:queue)
    }()
    
    init(configuration config:NSURLSessionConfiguration, delegate:DownloaderProtocol) {
        self.config = config
        self.delegate = delegate
        super.init()
    }
    
    func download(DI:DownloadItem!,index:Int, completionHandler ch : DownloadManagerCompletion) -> NSURLSessionTask {
        
        println(index);
            let str = DI.stringURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url = NSURL(string:str!)
            let req = NSMutableURLRequest(URL:url!)
            NSURLProtocol.setProperty(Wrapper(ch,index: index,obj:DI), forKey:"ch", inRequest:req)
            let task = self.session.downloadTaskWithRequest(req)
            task.resume()
            return task
        

    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64, totalBytesExpectedToWrite exp: Int64) {
        let req = downloadTask.originalRequest
        let ch : AnyObject = NSURLProtocol.propertyForKey("ch", inRequest:req)!
        var wrp:Wrapper = ch as! Wrapper
        let exec = wrp.p as DownloadManagerCompletion
        let obj:DownloadItem = wrp.obj        
        obj.progress = 100.0 * Double(writ)/Double(exp);
        obj.size = Double(exp).Byte;
        self.delegate!.downloaderProtocolProgress(wrp.index, obj: wrp.obj)
//        println("downloaded \(100*writ/exp)%")
        
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        // unused in this example
        println("did resume")
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        let req = downloadTask.originalRequest
        let ch : AnyObject = NSURLProtocol.propertyForKey("ch", inRequest:req)!
//        let ch : Wrapper = NSURLProtocol.propertyForKey("ch", inRequest:req)! as! Wrapper
        let response = downloadTask.response as! NSHTTPURLResponse
        let stat = response.statusCode
        println("status \(stat)")
        var url : NSURL! = nil
        if stat == 200 {
            url = location
            //println("download \(req.URL!.lastPathComponent)")
        }
        
        var wrp:Wrapper = ch as! Wrapper
        let exec = wrp.p as DownloadManagerCompletion
        let obj:DownloadItem = wrp.obj
        obj.temporaryURL = location
        if self.main {
            exec(obj)
        } else {
            dispatch_sync(dispatch_get_main_queue()) {
                exec(obj)
            }
        }
    }
    
    func cancelAllTasks() {
        self.session.invalidateAndCancel()
    }
    
    deinit {
        println("farewell from DownloadManager")
    }
    
}

