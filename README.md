# RapidVal - AI-Powered Quiz Generator

**Version:** 1.1.0  
**Last Updated:** December 20, 2024

---

## 1. Project Overview

**RapidVal** is a premium, AI-powered Flutter application designed to revolutionize how users learn and test their knowledge. Leveraging Google's Gemini AI, the app generates interactive, personalized quizzes on *any* topic instantly. It combines a sleek, modern Material 3 Expressive design with robust local persistence and enterprise-grade architecture.

The application prioritizes a seamless user experience, featuring smooth animations, professional shimmer loading states, intuitive navigation, and consistent design language throughout.

### App Purpose

RapidVal serves as a personal learning companion that helps users:

- Test their knowledge on any subject instantly
- Track learning progress over time
- Review and learn from mistakes with AI-generated explanations
- Share achievements and quiz content with friends
- Maintain offline access to all quiz history

---

## 2. Key Features

### 🧠 AI Quiz Generation

- **Topic-Agnostic**: Input any subject (e.g., "Flutter Riverpod", "Ancient Rome", "Organic Chemistry") to generate unique quizzes
- **Customizable Configuration**:
  - **Difficulty Levels**: Beginner, Intermediate, Advanced
  - **Question Count**: Adjustable from 3 to 20 questions
  - **Time Limits**: Set time per question (5s to 60s)
- **Streamed Generation**: Real-time feedback during quiz creation using AI streaming
- **Smart Prompting**: Optimized prompts for high-quality, educational content

### 📅 Daily Quiz Challenge

- **Fresh Daily Content**: New quiz generated every day on trending/educational topics
- **Engagement Tracking**: Track daily quiz streaks and participation
- **Category Rotation**: Varied topics to ensure diverse learning

### 🎮 Interactive Quiz Experience

- **Timed Questions**: Countdown timer with visual progress indicator
- **Rich Content**: Markdown support for questions and explanations (code blocks, bold text, lists)
- **Review Mode**: Comprehensive review system to analyze answers with detailed AI-generated explanations
- **Resume Capability**: Active quiz state is saved, allowing users to resume exactly where they left off
- **Hint System**: Optional hints available during gameplay

### 📊 Dashboard & Statistics

- **Smart Dashboard**:
  - Key statistics (Total Quizzes, Average Score, Best Topic)
  - Active quiz progress for quick resumption
  - Recent quiz cards with quick access
- **Daily Quiz Card**: Prominent daily challenge card with animated elements
- **Performance Insights**: Track improvement over time

### 📜 History & Search

- **Advanced History**:
  - **Full-Text Search**: Search across quiz titles and categories
  - **Multi-Filter System**: Filter by Difficulty and Categories simultaneously
  - **Animated Filter Bar**: Custom-built, expanding search with integrated filter popup
- **Bulk Actions**: Multi-select and delete multiple quizzes at once
- **Pagination**: Efficient loading for large quiz histories

### 📤 Sharing & Export

- **Share as Image**: Beautiful certificate-style result cards for social media
- **Share Results Summary**: Text-based summary with performance metrics
- **Learning Guide PDF**: Professional PDF export with all questions, answers, and explanations
- **Share Individual Questions**: Export specific questions as shareable images
- **Report Issues**: Flag problematic questions for review

### ☁️ Backup & Sync

- **Cloud Backups**: Save quiz data to cloud storage
- **Restore Capability**: Retrieve backed-up quizzes on any device
- **Data Management**: Choose to keep or delete local data on sign out

### ⚙️ Settings & Customization

- **Theme Support**: Light, Dark, and System-default themes
- **Profile Management**: Update display name and profile settings
- **Account Management**: Secure sign out with data options
- **About & Legal**: Developer info, privacy policy, terms of service

### ⚡ Performance & UX

- **Perfect Shimmer**: Custom shimmer loading states matching actual layouts
- **Data Preloading**: Bootstrap process warms up critical data before app starts
- **Animated UI**: Extensive use of `flutter_animate` for smooth transitions
- **Material 3 Expressive**: Modern design language with consistent components
- **Offline Support**: Full functionality for reviewing past content offline

### 🔐 Authentication & Security

- **Firebase Auth**: Secure email/password and Google Sign-In
- **Local-First Data**: All data stored locally using Drift (SQLite)
- **User Isolation**: Quiz data properly isolated per user account

---

## 3. Technology Stack

### Core Framework

| Technology | Purpose |
|------------|---------|
| **Flutter** | UI Toolkit (SDK > 3.10.1) |
| **Dart** | Programming language |

### State Management & Architecture

| Technology | Purpose |
|------------|---------|
| **Flutter Riverpod** | Compile-safe state management and DI |
| **Riverpod Generator** | Reducing boilerplate code |
| **Feature-First Architecture** | Scalable codebase organization |

### Backend & Services

| Technology | Purpose |
|------------|---------|
| **Google Gemini AI** | Intelligent quiz content generation |
| **Firebase Authentication** | User identity management |
| **Firebase Core** | Initialization and configuration |

### Local Data Persistence

| Technology | Purpose |
|------------|---------|
| **Drift (SQLite)** | Reactive persistence for quiz data |
| **Hive** | Key-value storage for settings |

**Database Tables:**

- `Quizzes` - Quiz metadata and configuration
- `Questions` - Individual quiz questions with options
- `QuizResults` - Completed quiz scores and analytics
- `QuizProgress` - In-progress quiz state for resume
- `UserPreferences` - User settings and preferences

### UI/UX Libraries

