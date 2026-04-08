# Audit: swift-lexer

## Code Surface — 2026-04-08

### Scope

- **Target**: swift-lexer (foundation layer)
- **Skill**: code-surface — [API-NAME-001], [API-NAME-002], [API-ERR-001], [API-IMPL-005], [API-IMPL-006], [API-IMPL-007], [API-IMPL-008]
- **Files**: 3 source files

### Findings

| # | Severity | Rule | Location | Finding | Status |
|---|----------|------|----------|---------|--------|
| — | — | — | — | No violations found | — |

### Summary

0 findings. `Lexer.Tokenized` follows Nest.Name. File naming matches nested type path. Type body contains only stored properties and canonical init. `Lexer+Tokenize.swift` is a correctly-named extension file.

---

## Implementation — 2026-04-08

### Scope

- **Target**: swift-lexer (foundation layer)
- **Skill**: implementation — [IMPL-INTENT], [IMPL-002], [IMPL-060], [IMPL-064], [IMPL-EXPR-001]
- **Files**: 3 source files

### Findings

| # | Severity | Rule | Location | Finding | Status |
|---|----------|------|----------|---------|--------|
| — | — | — | — | No violations found | — |

### Summary

0 findings. `Lexer.tokenize` reads as intent: create scanner, drain to arrays, return result. Uses ecosystem types (`Lexer.Scanner`, `Lexer.Lexeme`, `Lexer.Error`) throughout per [IMPL-060]. `Lexer.Tokenized` is Copyable — justified: stored in stdlib collections, value-semantic, Sendable result type per [IMPL-064] exemption.
