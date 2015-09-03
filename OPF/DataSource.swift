//
//  DataSource.swift
//  OPF
//
//  Created by Andrii Tishchenko on 31.08.15.
//  Copyright (c) 2015 Andrii Tishchenko. All rights reserved.
//

import Cocoa


//enum AwfulError: ErrorType {
//    case Bad
//    case Worse
//    case Terrible
//}

class DownloadItem:NSObject {
    let stringURL:String
    var temporaryURL:NSURL? = nil
    var progress:Double = 0.0
    var error:NSError?
    var size:Double = 0.0
    let filename:String
    
//    init (_ stringURL:String) throws { // throws
    init (_ stringURL:String) { // throws
        self.stringURL = stringURL;
        self.progress = 0.0;
        self.size = 0.0;
        self.error = nil;
    
//        do {
            if( ((stringURL.lastPathComponent as String?) != nil) && (count(stringURL.pathExtension) == 3)){
                self.filename=stringURL.lastPathComponent
            }
            else
            {
                let url = NSURL(string:stringURL)
                self.filename = url!.lastPathComponent!
            }

//        } catch {
//            self.filename = ""
//    
//            var e = NSException(name:"name", reason:"reason", userInfo:nil)
//            e.raise()
//        }
    }
}

class DataSource {

    var dataSource: [DownloadItem]?
    var fileHandle : NSFileHandle!
    
    let buffer : NSMutableData!
    let delimData : NSData!
    
    let encoding : UInt = NSUTF8StringEncoding
    let chunkSize : Int = 4096
    
    init?(path: String, delimiter: String = "\n")
    {
        if let fileHandle = NSFileHandle(forReadingAtPath: path),
            delimData = delimiter.dataUsingEncoding(NSUTF8StringEncoding),
            buffer = NSMutableData(capacity: 4096)
        {
            self.fileHandle = fileHandle
            self.delimData = delimData
            self.buffer = buffer
        } else {
            self.fileHandle = nil
            self.delimData = nil
            self.buffer = nil
            self.dataSource = nil
            return nil
        }
    }
    
    deinit {
        self.fileHandle?.closeFile()
        self.fileHandle = nil
        self.dataSource = nil
    }
    
    
    
    func parce(completion:()->(Void))
    {
//        self.dataSource = nil
        self.dataSource = [DownloadItem]()
        self.fileHandle.seekToFileOffset(0)
        buffer.length = 0
//        let regex = NSRegularExpression(pattern: "/^",options: nil, error: nil)!
        var atEof = false
        
        while(!atEof){
        
        // Read data chunks from file until a line delimiter is found:
        var range = buffer.rangeOfData(delimData, options: nil, range: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            let tmpData = fileHandle.readDataOfLength(chunkSize)
            if tmpData.length == 0 {
                // EOF or read error.
                atEof = true
                if buffer.length > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = NSString(data: buffer, encoding: encoding)
                    
                    buffer.length = 0
//                    let item = DownloadItem(line! as String)
                    let element:DownloadItem
                    
//                    do {
                         element = DownloadItem(line! as String)
//                    } catch {
//                        print(1);
//                        continue;
//                    }
                    
                    self.dataSource?.append(element)
                    
//                    self.dataSource?.append(element)
//                    self.dataSource!.addObject(DownloadItem(line! as String))
//                    self.dataSource!.addObject(item)
                    
//                        (line as String?)!)
                }
                // No more lines.
                completion()
                return
            }
            buffer.appendData(tmpData)
            range = buffer.rangeOfData(delimData, options: nil, range: NSMakeRange(0, buffer.length))
        }
        
        // Convert complete line (excluding the delimiter) to a string:
        let line = NSString(data: buffer.subdataWithRange(NSMakeRange(0, range.location)),
            encoding: encoding)
        // Remove line (and the delimiter) from the buffer:
        buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        
//            if regex.firstMatchInString(line! as String, options: nil, range: NSMakeRange(0, line!.length)) != nil {
//                
//            }
            
            self.dataSource?.append(DownloadItem(line! as String))
        }
    }

//    
//    func openFile(filename:String)->Bool
//    {
//        var error:NSError?
//        var content:String = NSString(contentsOfFile: filename, encoding: NSUTF8StringEncoding, error: nil) as! String
//        
// 
//        
//        if let fileHandle = NSFileHandle(forReadingAtPath: filename),
//           let delimData = "\n".dataUsingEncoding(NSUTF8StringEncoding),
//           let buffer = NSMutableData(capacity: 4096)
//        {
//            self.fileHandle = fileHandle
//            self.delimData = delimData
//            self.buffer = buffer
//            
//            self.dataSource = NSMutableArray()
//            
//            
//            
//            
//            
//            
//            
//        } else {
//            self.fileHandle = nil
//            self.delimData = nil
//            self.buffer = nil
//            return nil
//        }
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        
//        return error == nil;
//    }
    
    
    
}





