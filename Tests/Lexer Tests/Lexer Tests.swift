// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-lexer open source project
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp and the swift-lexer project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

import Testing
import Lexer

@Suite("Lexer.tokenize")
struct LexerTokenizeTests {

    // MARK: - Helpers

    private func tokenize(_ string: String) -> Lexer.Tokenized {
        var string = string
        return string.withUTF8 { utf8 in
            let span = unsafe Span(
                _unsafeStart: utf8.baseAddress!,
                count: utf8.count
            )
            return Lexer.tokenize(span)
        }
    }

    // MARK: - Round-Trip

    @Test func emptySource() {
        let result = tokenize("")
        #expect(result.lexemes.count == 1)
        #expect(result.lexemes.last?.kind == .endOfFile)
        #expect(result.diagnostics.isEmpty)
    }

    @Test func simpleDeclaration() {
        let result = tokenize("let x = 42")
        let kinds = result.lexemes.map(\.kind)
        #expect(kinds == [
            .keyword(.let),
            .identifier,
            .equal,
            .integerLiteral,
            .endOfFile
        ])
        #expect(result.diagnostics.isEmpty)
    }

    @Test func structDefinition() {
        let result = tokenize("struct Foo {}")
        let kinds = result.lexemes.map(\.kind)
        #expect(kinds == [
            .keyword(.struct),
            .identifier,
            .leftBrace,
            .rightBrace,
            .endOfFile
        ])
    }

    @Test func functionWithArrow() {
        let result = tokenize("func f() -> Int { return 0 }")
        let kinds = result.lexemes.map(\.kind)
        #expect(kinds == [
            .keyword(.func),
            .identifier,
            .leftParen,
            .rightParen,
            .arrow,
            .identifier, // "Int"
            .leftBrace,
            .keyword(.return),
            .integerLiteral,
            .rightBrace,
            .endOfFile
        ])
    }

    @Test func diagnosticsPresent() {
        let result = tokenize("/* unterminated")
        #expect(result.diagnostics.count == 1)
    }

    @Test func resultIsSendable() {
        let result = tokenize("let x = 1")
        // Lexer.Tokenized is Sendable — this compiles without warnings.
        let _: any Sendable = result
        #expect(result.lexemes.count == 5)
    }
}
