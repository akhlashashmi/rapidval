# RapidVal - AI-Powered Quiz Generator

## 1. Project Overview

**RapidVal** is a modern, AI-powered Flutter application designed to generate interactive quizzes on any topic instantly. Leveraging Google's Gemini AI, the app allows users to test their knowledge, learn new subjects, and track their progress through a sleek and professional user interface.

The application focuses on a premium user experience with smooth animations, glassmorphism effects, and intuitive navigation, making learning engaging and efficient.

## 2. Key Features

### 🧠 AI Quiz Generation

- **Dynamic Topic Selection**: Users can input any topic (e.g., "Flutter State Management", "World History", "Quantum Physics") to generate a unique quiz.
- **Customizable Configuration**:
  - **Difficulty Levels**: Beginner, Intermediate, Advanced.
  - **Question Count**: Adjustable from 3 to 20 questions.
  - **Time Limits**: Set time per question (5s to 60s).
- **Real-time Feedback**: Engaging "AI Thinking" simulation with visual progress indicators during generation.

### 🎮 Interactive Quiz Experience

- **Timed Questions**: Countdown timer for each question to simulate pressure.
- **Rich Content**: Support for Markdown in questions and explanations (code blocks, bold text, etc.).
- **Review Mode**: After completion, users can navigate back and forth to review their answers and read detailed explanations.
- **Instant Feedback**: Immediate visual cues for correct/incorrect answers during review.

### 📊 Progress & History (Local Storage)

- **Recent Activity**: Dashboard displays a list of recently completed quizzes.
- **Persistent Storage**: All generated quizzes and user results are saved locally using **Drift (SQLite)**.
- **Detailed Results**: View scores, percentages, and completion dates.

### 🔐 Authentication

- **Firebase Auth Integration**: Secure sign-in and account management.
- **Account Control**: Options to sign out or permanently delete account data.

## 3. Technology Stack

### Core Framework

- **Flutter**: UI Toolkit for building natively compiled applications.
- **Dart**: Programming language.

### State Management & Architecture

- **Flutter Riverpod**: For robust, compile-safe state management and dependency injection.
- **Riverpod Generator**: For reducing boilerplate code.
- **Feature-First Architecture**: Codebase organized by features (`auth`, `dashboard`, `quiz`) rather than layers.

### Backend & Services

- **Google Gemini AI**: Powered by `firebase_ai` for generating intelligent quiz content.
- **Firebase Authentication**: For user identity management.
- **Firebase Core**: Initialization and configuration.

### Local Data Persistence

- **Drift**: A reactive persistence library for SQLite, used for storing quizzes, questions, and results.
- **SQLite**: The underlying local database engine.

### UI/UX & Design

- **Flutter Animate**: For declarative and chainable animations (fade-ins, slides, scales).
- **GoRouter**: For declarative routing and deep linking.
- **Google Fonts**: For modern typography.
- **Flutter Markdown**: For rendering rich text content in quizzes.
- **Glassmorphism**: Extensive use of `BackdropFilter` and semi-transparent colors for a modern look.

## 4. Architecture & Folder Structure

The project follows a **Feature-First** directory structure:

```
lib/
├── src/
│   ├── auth/                 # Authentication feature
│   │   ├── data/            # Repositories & Data sources
│   │   └── presentation/    # UI Widgets & Controllers
│   ├── core/                 # Shared utilities & services
│   │   ├── database/        # Drift database setup & tables
│   │   └── services/        # External services (GeminiService)
│   ├── features/
│   │   ├── dashboard/       # Main dashboard & quiz config
│   │   └── quiz/            # Quiz playing & results logic
│   └── ...
└── main.dart                 # App entry point & initialization
```

## 5. Data Flow

1. **User Input**: User enters a topic and configures settings on the `DashboardScreen`.
2. **AI Generation**: `DashboardController` calls `QuizRepository`, which requests `GeminiService` to generate JSON content.
3. **Persistence**: The generated `Quiz` object is immediately saved to the local Drift database (`AppDatabase`).
4. **Quiz Session**: `QuizController` manages the active session (timer, current question, user answers).
5. **Completion**: Upon finishing, the `QuizResult` is calculated and saved to the database.
6. **History**: The `DashboardScreen` watches the `recentQuizResultsProvider` to display the updated list of taken quizzes from the database.

## 6. Future Roadmap

- [ ] **Leaderboards**: Global rankings based on quiz scores.
- [ ] **Spaced Repetition**: AI-suggested review of weak topics.
- [ ] **Export Results**: Share quiz results as PDF or images.
- [ ] **Multiplayer Mode**: Challenge friends to the same quiz.
