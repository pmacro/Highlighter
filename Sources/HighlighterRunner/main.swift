import Foundation
import Highlighter

/// Invokes `Highlighter` and converts the result to JSON.

let errorJson = "[]"

if let filePath = CommandLine.arguments.last,
  FileManager.default.fileExists(atPath: filePath) {
  let fileURL = URL(fileURLWithPath: filePath)
  
  let tokens = try? Highlighter().highlight(fileURL)
  if let tokens = tokens {
    if let tokenData = try? JSONEncoder().encode(tokens) {
      print(String(data: tokenData, encoding: .utf8) ?? errorJson)
    }
  }
} else {
  print(errorJson)
}
