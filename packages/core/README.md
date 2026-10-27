# cards_with_dart_core

The shared core domain library for the Cards with Dart monorepo. It contains pure Dart card game domain logic, entities, actions, and renderer/input interfaces with zero dependencies on Flutter, `dart:io`, or browser APIs.

---

## Domain Overview

- **`Card` & `Effect`**: Immutable card representation with a title and `Effect` (`winGame`, `loseGame`, `none`).
- **`Deck`, `Hand`, `Library`**: Card collection management for drawing, shuffling, holding cards up to a maximum hand size, and organizing available card sets.
- **`Player` & `PlayerAction`**: Player state and sealed action hierarchy (`PlayCardAction`, `PassAction`, `ViewHandAction`, `NoAction`).
- **`Game`, `Renderer`, `Input`**: Platform-agnostic game engine supporting both synchronous loop execution (`loop()`, used by CLI) and event-driven turn progression (`startInteractive()` / `handleAction()`, used by Flutter and Web frontends).
