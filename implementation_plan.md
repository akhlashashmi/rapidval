# AI Quiz App Implementation Plan

## 1. Project Setup & Dependencies
- [ ] **Clean up `pubspec.yaml`**: Remove Supabase, add Firebase, Hive v4, Gemini AI, and UI packages.
- [ ] **Project Structure**: Create Feature-First directory structure (`lib/src/features/...`).
- [ ] **Configuration**: Setup `build.yaml` for code generation.

## 2. Core Infrastructure
- [ ] **Theme**: Implement "Clean, Insane Design" with Material 3 and `google_fonts`.
- [ ] **Local Storage**: Create `LocalStorageService` interface (Abstract Class) and implement `HiveStorageService` (Hive v4).
- [ ] **Firebase**: Initialize Firebase in `main.dart`.
- [ ] **Routing**: Setup `GoRouter` with auth redirection logic.

## 3. Feature: Authentication
- [ ] **Domain**: `UserEntity`.
- [ ] **Data**: `AuthRepository` (Firebase Auth).
- [ ] **Presentation**: 
    - Login/Sign-up Screen.
    - **Compliance**: "Delete Account" functionality.

## 4. Feature: Dashboard & Configuration
- [ ] **UI**: Topic selection, Difficulty, Question Count, Timer.
- [ ] **Logic**: Store user preferences using Riverpod.

## 5. Feature: AI Quiz Generation (Gemini)
- [ ] **Service**: `GeminiService` with strict JSON schema prompt.
- [ ] **Safety**: Client-side topic filtering.
- [ ] **Data**: `QuizRepository` to fetch and parse questions.

## 6. Feature: Quiz Execution
- [ ] **UI**: Immersive Quiz Screen with `flutter_animate`.
- [ ] **Logic**: 
    - Timer (Ticker/Stream).
    - State preservation on rotation.
    - **Compliance**: "Report Issue" button.
    - **Compliance**: AI Disclaimer.

## 7. Feature: Evaluation & History
- [ ] **Logic**: Score calculation.
- [ ] **Data**: Save results to Firestore and sync with Hive.
- [ ] **UI**: Results Screen and History List.

## 8. Polishing & Compliance Check
- [ ] **Review**: Verify Google Play policies (Data Safety, AI content).
- [ ] **Testing**: Manual walkthrough of flows.
