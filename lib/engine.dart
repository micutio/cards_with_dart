import 'package:cards_with_dart/game.dart';
import 'package:cards_with_dart/player.dart';

/// Engine which sets up and runs the [Game].
class Engine {
  final Game game;

  Engine(this.game);

  /// Set up the [Game].
  void setUp() {}

  /// Run the [Game].
  void gameLoop() {
    render();
    processInput();
    advanceGame();
  }

  /// Render the board and player(s) state.
  void render() {}

  /// Check the [Player]s for input and turn it into executable actions.
  void processInput() {}

  /// Advance the [Game] by starting/ending turns and resolving effects.
  void advanceGame() {}
}
