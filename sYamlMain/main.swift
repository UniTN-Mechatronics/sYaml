//
//  main.swift
//  sYamlMain
//
//  Created by Paolo Bosetti on 30/07/15.
//  Copyright (c) 2015 UniTN. All rights reserved.
//

import Foundation
import sYaml

let yaml = YAML()

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
let data = yaml.load(str: dataString!)
println("data:\n\(data.result)\nerror: \(data.error)")
