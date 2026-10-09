import 'effect.dart';

/// Represents a single card.
class Card {
  /// Generative constructor to initialise name and effect.
  Card(this.name, this.effect);

  final String name;
  final Effect effect;

  @override
  int get hashCode => name.hashCode ^ effect.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Card &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          effect == other.effect;

  @override
  String toString() => 'card [$name] with effect: [${effect.name}]';
}
