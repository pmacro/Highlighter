import Foundation
import Highlighter

/// Invokes `Highlighter` and converts the result to JSON.

let errorJson = "[]"

if let filePath = CommandLine.arguments.last,
  FileManager.default.fileExists(atPath: filePath) {
  let fileURL = URL(fileURLWithPath: filePath)
  
  do {
    let tokens = try Highlighter().highlight(fileURL)
    let tokenData = try JSONEncoder().encode(tokens)
    print(String(data: tokenData, encoding: .utf8) ?? errorJson)
  } catch let error {
    print("[{\"error\" : \"\(error)\"}]")  
  }
} else {
  print(errorJson)
}
