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

extension Lexer {
    /// Tokenizes a span of UTF-8 source bytes, producing an owned
    /// ``Lexer/Tokenized`` result.
    ///
    /// This is the primary entry point for batch lexing. It creates a
    /// ``Lexer/Scanner``, drains it to completion, and returns the
    /// materialized lexeme sequence with any diagnostics.
    ///
    /// ```swift
    /// let source: [UInt8] = Array("let x = 42".utf8)
    /// let result = source.withUnsafeBufferPointer { buffer in
    ///     Lexer.tokenize(Span(buffer))
    /// }
    /// for lexeme in result.lexemes { ... }
    /// ```
    ///
    /// - Parameter source: UTF-8 encoded source bytes.
    /// - Returns: The tokenized result containing lexemes and diagnostics.
    @inlinable
    public static func tokenize(
        _ source: Span<UInt8>
    ) -> Lexer.Tokenized {
        var scanner = Lexer.Scanner(source)
        var lexemes: [Lexer.Lexeme] = []
        var diagnostics: [Lexer.Error] = []

        while let lexeme = scanner.next(diagnostics: &diagnostics) {
            lexemes.append(lexeme)
        }

        return Lexer.Tokenized(
            lexemes: lexemes,
            diagnostics: diagnostics
        )
    }
}
