import 'dart:math';

class RandomQuotes {
  static final List<String> foodSharingQuotes = [
    'Sharing food is sharing love.',
    'A shared meal is a shared joy.',
    'Food is better when shared with friends.',
    'The more you share, the more you have.',
  ];

  static String getRandomFoodSharingQuote() {
    final Random random = Random();
    return foodSharingQuotes[random.nextInt(foodSharingQuotes.length)];
  }
}
