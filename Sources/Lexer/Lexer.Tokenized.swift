extension Lexer {

    public struct Tokenized: Sendable, Equatable {

        public let lexemes: [Lexer.Lexeme]

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
