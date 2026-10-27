import 'card_mgmt.dart';

abstract class Renderer {
  void renderCard(Card card);
  void renderHand(Hand hand);
  void renderDeck(Deck deck);
  void renderMessage(String msg);
  void renderGameOver(bool won);
}
