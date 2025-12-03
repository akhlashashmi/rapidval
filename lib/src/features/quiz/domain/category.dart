enum QuizCategory {
  history,
  it,
  science,
  arts,
  business,
  geography,
  mathematics,
  generalKnowledge;

  String get displayName {
    switch (this) {
      case QuizCategory.history:
        return 'History';
      case QuizCategory.it:
        return 'Technology & IT';
      case QuizCategory.science:
        return 'Science';
      case QuizCategory.arts:
        return 'Arts & Literature';
      case QuizCategory.business:
        return 'Business & Finance';
      case QuizCategory.geography:
        return 'Geography';
      case QuizCategory.mathematics:
        return 'Mathematics';
      case QuizCategory.generalKnowledge:
        return 'General Knowledge';
    }
  }
}
