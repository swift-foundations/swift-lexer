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
    /// The materialized result of tokenizing a source buffer.
    ///
    /// Contains the complete lexeme sequence and any diagnostics produced
    /// during scanning. This is the owned output of ``Lexer/tokenize(_:)``
    /// — the ``Lexer/Scanner`` that produced it has been consumed.
    public struct Tokenized: Sendable, Equatable {
        /// The lexemes in source order, ending with ``Token/Kind-swift.enum/endOfFile``.
        public let lexemes: [Lexer.Lexeme]

        /// Diagnostics produced during scanning (e.g., unterminated comments).
        public let diagnostics: [Lexer.Error]

        @inlinable
        public init(
            lexemes: [Lexer.Lexeme],
            diagnostics: [Lexer.Error]
        ) {
            self.lexemes = lexemes
            self.diagnostics = diagnostics
        }
    }
}
