//
//  sYamlTests.swift
//  sYamlTests
//
//  Created by Paolo Bosetti on 31/07/15.
//  Copyright (c) 2015 UniTN. All rights reserved.
//

import Cocoa
import XCTest
import sYaml

class MyTestClass {
  let name: String = "Non-printable class"
}

class MyPrintableTestClass: Printable {
  var description: String {
    return "Printable class"
  }
}

class sYamlTests: XCTestCase {
  let yaml = YAML()
  let test1 = MyTestClass()
  let test2 = MyPrintableTestClass()
  var data: Dictionary<String, AnyObject> = ["bool": true, "int": 1, "flo": 3.14, "str": "Paolo", "ary": [1, 2, 3], "hsh":["a":1, "b":2]]

  override func setUp() {
    super.setUp()
    data["obj1"] = test1
    data["obj2"] = test2
    println("YAML version: \(yaml.versionString)")
    println(yaml.dump(data))
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testString() {
    let yamlData = yaml.dump(data)
    let reparsedData: AnyObject = yaml.load(string: yamlData).result
    let str1: String = data["str"] as! String
    let str2: String = reparsedData["str"] as! String
    XCTAssert(str1 == str2, "Pass")
  }
  
  func testFloat() {
    let yamlData = yaml.dump(data)
    let reparsedData: AnyObject = yaml.load(string: yamlData).result
    let flo1: Double = data["flo"] as! Double
    let flo2: Double = reparsedData["flo"] as! Double
    XCTAssert(flo1 == flo2, "Pass")
  }

  func testInt() {
    let yamlData = yaml.dump(data)
    let reparsedData: AnyObject = yaml.load(string: yamlData).result
    let int1: Int = data["int"] as! Int
    let int2: Int = reparsedData["int"] as! Int
    XCTAssert(int1 == int2, "Pass")
  }

  func testAry() {
    let yamlData = yaml.dump(data)
    let reparsedData: AnyObject = yaml.load(string: yamlData).result
    let ary1: [AnyObject] = data["ary"] as! [AnyObject]
    let ary2: [AnyObject] = reparsedData["ary"] as! [AnyObject]
    for i in 0..<ary1.count {
      XCTAssert(ary1[i] as! Int == ary2[i] as! Int, "Pass")
    }
  }

  func testPerformanceLoad() {
    let yamlData = yaml.dump(data)
    self.measureBlock() {
      for i in 0..<200 {
        self.yaml.load(string: yamlData)
      }
    }
  }

  func testPerformanceDump() {
    self.measureBlock() {
      for i in 0..<200 {
        self.yaml.dump(self.data)
      }
    }
  }

}
