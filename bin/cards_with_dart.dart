import 'package:cards_with_dart/game.dart';
import 'package:cards_with_dart/src/renderer/stdout_renderer.dart';

/// The main method.
/// All logic is in the [Game] class, keeping this nice and tidy.
void main(List<String> arguments) {
  // ignore: unused_local_variable // game contains side effect
  final game = Game(StdoutRenderer())
    ..setUp()
    ..loop();
}
