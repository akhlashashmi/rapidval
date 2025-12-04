enum QuizCategory {
  technologyAndCoding,
  scienceAndNature,
  historyAndPolitics,
  artsAndLiterature,
  entertainmentAndPopCulture,
  geographyAndTravel,
  businessAndFinance,
  healthAndLifestyle,
  sportsAndRecreation,
  generalKnowledge;

  /// Returns the formatted display string (e.g. "Technology & Coding")
  String get displayName {
    switch (this) {
      case QuizCategory.technologyAndCoding:
        return 'Technology & Coding';
      case QuizCategory.scienceAndNature:
        return 'Science & Nature';
      case QuizCategory.historyAndPolitics:
        return 'History & Politics';
      case QuizCategory.artsAndLiterature:
        return 'Arts & Literature';
      case QuizCategory.entertainmentAndPopCulture:
        return 'Entertainment & Pop Culture';
      case QuizCategory.geographyAndTravel:
        return 'Geography & Travel';
      case QuizCategory.businessAndFinance:
        return 'Business & Finance';
      case QuizCategory.healthAndLifestyle:
        return 'Health & Lifestyle';
      case QuizCategory.sportsAndRecreation:
        return 'Sports & Recreation';
      case QuizCategory.generalKnowledge:
        return 'General Knowledge';
    }
  }

  /// Helper to get a comma-separated list of all display names for the AI prompt
  static String get allCategoriesPromptString {
    return values.map((e) => e.displayName).join(', ');
  }

  /// Helper to convert a string back to an Enum (optional, useful for parsing)
  static QuizCategory fromString(String label) {
    return QuizCategory.values.firstWhere(
      (e) => e.displayName.toLowerCase() == label.toLowerCase(),
      orElse: () => QuizCategory.generalKnowledge,
    );
  }
}
