//
//  Download.swift
//  andika
//
//  Created by Elvis Tapfumanei on 10/6/17.
//  Copyright © 2017 Elvis Tapfumanei. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import Firebase
import NotificationBannerSwift
import ProgressHUD
import AVFoundation

let storage = Storage.storage()

//Image
func getImageFromURL(url: String, withBlock: @escaping (_ image: UIImage?) -> Void) {
    
    let url = NSURL(string: url)
    
    let downloadQueue = DispatchQueue(label: "imageDownloadQueue")
    
    downloadQueue.async {
        
        let data = NSData(contentsOf: url! as URL)
        
        let image: UIImage!
        
        if data != nil {
            
            
            image = UIImage(data: data! as Data)
            
            DispatchQueue.main.async {
                
                withBlock(image!)
            }
            
        }
    }
    
}


//video

func uploadVideo(video: NSData, chatRoomId: String, view: UIView, withBlock: @escaping (_ videoLink: String?) -> Void) {
    
    

    let dateString = dateFormatter().string(from: Date())
    
    let videoFileName = "VideoMessages/" + chatRoomId + "/" + dateString + ".mov"
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(videoFileName)
    
    
    var task : StorageUploadTask!
    
    task = storageRef.putData(video as Data, metadata: nil, completion: {
        metadata, error in
        
        task.removeAllObservers()
        ProgressHUD.dismiss()
        
        if error != nil {
            let banner = StatusBarNotificationBanner(title: error!.localizedDescription, style: .danger)
                banner.show()
            print("error uploading video \(error!.localizedDescription)")
            

            return
        }
        
        
        let link = metadata!.downloadURL()
        withBlock(link?.absoluteString)
        
    })
    
    task.observe(StorageTaskStatus.progress, handler: {
        snapshot in
        ProgressHUD.show()
        
        
    })
    
    
    
}


func downloadVideo(videoUrl: String, result: @escaping (_ isReadyToPlay: Bool, _ videoFileName: String) -> Void) {
    
    let videoURL = NSURL(string: videoUrl)
    
    let videoFileName = (videoUrl.components(separatedBy: "%").last!).components(separatedBy: "?").first!

    
    if fileExistsAtPath(path: videoFileName) {
        
        result(true, videoFileName)
        
    } else {
        
        let dowloadQueue = DispatchQueue(label: "videoDownloadQueue")
        
        dowloadQueue.async {
            
            let data = NSData(contentsOf: videoURL! as URL)
            
            if data != nil {
                
                var docURL = getDocumentsURL()
                
                docURL = docURL.appendingPathComponent(videoFileName, isDirectory: false)
                
                data!.write(to: docURL, atomically: true)
                
                DispatchQueue.main.async {
                    
                    result(true, videoFileName)
                }
                
            } else {
                let banner = StatusBarNotificationBanner(title: "No Video in database", style: .danger)
                banner.show()
                
                print("No Video in database")
                
            }
        }
    }
    
}

func videoThumbnail(video: NSURL) -> UIImage {
    
    let asset = AVURLAsset(url: video as URL, options: nil)
    
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    let time = CMTimeMakeWithSeconds(0.5, 1000)
    var actualTime = kCMTimeZero
    
    var image: CGImage?
    
    
    do {
        image = try imageGenerator.copyCGImage(at: time, actualTime: &actualTime)
    }
    catch let error as NSError {
        print(error.localizedDescription)
    }
    
    let thumbnail = UIImage(cgImage: image!)
    
    return thumbnail
}


//Audio


func uploadAudio(audioPath: String, chatRoomId: String, view: UIView, withBlock: @escaping (_ audioLink: String?) -> Void) {
    
    
    
   ProgressHUD.show()
    
    let dateString = dateFormatter().string(from: Date())
    
    let audio = NSData(contentsOfFile: audioPath)
    let audioFileName = "AudioMessages/" + chatRoomId + "/" + dateString + ".m4a"
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(audioFileName)
    
    
    var task : StorageUploadTask!
    
    task = storageRef.putData(audio! as Data, metadata: nil, completion: {
        metadata, error in
        
        task.removeAllObservers()
        ProgressHUD.dismiss()
        
        if error != nil {
            
            let banner = StatusBarNotificationBanner(title: error!.localizedDescription, style: .danger)
            banner.show()
            
            print("error uploading audio \(String(describing: error?.localizedDescription))")
            
            return
        }
        
        
        let link = metadata!.downloadURL()
        withBlock(link?.absoluteString)
        
    })
    
    task.observe(StorageTaskStatus.progress, handler: {
        snapshot in
        ProgressHUD.show()
        
    })
    
    
    
}

func downloadAudio(audioUrl: String, result: @escaping (_ audioFileName: String) -> Void) {
    
    

    let audiURL = NSURL(string: audioUrl)
    let audioFileName = (audioUrl.components(separatedBy: "%").last!).components(separatedBy: "?").first!

    if fileExistsAtPath(path: audioFileName) {
        
        result(audioFileName)
    } else {
        
        //start downloading
        
        let downloadQueue = DispatchQueue(label: "audioDownload")
        
        downloadQueue.async {
            
            
            let data = NSData(contentsOf:  audiURL! as URL)
            
            if data != nil {
                
                var docURL = getDocumentsURL()
                
                docURL = docURL.appendingPathComponent(audioFileName, isDirectory: false)
                
                data!.write(to: docURL, atomically: true)
                
                DispatchQueue.main.async {
                    
                    result(audioFileName)
                }
                
                
            } else {
                
                let banner = StatusBarNotificationBanner(title: "Link does not contain audio", style: .danger)
                banner.show()
                print("no audio at link")
            }
        }
    }
    
}


//Helper

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().appendingPathComponent(filename)
    return fileURL.path
}

func getDocumentsURL() -> URL {
    
    let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    
    return documentURL!
}

func fileExistsAtPath(path: String) -> Bool {
    
    var doesExist = false
    
    let filePath = fileInDocumentsDirectory(filename: path)
    let fileManager = FileManager.default
    
    if fileManager.fileExists(atPath: filePath) {
        doesExist = true
    } else {
        doesExist = false
    }
    
    return doesExist
}







