import 'package:cards_with_dart/player.dart';

/// The engine of the game, handles the game loop
class Game {
  // === Main method for running the game. ===

  /// Runs the game in its entirety.
  void run() {}

  // === Methods for setting up the game. ===

  /// Initialize the players, such as setting up input loops, loading decks etc.
  void setUpPlayers() {}

  /// Initialize the board state.
  void setUpBoard() {}

  // === Methods for advancing the game. ===

  /// Run actions to be performed at the start of the turn, such as drawing cards.
  void startTurn() {}

  /// Queries player inputs for available actions and processes immediate effects.
  void takeTurn(Player player) {}

  /// Conclude the turn by valuating and applying all effects
  void resolveTurn() {}
}
