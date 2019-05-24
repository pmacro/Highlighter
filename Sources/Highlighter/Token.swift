//
//  Token.swift
//  Highlighter
//
//  Created by Paul MacRory  on 08/02/2019.
//

import Foundation

public struct Position: Codable {
  public let start: Int
  public let end: Int
}

public enum TokenType: Int, Codable {
  case className
  case functionName
  case importName
  case identifier
  case integer
  case float
  case keyword
  case string
  case atSign
  case `self`
  case `any`
  case stringInterpolationAnchor
  case lineComment
  case blockComment
  case operatorsAndPunctuation
  case newLine
  case unknown
}

public struct Token: Codable {
  public let string: String
  public let tokenType: TokenType
  public let position: Position
  
  init(_ string: String, tokenType: TokenType, position: Position) {
    self.string = string
    self.tokenType = tokenType
    self.position = position
  }
}
