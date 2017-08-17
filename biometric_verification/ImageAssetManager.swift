//
//  ImageAssetManager.swift
//  biometric_verification
//
//  Created by Daniel Hjärtström on 2016-10-20.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

import UIKit

enum FoundImagesInBundle {
    case success
    case failure
}

class ImageAssetManager: NSObject {
    
   class func loadFileURLSFromFolderInBundle(parentFolder: String, completion: (_ result:[[Data]]?, _ directoriesArray:[String]?, _ status: FoundImagesInBundle) -> ()){
        
        var assetsArray: [[Data]] = []
        var sectionNameArray:[String] = []

        let imageDirectoryUrls = ImageAssetManager.returnImagePath(parentFolder: parentFolder, subDirectory: nil)
        
        guard imageDirectoryUrls.count > 0 else {
        
            completion(nil, nil, .failure)
            return
        }
        
        for directory in imageDirectoryUrls {
            
            sectionNameArray.append((directory.lastPathComponent).capitalized)
            
            var directoryArrayData:[Data] = []
            
            let subDirectories = returnImagePath(parentFolder: parentFolder, subDirectory: directory.lastPathComponent)
            
            for url in subDirectories {
            
                directoryArrayData.append(try! Data(contentsOf: url))
                
                }
            assetsArray.append(directoryArrayData)
        }
        completion(assetsArray, sectionNameArray, .success)
    }
    
    class func returnImagePath(parentFolder: String, subDirectory: String?) -> [URL] {
    
        var imagePathArray: [URL] = []
        
        if let path = Bundle.main.resourcePath {
        
        let imagePath: String
        
        if let subDir = subDirectory {
            
            imagePath = path + parentFolder + subDir
        
        } else {
            
            imagePath = path + parentFolder
            
        }
            
        let url = NSURL(fileURLWithPath: imagePath)
        let fileManager = FileManager.default
        let properties = [URLResourceKey.nameKey, URLResourceKey.localizedTypeDescriptionKey]
        
        do {
            
            imagePathArray = try fileManager.contentsOfDirectory(at: url as URL, includingPropertiesForKeys: properties, options: .skipsHiddenFiles)
            
        } catch let error as NSError {
            
            print(error.localizedDescription)
            
            }
        }

        return imagePathArray
    }
}
