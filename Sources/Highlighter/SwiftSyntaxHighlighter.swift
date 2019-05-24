//
//  SwiftSyntaxHighlighter.swift
//  Highlighter
//
//  Created by pmacro on 24/05/2019.
//

import Foundation
import SwiftSyntax

///
/// A SyntxRewriter that collects syntax information relevant to syntax highlighting.
///
class SwiftSyntaxHighlighter: SyntaxRewriter {
  
  /// The previously processed token.
  var previousToken: TokenSyntax?
  
  /// All found tokens relevant to syntax highlighting.
  var highlightTokens: [Token] = []
  
  ///
  /// Visit function for a sytax node.
  ///
  override func visit(_ token: TokenSyntax) -> Syntax {
    defer { previousToken = token }
    
    let position = Position(start: token.position.utf8Offset,
                            end: token.endPosition.utf8Offset)
    
    highlightTokens.append(contentsOf: highlightedTokens(for: token.leadingTrivia,
                                                         position: position))
    
    if let token = highlightedToken(for: token, position: position) {
      highlightTokens.append(token)
    }
    
    highlightTokens.append(contentsOf: highlightedTokens(for: token.trailingTrivia,
                                                         position: position))
    
    return token
  }
  
  ///
  /// Converts a `TokenSyntax` into a `Token`, where SyntaxToken is a the representation of
  /// a token in SwiftSyntax, while `Token` represents the highlighting information for a token.
  ///
  private func highlightedToken(for token: TokenSyntax, position: Position) -> Token? {
    var output: Token? = nil
    
    switch token.tokenKind {
    case .integerLiteral(let string):
      if string.hasPrefix("0b") {
        output = Token(string, tokenType: .integer, position: position)
      } else if string.hasPrefix("0o") {
        output = Token(string, tokenType: .integer, position: position)
      } else if string.hasPrefix("0x") {
        output = Token(string, tokenType: .integer, position: position)
      } else {
        output = Token(string, tokenType: .integer, position: position)
      }
    case .floatingLiteral(let string):
      output = Token(string, tokenType: .float, position: position)
    case let .spacedBinaryOperator(string),
         let .unspacedBinaryOperator(string):
      output = Token(string, tokenType: .float, position: position)
    case .stringLiteral(let string),
         .stringSegment(let string):
      output = Token(string, tokenType: .string, position: position)
    case .stringInterpolationAnchor:
      output = Token(token.text, tokenType: .stringInterpolationAnchor, position: position)
    case .atSign:
      output = Token(token.text, tokenType: .atSign, position: position)
    case .selfKeyword, .superKeyword:
      output = Token(token.text, tokenType: .self, position: position)
    case .anyKeyword:
      output = Token(token.text, tokenType: .any, position: position)
    case .breakKeyword,
         .caseKeyword,
         .continueKeyword,
         .defaultKeyword,
         .doKeyword,
         .elseKeyword,
         .fallthroughKeyword,
         .ifKeyword,
         .inKeyword,
         .forKeyword,
         .returnKeyword,
         .switchKeyword,
         .whereKeyword,
         .whileKeyword,
         .tryKeyword,
         .catchKeyword,
         .throwKeyword,
         .guardKeyword,
         .deferKeyword,
         .repeatKeyword,
         .asKeyword,
         .isKeyword,
         .capitalSelfKeyword,
         .__column__Keyword,
         .__file__Keyword,
         .__function__Keyword,
         .__line__Keyword,
         .inoutKeyword,
         .operatorKeyword,
         .throwsKeyword,
         .rethrowsKeyword,
         .precedencegroupKeyword:
      output = Token(token.text, tokenType: .keyword, position: position)
    case .classKeyword,
         .deinitKeyword,
         .enumKeyword,
         .extensionKeyword,
         .funcKeyword,
         .importKeyword,
         .initKeyword,
         .internalKeyword,
         .letKeyword,
         .privateKeyword,
         .protocolKeyword,
         .publicKeyword,
         .staticKeyword,
         .structKeyword,
         .subscriptKeyword,
         .typealiasKeyword,
         .varKeyword,
         .associatedtypeKeyword,
         .fileprivateKeyword:
      output = Token(token.text, tokenType: .keyword, position: position)
    case .trueKeyword, .falseKeyword, .nilKeyword:
      output = Token(token.text, tokenType: .keyword, position: position)
    case .poundEndifKeyword,
         .poundElseKeyword,
         .poundElseifKeyword,
         .poundIfKeyword,
         .poundSourceLocationKeyword,
         .poundFileKeyword,
         .poundLineKeyword,
         .poundColumnKeyword,
         .poundDsohandleKeyword,
         .poundFunctionKeyword,
         .poundSelectorKeyword,
         .poundKeyPathKeyword,
         .poundColorLiteralKeyword,
         .poundFileLiteralKeyword,
         .poundImageLiteralKeyword:
      output = Token(token.text, tokenType: .keyword, position: position)
    case .contextualKeyword(let string):
      output = Token(string, tokenType: .float, position: position)
    case .equal, .arrow, .comma, .period, .colon, .semicolon,
         .stringQuote, .backslash,
         .wildcardKeyword,
         .prefixPeriod,
         .infixQuestionMark,
         .postfixQuestionMark,
         .leftAngle, .rightAngle,
         .leftBrace, .rightBrace,
         .leftParen, .rightParen,
         .leftSquareBracket, .rightSquareBracket:
      output = Token(token.text, tokenType: .operatorsAndPunctuation, position: position)
    case .identifier(_):
      output = Token(token.text,
                     tokenType: .identifier,
                     position: position)
    case .eof:
      return nil
    default:
      break
    }
    
    if let previousTokenKind = previousToken?.tokenKind {
      let hasUppercaseFirstChar = output?.string.first?.isUppercase == true
      
      switch output?.tokenType {
      case .identifier?:
        switch previousTokenKind {
        case .importKeyword:
          output = Token(token.text, tokenType: .importName, position: position)
        case .classKeyword where hasUppercaseFirstChar,
             .enumKeyword where hasUppercaseFirstChar,
             .structKeyword where hasUppercaseFirstChar,
             .protocolKeyword where hasUppercaseFirstChar,
             .isKeyword where hasUppercaseFirstChar,
             .asKeyword where hasUppercaseFirstChar,
             .period where hasUppercaseFirstChar,
             .comma where hasUppercaseFirstChar,
             .equal where hasUppercaseFirstChar,
             .colon,
             .typealiasKeyword,
             .leftSquareBracket where hasUppercaseFirstChar:
          output = Token(token.text, tokenType: .className, position: position)
        case .funcKeyword:
          output = Token(token.text, tokenType: .functionName, position: position)
          //        case .atSign:
        //          output = AttributeNameToken(token.text)
        default:
          break
        }
      default:
        break
      }
    }
    
    //    if let text = output?.text,
    //      output is NameToken,
    //      token.leadingTrivia.containsBackticks,
    //      token.trailingTrivia.containsBackticks {
    //      output?.text = "`\(text)`"
    //    }
    
    return output
  }
  
