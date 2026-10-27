import 'dart:js_interop';

import 'package:cards_with_dart_web/cards_with_dart_web.dart';
import 'package:web/web.dart' as web;

void main() {
  final controller = WebGameController();

  final deckCountEl =
      web.document.querySelector('#deck-count') as web.HTMLElement?;
  final handCountEl =
      web.document.querySelector('#hand-count') as web.HTMLElement?;
  final statusBannerEl =
      web.document.querySelector('#status-banner') as web.HTMLElement?;
  final passBtn =
      web.document.querySelector('#pass-btn') as web.HTMLButtonElement?;
  final resetBtn =
      web.document.querySelector('#reset-btn') as web.HTMLButtonElement?;
  final handContainer =
      web.document.querySelector('#hand-container') as web.HTMLElement?;
  final logList =
      web.document.querySelector('#log-list') as web.HTMLUListElement?;

  void renderUi() {
    if (deckCountEl != null) {
      deckCountEl.textContent = 'Deck: ${controller.deckRemaining}';
    }
    if (handCountEl != null) {
      handCountEl.textContent =
          'Hand: ${controller.handSize}/${controller.maxHandSize}';
    }

    if (statusBannerEl != null) {
      if (controller.isGameRunning) {
        statusBannerEl
          ..className = 'status-banner hidden'
          ..textContent = '';
      } else {
        final won = controller.isGameWon;
        statusBannerEl
          ..className = 'status-banner ${won ? "win" : "lose"}'
          ..textContent = won ? 'Victory! You won!' : 'Defeat! You lost!';
      }
    }

    if (passBtn != null) {
      passBtn.disabled = !controller.isGameRunning;
    }

    if (handContainer != null) {
      handContainer.textContent = '';
      final cards = controller.handCards;
      for (var i = 0; i < cards.length; i++) {
        final card = cards[i];
        final cardIndex = i;

        final tile = web.document.createElement('div') as web.HTMLDivElement
          ..className = 'card-tile';

        final title = web.document.createElement('div') as web.HTMLDivElement
          ..className = 'card-title'
          ..textContent = card.name;

        final effect = web.document.createElement('div') as web.HTMLDivElement
          ..className = 'card-effect'
          ..textContent = 'Effect: ${card.effect.name}';

        final playBtn =
            web.document.createElement('button') as web.HTMLButtonElement
              ..type = 'button'
              ..textContent = 'Play Card'
              ..disabled = !controller.isGameRunning
              ..onclick = ((web.Event _) {
                controller.playCard(cardIndex);
                renderUi();
              }).toJS;

        tile
          ..appendChild(title)
          ..appendChild(effect)
          ..appendChild(playBtn);
        handContainer.appendChild(tile);
      }
    }

    if (logList != null) {
      logList.textContent = '';
      for (final message in controller.logMessages.reversed) {
        final li = web.document.createElement('li') as web.HTMLLIElement
          ..textContent = message;
        logList.appendChild(li);
      }
    }
  }

  passBtn?.onclick = ((web.Event _) {
    controller.passTurn();
    renderUi();
  }).toJS;

  resetBtn?.onclick = ((web.Event _) {
    controller.reset();
    renderUi();
  }).toJS;

  renderUi();
}
