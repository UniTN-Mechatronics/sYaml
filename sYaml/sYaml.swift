//
//  sYaml.swift
//  sYaml
//
//  Created by Paolo Bosetti on 28/07/15.
//  Copyright (c) 2015 UniTN. All rights reserved.
//

import Foundation
import sYamlC

extension String {
  struct NumberFormatter {
    static let instance = NSNumberFormatter()
  }
  
  var numericValue: (int: Int, dbl: Double)? {
    if let v = NumberFormatter.instance.numberFromString(self) {
      return (v as Int, v as Double)
    }
    return nil
  }
  
  var doubleValue:Double? {
    if let v = self.numericValue {
      if self.rangeOfString(".") != nil {
        return v.dbl
      }
    }
    return nil
  }
  
  var integerValue:Int? {
    if let v = self.numericValue {
      if self.rangeOfString(".") == nil {
        return v.int
      }
    }
    return nil
  }
}


public class YAML {
  
  
  public init() {
    
  }
  
  deinit {
  
  }
  
  public func load(string: String = "---\n") -> (result: Any, error: String?) {
    let yaml_parser = UnsafeMutablePointer<yaml_parser_t>.alloc(1)
    let yaml_document = UnsafeMutablePointer<yaml_document_t>.alloc(1)
    yaml_parser_initialize(yaml_parser)
    let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    let ptr = UnsafePointer<UInt8>(data.bytes)
    let len = data.length
    yaml_parser_set_input_string(yaml_parser, ptr, len)
    yaml_parser_load(yaml_parser, yaml_document)
    if yaml_parser.memory.error.value != YAML_NO_ERROR.value {
      return ("", "Error at \(yaml_parser.memory.problem_mark.line):\(yaml_parser.memory.problem_mark.column)")
    }
    let root = yaml_document_get_root_node(yaml_document)
    let result: Any = self.nodeToValue(yaml_document, node: root)
    yaml_parser_delete(yaml_parser)
    yaml_document.dealloc(1)
    yaml_parser.dealloc(1)
    return (result, nil)
  }
  
  public func load(path: String) -> (result: Any, error: String?) {
    let dataString = String(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
    return load(string: dataString!)
  }
  
  func nodeToValue(document: UnsafeMutablePointer<yaml_document_t>, node: UnsafeMutablePointer<yaml_node_t>) -> Any {
    switch node.memory.type.value {
    case YAML_SCALAR_NODE.value:
      let s = yaml_node_style(node)
      let len = yaml_node_length(node)
      var data = UnsafeMutablePointer<Int8>.alloc(len)
      yaml_node_get_value(node, &data)
      let scalar = NSString(bytesNoCopy: data, length: len, encoding: NSUTF8StringEncoding, freeWhenDone: true) as! String
      let result: Any = parseScalar(scalar)
      return result
    case YAML_SEQUENCE_NODE.value:
      let start = yaml_sequence_item_start(node)
      let top = yaml_sequence_item_top(node)
      var sequence = [Any]()
      for i in start..<top {
        let n = yaml_document_get_node(document, i.memory)
        sequence.append(self.nodeToValue(document, node: n))
      }
      return sequence
    case YAML_MAPPING_NODE.value:
      let start = yaml_mapping_pairs_start(node)
      let top = yaml_mapping_pairs_top(node)
      var mapping = Dictionary<String, Any>()
      for pair in start..<top {
        let k = yaml_document_get_node(document, pair.memory.key)
        let v = yaml_document_get_node(document, pair.memory.value)
        mapping[(self.nodeToValue(document, node: k) as! AnyObject).description!] = self.nodeToValue(document, node: v)
      }
      return mapping
    default:
      return "Unexpected!"
    }
  }
  
  func parseScalar(str: String) -> Any {
    switch str {
    case "~", "nil", "null", "NULL":
      return ""
    case "true", "True", "TRUE", "yes", "Yes", "YES":
      return true
    case "false", "False", "FALSE", "no", "No", "NO":
      return false
    case let v where v.integerValue != nil:
      return v.integerValue!
    case let v where v.doubleValue != nil:
      return v.doubleValue!
    default:
      return str
    }
  }
  
  
  
  // SERIALIZATION
  
  public func dump(object: AnyObject) -> String {
    let yaml_emitter = UnsafeMutablePointer<yaml_emitter_t>.alloc(1)
    yaml_emitter_initialize(yaml_emitter)
    yaml_emitter_set_encoding(yaml_emitter, YAML_UTF8_ENCODING)
    yaml_emitter_open(yaml_emitter)
    let bufferSize = 1024
    var output = UnsafeMutablePointer<UInt8>.alloc(bufferSize)
    var actualSize = UnsafeMutablePointer<Int>.alloc(1)
    yaml_emitter_set_output_string(yaml_emitter, output, bufferSize, actualSize)
    
    self.addRootObject(object, withEmitter: yaml_emitter)
    
    yaml_emitter_close(yaml_emitter)
    yaml_emitter_delete(yaml_emitter)
    yaml_emitter.dealloc(1)
    return NSString(bytes: output, length: Int(actualSize.memory.value), encoding: NSUTF8StringEncoding) as String!
  }
  
  public func dump(obj: AnyObject, toFileAtPath file: String) {
    self.dump(obj).writeToFile(file, atomically: false, encoding: NSUTF8StringEncoding, error: nil)
  }
  
  func addRootObject(object: AnyObject, withEmitter emitter: UnsafeMutablePointer<yaml_emitter_t>) {
    let document = UnsafeMutablePointer<yaml_document_t>.alloc(1)
    yaml_document_initialize(document, nil, nil, nil, 0, 0)
    
    self.addObject(object, toDocument: document)
    
    yaml_emitter_dump(emitter, document)
    yaml_document_delete(document)
    document.dealloc(1)
  }
  
  func addObject(object: AnyObject, toDocument doc: UnsafeMutablePointer<yaml_document_t>) -> Int32? {
    var result: Int32 = 0
    if let ary = object as? Array<AnyObject> {
      result = yaml_document_add_sequence(doc, nil, YAML_ANY_SEQUENCE_STYLE)
      for element in ary {
        if let idx: Int32 = addObject(element, toDocument: doc) {
          yaml_document_append_sequence_item(doc, result, idx)
        }
      }
    }
    else if let map = object as? Dictionary<String, AnyObject> {
      result = yaml_document_add_mapping(doc, nil, YAML_ANY_MAPPING_STYLE)
      for (key, value) in map {
        if let keyIndex: Int32 = addObject(key, toDocument: doc) {
          if let valueIndex: Int32 = addObject(value, toDocument: doc) {
            yaml_document_append_mapping_pair(doc, result, keyIndex, valueIndex)
          }
        }
        
      }
    }
    else if let str = object as? String {
      var r = str.cStringUsingEncoding(NSUTF8StringEncoding)!
      r.removeLast()
      let len = Int32(r.count)
      let buf = UnsafeMutablePointer<yaml_char_t>(r)
      result = yaml_document_add_scalar(doc, nil, buf, len, YAML_PLAIN_SCALAR_STYLE)
    }
    else if object is Double {
      result = addObject("\(object)", toDocument: doc)!
    }
    else if object is Int {
      result = addObject("\(object)", toDocument: doc)!
    }
    else {
      println("Skipping: \(object), \(object.dynamicType)")
      return nil
    }
    return result
  }

}