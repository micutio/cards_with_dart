enum ActionResult { viewHand, newTurn, drewCard, passTurn, invalid, gameOver }

sealed class PlayerAction {
  const PlayerAction();
}

class NoAction extends PlayerAction {
  const NoAction();
}

class PassAction extends PlayerAction {
  const PassAction();
}

class ViewHandAction extends PlayerAction {
  const ViewHandAction();
}

class PlayCardAction extends PlayerAction {
  const PlayCardAction(this.cardNumber);

  final int cardNumber;
}