  ///
  /// Converts some syntax Trivia into an array of Tokens.
  ///
  private func highlightedTokens(for trivia: Trivia, position: Position) -> [Token] {
    return trivia.compactMap { piece in
      highlightedToken(for: piece, position: Position(start: position.end + trivia.startIndex,
                                                      end: position.end + trivia.endIndex))
    }
  }
  
  ///
  /// Converts a TriviaPiece into a token.
  ///
  private func highlightedToken(for piece: TriviaPiece, position: Position) -> Token? {
    
    switch piece {
    case .spaces(let count):
      return Token(String(repeating: " ", count: count), tokenType: .unknown, position: position)
    case .tabs(let count):
      return Token(String(repeating: "\t", count: count), tokenType: .unknown, position: position)
    case .verticalTabs(let count):
      return Token(String(repeating: "\u{11}", count: count), tokenType: .unknown, position: position)
    case .formfeeds(let count):
      return Token(String(repeating: "\u{12}", count: count), tokenType: .unknown, position: position)
    case .newlines(let count):
      return Token(String(repeating: "\n", count: count), tokenType: .newLine, position: position)
    case .carriageReturns(let count):
      return Token(String(repeating: "\r", count: count), tokenType: .newLine, position: position)
    case .carriageReturnLineFeeds(let count):
      return Token(String(repeating: "\r\n", count: count), tokenType: .newLine, position: position)
    case .backticks:
      return nil
    case .lineComment(let text),
         .docLineComment(let text):
      return Token(text, tokenType: .lineComment, position: position)
    case .blockComment(let text),
         .docBlockComment(let text):
      return Token(text, tokenType: .blockComment, position: position)
    case .garbageText:
      return nil
    }
  }
}
