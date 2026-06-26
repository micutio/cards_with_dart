import 'dart:collection';

import 'package:cards_with_dart/action.dart';
import 'package:cards_with_dart/card_mgmt.dart';
import 'package:cards_with_dart/player.dart';
import 'package:cards_with_dart/renderer.dart';
import 'package:cards_with_dart/src/input/stdin_input.dart';

class Game {
  static const int _deckSize = 10;
  static const int _handSize = 4;

  final Renderer _renderer;
  final Player _player;
  final Queue<String> _log = Queue<String>();

  String? choice;
  bool _isGameWon = false;
  bool _isGameRunning = true;
  bool _isNewTurn = true;

  // TODO: Construct player class outside of this one!

  /// Constructor. Takes generic [Renderer] to visualise the game.
  Game(Renderer renderer)
    : _renderer = renderer,
      _player = Player('Player', _deckSize, _handSize, StdinInput());

  /// Initialize necessary fields and get the [Game] ready to play.
  void setUp() {
    // Create a library with a set of unique cards
    final library = Library();
    library.cards.addAll({
      Card("Overpowered!", Effect.winGame),
      Card("Sleep", Effect.none),
      Card("Skip", Effect.none),
      Card("Eternal Fail", Effect.loseGame),
    });

    // Create a deck with max size 10 and add each card twice.
    // `...` is the spread operator, which unpacks the little 2-card list
    // into the bigger list.
    _player.deck.addCards([
      for (var card in library.cards) ...[card, card],
    ]);
    _player.deck.shuffle();
    _player.setUpHand();
  }

  /// Runs the game loop until the [Game] ends.
  void loop() {
    _renderer.renderMessage('Cards with Dart');
    var actionResult = ActionResult.drewCard;

    // Run the loop until the player has either won or lost.
    while (_isGameRunning) {
      // Step 1: Render the state of the game including the results
      //         of last turn's actions.
      _render(actionResult);

      // Step 2: Check whether the player has made any new input.
      // TODO: Ideally this would manipulate the board state by moving cards between regions etc.
      _processInput();

      // Step 3: Advance the game and keep track of important actions.
      // TODO: Ideally this would resolve the new board state by applying effects etc.
      actionResult = _advanceGame(actionResult);
    }
  }

  /// Render the board and player state according to the given [ActionResult]
  /// from the last turn.
  void _render(ActionResult actionResult) {
    while (_log.isNotEmpty) {
      _renderer.renderMessage(_log.removeFirst());
    }

    switch (actionResult) {
      case ActionResult.viewHand:
        _renderer.renderHand(_player.hand);
        return;
      case ActionResult.newTurn:
        _renderer.renderMessage(
          'Choose a card `#`, view your `hand` or `pass` the turn: ',
        );
        return;
      case ActionResult.drewCard:
        final lastCardIdx = _player.hand.size - 1;
        _renderer.renderMessage('You draw ${_player.hand.cards[lastCardIdx]}');
        return;
      case ActionResult.gameOver:
        _renderer.renderGameOver(_isGameWon);
        return;
      case _:
        return;
    }
  }

  /// Check the [Player] (s) for input and turn in into executable actions.
  void _processInput() {
    // We still have a player choice from a previous check, skip this check.
    if (_isNewTurn || _player.hasAction()) return;

    _player.pollAction();
  }

  /// Advance the [Game] by starting/ending turns and resolving effects.
  ActionResult _advanceGame(ActionResult actionResult) {
    // Check for new turn.
    if (_isNewTurn) {
      // If we can draw a card, do that first,
      // otherwise prompt for user input.
      if (actionResult != ActionResult.drewCard && !_player.hand.isFull) {
        // Add a card from the deck, if possible.
        _player.drawCard();
        return ActionResult.drewCard;
      }
      _isNewTurn = false;
      return ActionResult.newTurn;
    }

    // Process the player's choice.
    // Assigning it to a new variable so we can immediately clear the field.
    switch (_player.consumeAction()) {
      case NoAction():
        return ActionResult.invalid;
      case PassAction():
        _isNewTurn = true;
        return ActionResult.passTurn;
      case ViewHandAction():
        return ActionResult.viewHand;
      case PlayCardAction(:final cardNumber):
        final card = _player.hand.playCardAt(cardNumber);
        _log.add('You play $card');
        // TODO: This manipulates board state.
        //       Move applying the card effect into a new method about resolving board state.
        switch (card.effect) {
          case Effect.none:
            _log.add('The card has no effect!');
            _isNewTurn = true;
            return ActionResult.passTurn;
          case Effect.winGame:
            _isGameRunning = false;
            _isGameWon = true;
            return ActionResult.gameOver;
          case Effect.loseGame:
            _isGameRunning = false;
            _isGameWon = false;
            return ActionResult.gameOver;
        }
    }
  }
}