| Library | Purpose |
|---------|---------|
| **Flutter Animate** | Declarative, chainable animations |
| **GoRouter** | Declarative routing and deep linking |
| **Google Fonts** | Typography (Inter font family) |
| **Flutter Markdown** | Rich text content rendering |
| **Share Plus** | Native sharing functionality |
| **Screenshot** | Image capture for sharing |
| **PDF** | PDF generation for exports |
| **Font Awesome Flutter** | Icon library |

---

## 4. Architecture & Folder Structure

The project follows a strict **Feature-First** directory structure:

```
lib/
├── main.dart                 # Entry point
└── src/
    ├── app.dart              # App Widget & Theme Config
    └── features/
        ├── auth/             # Authentication
        │   ├── data/         # Auth repository
        │   └── presentation/ # Login, Register screens
        │
        ├── backup/           # Cloud Backup
        │   ├── data/         # Backup repository
        │   └── presentation/ # Backup management UI
        │
        ├── dashboard/        # Main Dashboard
        │   ├── data/         # Daily quiz repository
        │   ├── domain/       # Quiz config, entities
        │   └── presentation/ # Dashboard UI, Stats, Widgets
        │
        ├── history/          # Quiz History
        │   └── presentation/ # History list, Search, Filters
        │
        ├── home/             # Main Shell
        │   └── presentation/ # BottomNav, PageView container
        │
        ├── onboarding/       # First-time User Experience
        │   └── presentation/ # Intro screens
        │
        ├── quiz/             # Core Quiz Feature
        │   ├── data/         # Quiz repository, API
        │   ├── domain/       # Quiz entities, models
        │   └── presentation/ # Quiz play, Results, Widgets
        │
        └── settings/         # User Settings
            └── presentation/ # Settings screen, Preferences
    
    └── core/                 # Shared Resources
        ├── bootstrap.dart    # App initialization
        ├── database/         # Drift database setup
        ├── services/         # External services (Gemini)
        └── widgets/          # Shared UI components
```

---

## 5. Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         APP LAUNCH                               │
├─────────────────────────────────────────────────────────────────┤
│  1. Bootstrap                                                    │
│     ├── Initialize Firebase                                      │
│     ├── Initialize Hive & Drift                                  │
│     └── Pre-fetch Dashboard stats & History                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      QUIZ CREATION                               │
├─────────────────────────────────────────────────────────────────┤
│  2. User configures quiz (topic, difficulty, count, time)        │
│  3. QuizRepository calls GeminiService                           │
│  4. AI generates questions with streaming feedback               │
│  5. Quiz saved to Drift (AppDatabase)                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      QUIZ SESSION                                │
├─────────────────────────────────────────────────────────────────┤
│  6. QuizController manages game state                            │
│  7. QuizProgress updated after every answer                      │
│  8. Timer tracked per question                                   │
│  9. State persisted for resume capability                        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      COMPLETION                                  │
├─────────────────────────────────────────────────────────────────┤
│  10. QuizResult calculated (score, time, accuracy)               │
│  11. Result saved to QuizResults table                           │
│  12. Dashboard & History auto-update via Riverpod streams        │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      REVIEW & SHARE                              │
├─────────────────────────────────────────────────────────────────┤
│  13. Review mode for analyzing answers                           │
│  14. Share as image, text, or PDF                                │
│  15. Individual question sharing                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. Design System

### Material 3 Expressive Components

| Component | Token | Usage |
|-----------|-------|-------|
| Card Backgrounds | `surfaceContainerHigh` | Option tiles, info cards |
| Elevated Surfaces | `surfaceContainerHighest @ 0.5` | Icon buttons |
| Primary Tint | `primary @ 0.08` | History cards, search bar |
| Icon Backgrounds | `primary @ 0.1` | Option icons |
| Danger States | `errorContainer @ 0.2` | Delete actions |

### Consistent UI Patterns

- **Bottom Sheet Headers**: Left-aligned title + subtitle with close button on right
- **Icon Buttons**: 40x40 fixed size, 20px icons, rounded backgrounds
- **Option Cards**: No borders, surfaceContainerHigh background, chevron indicator
- **Typography**: titleLarge (w700) for headers, bodySmall for subtitles

---

## 7. Documentation & Assets

- **Legal Documents**: `docs/privacy_policy.md`, `docs/terms_of_service.md`
- **Landing Page**: `landing_page/index.html`

---

## 8. Future Roadmap

- [ ] **Leaderboards**: Global rankings based on quiz scores
- [ ] **Spaced Repetition**: AI-suggested review of weak topics
- [ ] **Achievements System**: Badges and rewards for milestones
- [ ] **Multiplayer Mode**: Challenge friends to the same quiz
- [ ] **Custom Categories**: User-defined quiz categories
- [ ] **Offline Quiz Generation**: Cache AI capabilities for offline use
- [ ] **Widget Support**: Home screen widget for daily quiz

---

## 9. Getting Started

### Prerequisites

- Flutter SDK >= 3.10.1
- Firebase project configured
- Google Gemini API access

### Installation

```bash
# Clone repository
git clone https://github.com/akhlashashmi/rapidval.git

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build

# Launch app
flutter run
```

### Configuration

1. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
2. Configure Gemini API key in environment
3. Run database migrations if needed

---

## 10. Contributing

Contributions are welcome! Please read the contribution guidelines and submit PRs for review.

---

## 11. License

This project is proprietary software. See LICENSE file for details.

---

**Built with ❤️ by [Akhlas Ahmed](https://akhlasahmed.online/)**
