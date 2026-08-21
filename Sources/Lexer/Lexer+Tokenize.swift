extension Lexer {

    @inlinable
    public static func tokenize(
        _ source: Span<Byte>
    ) -> Lexer.Tokenized {
        var scanner = Self.Scanner(source)
        var lexemes: [Lexer.Lexeme] = []
        var diagnostics: [Lexer.Error] = []

        while let lexeme = scanner.next(diagnostics: &diagnostics) {
            lexemes.append(lexeme)
        }

        return Self.Tokenized(
            lexemes: lexemes,
            diagnostics: diagnostics
        )
    }
}
