# swift-lexer

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Batch tokenization of UTF-8 source bytes: one `Lexer.tokenize` call drains a borrowing scanner into trivia-preserving lexemes plus typed diagnostics — malformed input never throws.

swift-lexer is the batch-mode surface over [swift-lexer-primitives](https://github.com/swift-primitives/swift-lexer-primitives): it adds the `Lexer.tokenize(_:)` entry point and the owned `Lexer.Tokenized` result, and re-exports the underlying scanner, token vocabulary, pull-mode machinery, and diagnostic records so a single `import Lexer` covers the full lexing surface. The bundled scanner recognizes a Swift-flavored token vocabulary (keywords, punctuation, operators, and literals).

---

## Quick Start

```swift
import Lexer

let source: [UInt8] = Array("func greet() -> Int { return 42 }".utf8)
let result = Lexer.tokenize(source.span)

for lexeme in result.lexemes {
    print(lexeme.kind)   // .keyword(.func), .identifier, .leftParen, ...
}
```

The lexer always makes progress. Malformed input produces diagnostics as values alongside a complete lexeme stream — there is no thrown error to interrupt scanning, so a single pass yields everything an editor or parser needs:

```swift
import Lexer

let broken: [UInt8] = Array("/* unterminated".utf8)
let tokenized = Lexer.tokenize(broken.span)

print(tokenized.diagnostics)      // [.unterminatedBlockComment(at: ...)]
print(tokenized.lexemes.count)    // still a full stream, ending in .endOfFile
```

---

## Installation

Add swift-lexer to your Package.swift (pre-release — no tags are published yet, so pin to `main`):

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-lexer.git", branch: "main")
]
```

Add to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Lexer", package: "swift-lexer")
    ]
)
```

### Requirements

- Swift 6.3+ toolchain
- macOS 26.0+, iOS 26.0+, tvOS 26.0+, watchOS 26.0+, visionOS 26.0+

---

## Key Types

| Type | Purpose |
|------|---------|
| `Lexer.tokenize(_:)` | Batch entry point — scans a `Span<UInt8>` to completion and returns an owned result |
| `Lexer.Tokenized` | Owned result: `lexemes` in source order plus `diagnostics` |
| `Lexer.Scanner` | Incremental `~Copyable`, `~Escapable` scanner for lexeme-at-a-time consumption (re-exported) |
| `Lexer.Lexeme` | Token kind, token byte range, and leading/trailing trivia lengths (re-exported) |
| `Lexer.Pull` | Pull-mode structural-event machinery for building format-specific lexers (re-exported) |
| `Diagnostic.Record` | Severity-graded diagnostic records (re-exported) |

Use `Lexer.tokenize` when you want the whole source materialized at once; drop down to the re-exported `Lexer.Scanner` when you want to consume lexemes one at a time without building an array.

---

## Diagnostics

Nothing in this package throws. Lexing errors surface as `Lexer.Error` values in `Tokenized.diagnostics`, each carrying the `Text.Position` where the condition was detected; the corresponding source bytes still appear in the lexeme stream (unrecognized input becomes `.unknown` lexemes).

```
Lexer.Error
├── .invalidCharacter(at: Text.Position)
├── .unterminatedBlockComment(at: Text.Position)
├── .unterminatedStringLiteral(at: Text.Position)
├── .invalidEscapeSequence(at: Text.Position)
└── .expectedDigitAfterPrefix(at: Text.Position)
```

---

## Related Packages

### Dependencies

- [swift-lexer-primitives](https://github.com/swift-primitives/swift-lexer-primitives) — Scanner, lexeme, token vocabulary, and pull-mode machinery re-exported by this package (pre-release; tracks `main`).
- [swift-diagnostic-primitives](https://github.com/swift-primitives/swift-diagnostic-primitives) — Severity-graded diagnostic records (pre-release; tracks `main`).

---

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public flip.*
<!-- END: discussion -->

---

## License

Apache 2.0. See [LICENSE](LICENSE.md).
