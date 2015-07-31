//
//  sYamlTests.swift
//  sYamlTests
//
//  Created by Paolo Bosetti on 28/07/15.
//  Copyright (c) 2015 UniTN. All rights reserved.
//

import Cocoa
import XCTest
import sYaml
import sYamlC

class sYamlTests: XCTestCase {
  let yaml = YAML()
  let testFileName = "test.yaml"
  var file: String?
  var dataString: String?
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if let path = String.fromCString(Process.unsafeArgv[1]) {
      self.file = path.stringByAppendingPathComponent(testFileName)
      dataString = String(contentsOfFile: self.file!, encoding: NSUTF8StringEncoding, error: nil)
    }
    else {
      self.file = "none"
      dataString = "---\na: 1\nb: 2\nc:\n  - 1\n  - 2"
    }
    let delegate = NSApplication.sharedApplication().delegate!
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testLoading() {
    // This is an example of a functional test case.
    let data: Any = self.yaml.load(string: dataString!).result
    if let dict = data as? Dictionary<String, Any> {
      XCTAssertNil(dict["d"] as? AnyObject, "Pass")
      if let ary = dict["ary"] as? [Int] {
        XCTAssertEqual(ary[0], 1, "Pass")
      }
    }
    
  }
  
  func testPerformance() {
    // This is an example of a performance test case.
    self.measureBlock() {
      let data =  self.yaml.load(string: self.dataString!)
    }
  }
    
}
