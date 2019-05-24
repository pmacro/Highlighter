//
//  Highlighter.swift
//  Highlighter
//
//  Created by pmacro on 24/05/2019.
//

import Foundation
import SwiftSyntax

///
/// Provides highlighting information for a file.
///
public struct Highlighter {
  public init(){}

  ///
  /// Returns syntax tokens for the file at the given URL.
  ///
  public func highlight(_ url: URL) throws -> [Token] {
    let sourceFile = try SyntaxTreeParser.parse(url)
    let highlighter = SwiftSyntaxHighlighter()
    _ = highlighter.visit(sourceFile)
    return highlighter.highlightTokens
  }
}
