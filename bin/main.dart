import 'package:cards_with_dart/game.dart';

/// The main method.
/// All logic is in the [Game] class, keeping this nice and tidy.
void main(List<String> arguments) {
  final game = Game();
  game.setUp();
  game.run();
}
