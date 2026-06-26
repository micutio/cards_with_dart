import 'package:cards_with_dart/action.dart';

/// General interface for player input.
abstract class Input {
  PlayerAction getPlayerAction();
}
