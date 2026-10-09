enum ActionResult { viewHand, newTurn, drewCard, passTurn, invalid, gameOver }

sealed class PlayerAction {}

class NoAction extends PlayerAction {}

class PassAction extends PlayerAction {}

class ViewHandAction extends PlayerAction {}

class PlayCardAction extends PlayerAction {
  PlayCardAction(this.cardNumber);

  final int cardNumber;
}
