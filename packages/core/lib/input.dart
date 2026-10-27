import 'action.dart';

/// General interface for player input.
abstract class Input {
  PlayerAction getPlayerAction();
}

/// Default non-interactive [Input] implementation returning [NoAction].
class NoOpInput extends Input {
  @override
  PlayerAction getPlayerAction() => const NoAction();
}
