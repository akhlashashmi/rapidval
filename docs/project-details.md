# RapidVal - AI-Powered Quiz Generator

**Version:** 1.0.0
**Last Updated:** December 4, 2025

## 1. Project Overview

**RapidVal** is a premium, AI-powered Flutter application designed to revolutionize how users learn and test their knowledge. Leveraging Google's Gemini AI, the app generates interactive, personalized quizzes on *any* topic instantly. It combines a sleek, modern "glassmorphism" design with robust local persistence and enterprise-grade architecture.

The application prioritizes a seamless user experience, featuring smooth animations, perfect shimmer loading states, and intuitive navigation.

## 2. Key Features

### 🧠 AI Quiz Generation

- **Topic-Agnostic**: Users can input any subject (e.g., "Flutter Riverpod", "Ancient Rome", "Organic Chemistry") to generate a unique quiz.
- **Customizable Configuration**:
  - **Difficulty Levels**: Beginner, Intermediate, Advanced.
  - **Question Count**: Adjustable from 3 to 20 questions.
  - **Time Limits**: Set time per question (5s to 60s).
- **Streamed Generation**: Real-time feedback during quiz creation using AI streaming.

### 🎮 Interactive Quiz Experience

- **Timed Questions**: Countdown timer for each question to simulate exam pressure.
- **Rich Content**: Support for Markdown in questions and explanations (code blocks, bold text, lists).
- **Review Mode**: Comprehensive review system to analyze answers and read detailed AI-generated explanations.
- **Resume Capability**: Active quiz state is saved, allowing users to drop off and resume exactly where they left off.

### 📊 Dashboard & History

- **Smart Dashboard**:
  - Displays key statistics (Total Quizzes, Avg. Score, Best Topic).
  - Shows active quiz progress for quick resumption.
  - Lists popular/recent quizzes.
- **Advanced History**:
  - **Search**: Full-text search across quiz titles and categories.
  - **Filtering**: Filter history by Difficulty (Beginner, Intermediate, Advanced) and Categories.
  - **Compact UI**: A custom-built, animated filter bar with integrated search and filter chips.

### ⚡ Performance & UX

- **Perfect Shimmer**: Custom-built shimmer loading states that exactly match the layout of the Dashboard and History screens, ensuring zero layout shift when data loads.
- **Data Preloading**: A `bootstrap` process warms up critical data providers (stats, history, active quiz) before the app starts, ensuring instant content availability.
- **Animated UI**: Extensive use of `flutter_animate` for entrance animations and `AnimatedBuilder` for complex interactions (e.g., expanding search bar).

### 🔐 Authentication & Data

- **Firebase Auth**: Secure email/password authentication.
- **Local-First Data**: All quizzes, questions, results, and progress are stored locally using **Drift (SQLite)**, making the app fully functional offline (for reviewing past content).

## 3. Technology Stack

### Core Framework

- **Flutter**: UI Toolkit (SDK > 3.10.1).
- **Dart**: Programming language.

### State Management & Architecture

- **Flutter Riverpod**: For robust, compile-safe state management and dependency injection.
- **Riverpod Generator**: For reducing boilerplate code.
- **Feature-First Architecture**: Codebase organized by features (`auth`, `dashboard`, `quiz`, `history`) for scalability.

### Backend & Services

- **Google Gemini AI**: Powered by `firebase_ai` for generating intelligent quiz content.
- **Firebase Authentication**: For user identity management.
- **Firebase Core**: Initialization and configuration.

### Local Data Persistence

- **Drift**: A reactive persistence library for SQLite.
  - **Tables**: `Quizzes`, `Questions`, `QuizResults`, `UserPreferences`, `QuizProgress`.
  - **Type Converters**: JSON serialization for complex objects (lists of strings, user answers).
- **Hive**: Key-value storage for simple local settings.

### UI/UX Libraries

- **Flutter Animate**: For declarative, chainable animations.
- **GoRouter**: For declarative routing and deep linking.
- **Google Fonts**: Typography (Inter font family).
- **Flutter Markdown**: Rendering rich text content.

## 4. Architecture & Folder Structure

The project follows a strict **Feature-First** directory structure:

```
lib/
├── src/
│   ├── auth/                 # Authentication (Login, Register, Auth State)
│   ├── core/                 # Shared utilities & services
│   │   ├── bootstrap.dart    # App initialization & data warming
│   │   ├── database/         # Drift database setup & tables
│   │   ├── services/         # External services (Gemini, LocalStorage)
│   │   └── widgets/          # Shared UI components (CustomAppBar, Buttons)
│   ├── features/
│   │   ├── dashboard/        # Dashboard UI, Stats, Shimmer
│   │   ├── history/          # History List, Search/Filter Logic, Shimmer
│   │   ├── home/             # Main Shell (BottomNav, PageView)
│   │   ├── quiz/             # Quiz Logic, Repository, UI (Play/Result)
│   │   └── settings/         # User Settings
│   └── app.dart              # App Widget & Theme Config
└── main.dart                 # Entry point
```

## 5. Data Flow

1. **Bootstrap**: On app launch, `bootstrap()` initializes Firebase, Hive, and pre-fetches Dashboard stats and History data from Drift.
2. **User Input**: User configures a quiz on the `CreateQuizScreen`.
3. **AI Generation**: `QuizRepository` calls `GeminiService`.
4. **Persistence**: The generated `Quiz` is saved to Drift (`AppDatabase`).
5. **Quiz Session**: `QuizController` updates `QuizProgress` in Drift after every answer, ensuring no data loss.
6. **Completion**: `QuizResult` is calculated and saved to `QuizResults` table.
7. **Updates**: `DashboardScreen` and `HistoryScreen` listen to Drift streams via Riverpod to auto-update the UI.

## 6. Documentation & Assets

- **Legal**: Terms of Service and Privacy Policy are available in `docs/`.
- **Landing Page**: A professional marketing landing page is located in `landing_page/index.html`.

## 7. Future Roadmap

- [ ] **Leaderboards**: Global rankings based on quiz scores.
- [ ] **Spaced Repetition**: AI-suggested review of weak topics.
- [ ] **Export Results**: Share quiz results as PDF or images.
- [ ] **Multiplayer Mode**: Challenge friends to the same quiz.
