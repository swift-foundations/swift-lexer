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

import Lexer
import Testing

@Suite("Lexer.tokenize")
struct LexerTokenizeTests {

    // MARK: - Helpers

    private func tokenize(_ string: String) -> Lexer.Tokenized {
        let bytes: [Byte] = Array(string.utf8).map(Byte.init)
        return bytes.withUnsafeBufferPointer { buffer in
            let span = unsafe Span(
                _unsafeStart: buffer.baseAddress!,
                count: buffer.count
            )
            return Lexer.tokenize(span)
        }
    }

    // MARK: - Round-Trip

    @Test func `Empty Source`() {
        let result = tokenize("")
        #expect(result.lexemes.count == 1)
        #expect(result.lexemes.last?.kind == .endOfFile)
        #expect(result.diagnostics.isEmpty)
    }

    @Test func `Simple Declaration`() {
        let result = tokenize("let x = 42")
        let kinds = result.lexemes.map(\.kind)
        #expect(
            kinds == [
                .keyword(.let),
                .identifier,
                .equal,
                .integerLiteral,
                .endOfFile,
            ]
        )
        #expect(result.diagnostics.isEmpty)
    }

    @Test func `Struct Definition`() {
        let result = tokenize("struct Foo {}")
        let kinds = result.lexemes.map(\.kind)
        #expect(
            kinds == [
                .keyword(.struct),
                .identifier,
                .leftBrace,
                .rightBrace,
                .endOfFile,
            ]
        )
    }

    @Test func `Function With Arrow`() {
        let result = tokenize("func f() -> Int { return 0 }")
        let kinds = result.lexemes.map(\.kind)
        #expect(
            kinds == [
                .keyword(.func),
                .identifier,
                .leftParen,
                .rightParen,
                .arrow,
                .identifier,  // "Int"
                .leftBrace,
                .keyword(.return),
                .integerLiteral,
                .rightBrace,
                .endOfFile,
            ]
        )
    }

    @Test func `Diagnostics Present`() {
        let result = tokenize("/* unterminated")
        #expect(result.diagnostics.count == 1)
    }

    @Test func `Result Is Sendable`() {
        let result = tokenize("let x = 1")
        // Lexer.Tokenized is Sendable — this compiles without warnings.
        let _: any Sendable = result
        #expect(result.lexemes.count == 5)
    }
}
