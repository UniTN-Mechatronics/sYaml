//
//  AppDelegate.swift
//  sYaml
//
//  Created by Paolo Bosetti on 28/07/15.
//  Copyright (c) 2015 UniTN. All rights reserved.
//

import Cocoa
import sYaml

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  let yaml = YAML()

  func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
    return true
  }
  
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    // Insert code here to initialize your application
    for i in 0..<Process.argc {
      println("ARGV[\(Int(i))]: \(String.fromCString(Process.unsafeArgv[Int(i)]))")
    }
    var dataString: String?
    var file: String?
    if let path = String.fromCString(Process.unsafeArgv[1]) {
      file = path.stringByAppendingPathComponent("test.yaml")
      dataString = String(contentsOfFile: file!, encoding: NSUTF8StringEncoding, error: nil)
    }
    else {
      file = "none"
      dataString = "---\na: 1\nb: 2\nc:\n  - 1\n  - 2"
    }
    let data = yaml.load(string: dataString!)
    println("data:\n\(data.result)\nerror: \(data.error)")
    
    let obj = ["Paolo", "Bosetti", [3, 7.45], ["name": "Paolo", "surname":"Bosetti", "age":44]]
    println("result: '\(yaml.dump(obj))'")

    println("YAML version: \(yaml.versionString())")
  }

  func applicationWillTerminate(aNotification: NSNotification) {
    // Insert code here to tear down your application
  }


}

