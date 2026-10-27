# Cards with Dart

A multiplatform card game 

## Development Tasks Runner (`tool/dev.dart`)

To avoid OS differences with `make`, a cross-platform Dart runner script is available at `tool/dev.dart`:

```bash
# Show all available commands
dart run tool/dev.dart help

# Formatting & static analysis
dart run tool/dev.dart format           # Format all packages
dart run tool/dev.dart format --check   # Check formatting without modifying
dart run tool/dev.dart analyze          # Analyze with --fatal-infos
dart run tool/dev.dart fix              # Apply automated fixes
dart run tool/dev.dart fix --check      # Dry-run check for fixes

# Testing
dart run tool/dev.dart test             # Run all tests (core, cli, web, app)
dart run tool/dev.dart test:core        # Run core tests only
dart run tool/dev.dart test:cli         # Run CLI tests only
dart run tool/dev.dart test:web         # Run web tests only
dart run tool/dev.dart test:app         # Run Flutter app tests only

# Building & Smoke Testing
dart run tool/dev.dart build:cli        # Compile native CLI bundle
dart run tool/dev.dart smoke:cli        # Smoke test compiled CLI binary
dart run tool/dev.dart build:web        # Compile static web bundle
dart run tool/dev.dart build:app        # Build Android debug APK

# Full Local CI Verification Suite (format, analyze, fix, test, build, smoke)
dart run tool/dev.dart verify
```

---

## Development Setup

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 
- Git

### Getting Started

1. **Install dependencies across all workspaces:**
   ```bash
   flutter pub get
   ```

2. **Verify workspace membership:**
   ```bash
   dart pub workspace list
   ```

3. **Check formatting and linting:**
   ```bash
   dart format --output=none --set-exit-if-changed .
   dart analyze --fatal-infos
   dart fix --dry-run
   ```

4. **Run all tests:**
   ```bash
   # Core, CLI, & Web tests
   dart test packages/core
   dart test packages/cli
   dart test packages/web

   # Flutter app tests
   flutter test packages/app
   ```

5. **Build and smoke test the native CLI:**
   ```bash
   cd packages/cli
   dart build cli
   dart run tool/smoke_cli.dart
   cd ../..
   ```

6. **Build the static Web bundle:**
   ```bash
   cd packages/web
   dart run tool/build_web.dart
   cd ../..
   ```

7. **Run the Flutter Android app (with an emulator or device connected):**
   ```bash
   cd packages/app
   flutter run
   ```

---

## CI/CD Pipeline

- **Main CI (`.github/workflows/dart.yml`)**:
  - `format`: Verifies code formatting across all packages.
  - `analyze`: Runs static analysis with fatal infos.
  - `fix`: Asserts that `dart fix --dry-run` reports no pending automated fixes.
  - `test`: Multi-OS test matrix (`ubuntu-latest`, `windows-latest`, `macos-latest`) with Linux coverage collection.
  - `build-cli`: Multi-OS native CLI compilation and smoke testing.
  - `build-web`: Compiles static web bundle (`dart compile js`) and uploads artifact.
  - `build-android`: Compiles Android debug APK and uploads artifact.
- **Beta Check (`.github/workflows/dart-beta.yml`)**: Weekly non-blocking sanity check against the beta SDK channel.
- **Release (`.github/workflows/release.yml`)**:
  - Triggered on tag `v*.*.*` or manual dispatch.
  - Validates matching `pubspec.yaml` version and `CHANGELOG.md` entry.
  - Builds Linux x64, macOS ARM64, and Windows x64 CLI binaries packaged in `.tar.gz` and `.zip`.
  - Builds static web bundle packaged in `.tar.gz` and `.zip`.
  - Builds Android release APK.
  - Generates `SHA256SUMS` and publishes draft GitHub Release with release notes.
- **Dependabot (`.github/dependabot.yml`)**: Weekly dependency update checks for Pub packages and GitHub Actions.
