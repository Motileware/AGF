//
//  AppGroupContainer.swift
//  AGF
//
//  Created by WeyHan Ng on 15/12/2015.
//
//

import Foundation

func relativePathWithUrl(url: NSURL, pattern: String, template: String! = "/") -> String {
    do {
        let regex = try NSRegularExpression(pattern: pattern, options: [])
        let path = url.path!
        let range = NSMakeRange(0, path.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let result = regex.stringByReplacingMatchesInString(path, options: [], range: range, withTemplate: template)

        return result

    } catch _ as NSError {
        return url.path!
    }
}

enum itemIcon: String {
    case Directory = "\u{f114}"
    case File = "\u{f016}"
}

class Container: NSObject {
    var groupId = ""
    let groupContainerUrl: NSURL
    let documentsUrl: NSURL
    let groupContainerCopyUrl: NSURL

    var content:Array<Dictionary<String, AnyObject>> = []
    var count = 0


    // MARK: Initializers
    override init() {
        let fileManager = NSFileManager.defaultManager()
        groupContainerUrl = fileManager.containerURLForSecurityApplicationGroupIdentifier(groupId)!
        documentsUrl = fileManager.URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)[0]

        groupContainerCopyUrl = documentsUrl.URLByAppendingPathComponent("GroupContainerCopy")

        super.init()

        self.scanGroupContainer()
        print("Documents: \(documentsUrl.path!)")
        print("GroupContainer: \(groupContainerUrl.path!)")
    }

    convenience init(groupId: String) {
        self.init()

        self.groupId = groupId
    }

    // MARK: Class methods
    func mirrorGroupContainer() {
        let fileManager = NSFileManager.defaultManager()

        do {
            try fileManager.removeItemAtURL(groupContainerCopyUrl)
        } catch let error as NSError {
            print("Error: \(error)")
        }

        if fileManager.fileExistsAtPath(groupContainerCopyUrl.path!) != true {
            do {
                try fileManager.createDirectoryAtURL(groupContainerCopyUrl, withIntermediateDirectories:false, attributes:nil)
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }

        var content:[NSURL]? = nil
        do {
            content = try fileManager.contentsOfDirectoryAtURL(groupContainerUrl, includingPropertiesForKeys:nil, options:.SkipsSubdirectoryDescendants)
        } catch let error as NSError {
            print("Error: \(error)")
        }

        for item in content! {
            do {
                try fileManager.copyItemAtURL(item, toURL: groupContainerCopyUrl.URLByAppendingPathComponent(item.lastPathComponent!))
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }
    }

    func removeItemAtIndexPath(index: Int) {
        let fileManager = NSFileManager.defaultManager()
        let fileUrl = self.itemUrlAtIndex(index)

        do {
            try fileManager.removeItemAtURL(fileUrl)
        } catch let error as NSError {
            print(error)
        }
    }

    func wipe() {
        let fileManager = NSFileManager.defaultManager()

        // TODO: Should not target only Documents.
        // Should delete all files except system created files/dirs using ignore list consists of all system created files.
        // Should also allow custom ignore list.
        let url = groupContainerUrl.URLByAppendingPathComponent("Documents")
        let enumerator = fileManager.enumeratorAtURL(url, includingPropertiesForKeys: nil, options: .SkipsSubdirectoryDescendants, errorHandler: nil)
        while let file = enumerator?.nextObject() as? NSURL {
            do {
                try fileManager.removeItemAtURL(file)
            } catch let error as NSError {
                print("Error: \(error)")
            }
        }

        self.scanGroupContainer()
    }

    func scanGroupContainer() {
        let fileManager = NSFileManager.defaultManager()

        content = Array<Dictionary<String, AnyObject>>()

        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath(groupContainerUrl.path!)!
        while let element = enumerator.nextObject() as? String {
            var item = Dictionary<String, AnyObject>()

            let absPath = (groupContainerUrl.path! as NSString).stringByAppendingPathComponent(element)
            let url = NSURL(fileURLWithPath: absPath)
            item["url"] = url
            item["name"] = url.lastPathComponent

            let pattern = groupContainerUrl.path!.stringByAppendingString("/*")
            item["path"] = relativePathWithUrl(url.URLByDeletingLastPathComponent!, pattern: pattern, template: "\u{2026}/")

            var isDirectory : ObjCBool = false
            fileManager.fileExistsAtPath(absPath, isDirectory:&isDirectory)
            if isDirectory {
                item["icon"] = itemIcon.Directory.rawValue
            } else {
                item["icon"] = itemIcon.File.rawValue
            }

            content.append(item)
        }

        count = content.count
    }

    // MARK: Accessors
    func itemNameAtIndex(i: Int) -> String! {
        return (content[i])["name"] as! String
    }

    func itemUrlAtIndex(i: Int) -> NSURL {
        return (content[i])["url"] as! NSURL
    }

    func itemAtIndex(i: Int) -> Dictionary<String, AnyObject>! {
        return content[i]
    }

    func printDebugInfo() {
        print("groupId: \(groupId)")
        print("groupContainerPath: \(groupContainerUrl.path!)")
        print("documentsPath: \(documentsUrl.path!)")
        print("groupContainerCopyUrl: \(groupContainerCopyUrl)")
    }
}
