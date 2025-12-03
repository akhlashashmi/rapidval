import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

import '../../features/quiz/domain/user_answer.dart';

part 'app_database.g.dart';

// Type Converters
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();
  @override
  List<String> fromSql(String fromDb) => List<String>.from(json.decode(fromDb));
  @override
  String toSql(List<String> value) => json.encode(value);
}

class UserAnswerListConverter extends TypeConverter<List<UserAnswer>, String> {
  const UserAnswerListConverter();
  @override
  List<UserAnswer> fromSql(String fromDb) {
    final List<dynamic> jsonList = json.decode(fromDb);
    return jsonList.map((e) => UserAnswer.fromJson(e)).toList();
  }

  @override
  String toSql(List<UserAnswer> value) =>
      json.encode(value.map((e) => e.toJson()).toList());
}

// Tables
class Quizzes extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().withDefault(const Constant(''))();
  TextColumn get topic => text()();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get category =>
      text().withDefault(const Constant('General Knowledge'))();
  TextColumn get topics => text()
      .map(const StringListConverter())
      .withDefault(const Constant('[]'))();
  TextColumn get difficulty => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class Questions extends Table {
  TextColumn get id => text()();
  TextColumn get quizId =>
      text().references(Quizzes, #id, onDelete: KeyAction.cascade)();
  TextColumn get question => text()();
  TextColumn get options => text().map(const StringListConverter())();
  IntColumn get correctOptionIndex => integer()();
  TextColumn get explanation => text()();
  TextColumn get hint => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class QuizResults extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().withDefault(const Constant(''))();
  TextColumn get quizId =>
      text().references(Quizzes, #id, onDelete: KeyAction.cascade)();
  IntColumn get score => integer()();
  IntColumn get totalQuestions => integer()();
  RealColumn get percentage => real()();
  DateTimeColumn get completedAt => dateTime()();
  TextColumn get answers => text().map(const UserAnswerListConverter())();

  @override
  Set<Column> get primaryKey => {id};
}

class UserPreferences extends Table {
  TextColumn get userId => text()();
  TextColumn get lastTopic => text().nullable()();
  TextColumn get difficulty => text().nullable()();
  IntColumn get questionCount => integer().nullable()();
  IntColumn get timePerQuestion => integer().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}

class QuizProgress extends Table {
  TextColumn get userId => text()();
  TextColumn get quizId =>
      text().references(Quizzes, #id, onDelete: KeyAction.cascade)();
  IntColumn get currentQuestionIndex => integer()();
  IntColumn get timeLeft => integer()();
  IntColumn get timePerQuestion => integer().withDefault(const Constant(15))();
  TextColumn get answers => text().map(const UserAnswerListConverter())();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get lastUpdated =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {userId, quizId};
}

@DriftDatabase(
  tables: [Quizzes, Questions, QuizResults, UserPreferences, QuizProgress],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.addColumn(quizzes, quizzes.userId);
        await m.addColumn(quizResults, quizResults.userId);
      }
      if (from < 3) {
        await m.createTable(userPreferences);
      }
      if (from < 4) {
        await m.createTable(quizProgress);
      }
      if (from == 4) {
        await m.addColumn(quizProgress, quizProgress.timePerQuestion);
      }
      if (from < 6) {
        // Recreate table to update primary key and add lastUpdated
        await m.deleteTable(quizProgress.actualTableName);
        await m.createTable(quizProgress);
      }
      if (from < 7) {
        await m.addColumn(quizzes, quizzes.title);
        await m.addColumn(quizzes, quizzes.category);
        await m.addColumn(quizzes, quizzes.topics);
        await m.addColumn(questions, questions.hint);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
