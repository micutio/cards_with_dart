# cards_with_dart_web

The pure Dart web frontend for the Cards with Dart monorepo. It consumes `cards_with_dart_core` and compiles to a standalone static web bundle (`index.html`, `styles.css`, `main.dart.js`) using `package:web` and `dart compile js`.

---

## Local Development & Execution

```bash
# Run web controller unit tests
dart test

# Build the production static web bundle into build/web/
dart run tool/build_web.dart
```
