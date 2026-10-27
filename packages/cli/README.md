# cards_with_dart_cli

The command-line interface frontend for the Cards with Dart monorepo. It consumes `cards_with_dart_core` and compiles to native AOT binaries across Linux, macOS, and Windows.

---

## Local Development & Execution

```bash
# Run directly from source
dart run bin/cards_with_dart.dart
dart run bin/cards_with_dart.dart --help
dart run bin/cards_with_dart.dart --version

# Run CLI tests
dart test

# Compile to a native AOT binary
dart build cli

# Smoke test the compiled native binary
dart run tool/smoke_cli.dart
```
