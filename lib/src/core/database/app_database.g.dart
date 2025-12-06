// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuizzesTable extends Quizzes with TableInfo<$QuizzesTable, Quizze> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizzesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _topicMeta = const VerificationMeta('topic');
  @override
  late final GeneratedColumn<String> topic = GeneratedColumn<String>(
    'topic',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General Knowledge'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> topics =
      GeneratedColumn<String>(
        'topics',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($QuizzesTable.$convertertopics);
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    topic,
    title,
    category,
    topics,
    difficulty,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quizzes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Quizze> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('topic')) {
      context.handle(
        _topicMeta,
        topic.isAcceptableOrUnknown(data['topic']!, _topicMeta),
      );
    } else if (isInserting) {
      context.missing(_topicMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Quizze map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Quizze(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      topic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}topic'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      topics: $QuizzesTable.$convertertopics.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}topics'],
        )!,
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $QuizzesTable createAlias(String alias) {
    return $QuizzesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertertopics =
      const StringListConverter();
}

class Quizze extends DataClass implements Insertable<Quizze> {
  final String id;
  final String userId;
  final String topic;
  final String title;
  final String category;
  final List<String> topics;
  final String difficulty;
  final DateTime createdAt;
  const Quizze({
    required this.id,
    required this.userId,
    required this.topic,
    required this.title,
    required this.category,
    required this.topics,
    required this.difficulty,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['topic'] = Variable<String>(topic);
    map['title'] = Variable<String>(title);
    map['category'] = Variable<String>(category);
    {
      map['topics'] = Variable<String>(
        $QuizzesTable.$convertertopics.toSql(topics),
      );
    }
    map['difficulty'] = Variable<String>(difficulty);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  QuizzesCompanion toCompanion(bool nullToAbsent) {
    return QuizzesCompanion(
      id: Value(id),
      userId: Value(userId),
      topic: Value(topic),
      title: Value(title),
      category: Value(category),
      topics: Value(topics),
      difficulty: Value(difficulty),
      createdAt: Value(createdAt),
    );
  }

  factory Quizze.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Quizze(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      topic: serializer.fromJson<String>(json['topic']),
      title: serializer.fromJson<String>(json['title']),
      category: serializer.fromJson<String>(json['category']),
      topics: serializer.fromJson<List<String>>(json['topics']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'topic': serializer.toJson<String>(topic),
      'title': serializer.toJson<String>(title),
      'category': serializer.toJson<String>(category),
      'topics': serializer.toJson<List<String>>(topics),
      'difficulty': serializer.toJson<String>(difficulty),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Quizze copyWith({
    String? id,
    String? userId,
    String? topic,
    String? title,
    String? category,
    List<String>? topics,
    String? difficulty,
    DateTime? createdAt,
  }) => Quizze(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    topic: topic ?? this.topic,
    title: title ?? this.title,
    category: category ?? this.category,
    topics: topics ?? this.topics,
    difficulty: difficulty ?? this.difficulty,
    createdAt: createdAt ?? this.createdAt,
  );
  Quizze copyWithCompanion(QuizzesCompanion data) {
    return Quizze(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      topic: data.topic.present ? data.topic.value : this.topic,
      title: data.title.present ? data.title.value : this.title,
      category: data.category.present ? data.category.value : this.category,
      topics: data.topics.present ? data.topics.value : this.topics,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Quizze(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('topic: $topic, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('topics: $topics, ')
          ..write('difficulty: $difficulty, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    topic,
    title,
    category,
    topics,
    difficulty,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Quizze &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.topic == this.topic &&
          other.title == this.title &&
          other.category == this.category &&
          other.topics == this.topics &&
          other.difficulty == this.difficulty &&
          other.createdAt == this.createdAt);
}

class QuizzesCompanion extends UpdateCompanion<Quizze> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> topic;
  final Value<String> title;
  final Value<String> category;
  final Value<List<String>> topics;
  final Value<String> difficulty;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const QuizzesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.topic = const Value.absent(),
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.topics = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizzesCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String topic,
    this.title = const Value.absent(),
    this.category = const Value.absent(),
    this.topics = const Value.absent(),
    required String difficulty,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       topic = Value(topic),
       difficulty = Value(difficulty),
       createdAt = Value(createdAt);
  static Insertable<Quizze> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? topic,
    Expression<String>? title,
    Expression<String>? category,
    Expression<String>? topics,
    Expression<String>? difficulty,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (topic != null) 'topic': topic,
      if (title != null) 'title': title,
      if (category != null) 'category': category,
      if (topics != null) 'topics': topics,
      if (difficulty != null) 'difficulty': difficulty,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizzesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? topic,
    Value<String>? title,
    Value<String>? category,
    Value<List<String>>? topics,
    Value<String>? difficulty,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return QuizzesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      topic: topic ?? this.topic,
      title: title ?? this.title,
      category: category ?? this.category,
      topics: topics ?? this.topics,
      difficulty: difficulty ?? this.difficulty,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (topic.present) {
      map['topic'] = Variable<String>(topic.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (topics.present) {
      map['topics'] = Variable<String>(
        $QuizzesTable.$convertertopics.toSql(topics.value),
      );
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizzesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('topic: $topic, ')
          ..write('title: $title, ')
          ..write('category: $category, ')
          ..write('topics: $topics, ')
          ..write('difficulty: $difficulty, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
    'quiz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quizzes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _questionMeta = const VerificationMeta(
    'question',
  );
  @override
  late final GeneratedColumn<String> question = GeneratedColumn<String>(
    'question',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> options =
      GeneratedColumn<String>(
        'options',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($QuestionsTable.$converteroptions);
  static const VerificationMeta _correctOptionIndexMeta =
      const VerificationMeta('correctOptionIndex');
  @override
  late final GeneratedColumn<int> correctOptionIndex = GeneratedColumn<int>(
    'correct_option_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hintMeta = const VerificationMeta('hint');
  @override
  late final GeneratedColumn<String> hint = GeneratedColumn<String>(
    'hint',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('single'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<int>, String>
  correctIndices = GeneratedColumn<String>(
    'correct_indices',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<int>>($QuestionsTable.$convertercorrectIndices);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    quizId,
    question,
    options,
    correctOptionIndex,
    explanation,
    hint,
    type,
    correctIndices,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Question> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('quiz_id')) {
      context.handle(
        _quizIdMeta,
        quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('question')) {
      context.handle(
        _questionMeta,
        question.isAcceptableOrUnknown(data['question']!, _questionMeta),
      );
    } else if (isInserting) {
      context.missing(_questionMeta);
    }
    if (data.containsKey('correct_option_index')) {
      context.handle(
        _correctOptionIndexMeta,
        correctOptionIndex.isAcceptableOrUnknown(
          data['correct_option_index']!,
          _correctOptionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctOptionIndexMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('hint')) {
      context.handle(
        _hintMeta,
        hint.isAcceptableOrUnknown(data['hint']!, _hintMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      quizId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_id'],
      )!,
      question: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question'],
      )!,
      options: $QuestionsTable.$converteroptions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}options'],
        )!,
      ),
      correctOptionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_option_index'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
      hint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hint'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      correctIndices: $QuestionsTable.$convertercorrectIndices.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}correct_indices'],
        )!,
      ),
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converteroptions =
      const StringListConverter();
  static TypeConverter<List<int>, String> $convertercorrectIndices =
      const IntListConverter();
}

class Question extends DataClass implements Insertable<Question> {
  final String id;
  final String quizId;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String? hint;
  final String type;
  final List<int> correctIndices;
  const Question({
    required this.id,
    required this.quizId,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.hint,
    required this.type,
    required this.correctIndices,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['quiz_id'] = Variable<String>(quizId);
    map['question'] = Variable<String>(question);
    {
      map['options'] = Variable<String>(
        $QuestionsTable.$converteroptions.toSql(options),
      );
    }
    map['correct_option_index'] = Variable<int>(correctOptionIndex);
    map['explanation'] = Variable<String>(explanation);
    if (!nullToAbsent || hint != null) {
      map['hint'] = Variable<String>(hint);
    }
    map['type'] = Variable<String>(type);
    {
      map['correct_indices'] = Variable<String>(
        $QuestionsTable.$convertercorrectIndices.toSql(correctIndices),
      );
    }
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      quizId: Value(quizId),
      question: Value(question),
      options: Value(options),
      correctOptionIndex: Value(correctOptionIndex),
      explanation: Value(explanation),
      hint: hint == null && nullToAbsent ? const Value.absent() : Value(hint),
      type: Value(type),
      correctIndices: Value(correctIndices),
    );
  }

  factory Question.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<String>(json['id']),
      quizId: serializer.fromJson<String>(json['quizId']),
      question: serializer.fromJson<String>(json['question']),
      options: serializer.fromJson<List<String>>(json['options']),
      correctOptionIndex: serializer.fromJson<int>(json['correctOptionIndex']),
      explanation: serializer.fromJson<String>(json['explanation']),
      hint: serializer.fromJson<String?>(json['hint']),
      type: serializer.fromJson<String>(json['type']),
      correctIndices: serializer.fromJson<List<int>>(json['correctIndices']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'quizId': serializer.toJson<String>(quizId),
      'question': serializer.toJson<String>(question),
      'options': serializer.toJson<List<String>>(options),
      'correctOptionIndex': serializer.toJson<int>(correctOptionIndex),
      'explanation': serializer.toJson<String>(explanation),
      'hint': serializer.toJson<String?>(hint),
      'type': serializer.toJson<String>(type),
      'correctIndices': serializer.toJson<List<int>>(correctIndices),
    };
  }

  Question copyWith({
    String? id,
    String? quizId,
    String? question,
    List<String>? options,
    int? correctOptionIndex,
    String? explanation,
    Value<String?> hint = const Value.absent(),
    String? type,
    List<int>? correctIndices,
  }) => Question(
    id: id ?? this.id,
    quizId: quizId ?? this.quizId,
    question: question ?? this.question,
    options: options ?? this.options,
    correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
    explanation: explanation ?? this.explanation,
    hint: hint.present ? hint.value : this.hint,
    type: type ?? this.type,
    correctIndices: correctIndices ?? this.correctIndices,
  );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      question: data.question.present ? data.question.value : this.question,
      options: data.options.present ? data.options.value : this.options,
      correctOptionIndex: data.correctOptionIndex.present
          ? data.correctOptionIndex.value
          : this.correctOptionIndex,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
      hint: data.hint.present ? data.hint.value : this.hint,
      type: data.type.present ? data.type.value : this.type,
      correctIndices: data.correctIndices.present
          ? data.correctIndices.value
          : this.correctIndices,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('question: $question, ')
          ..write('options: $options, ')
          ..write('correctOptionIndex: $correctOptionIndex, ')
          ..write('explanation: $explanation, ')
          ..write('hint: $hint, ')
          ..write('type: $type, ')
          ..write('correctIndices: $correctIndices')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    quizId,
    question,
    options,
    correctOptionIndex,
    explanation,
    hint,
    type,
    correctIndices,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.quizId == this.quizId &&
          other.question == this.question &&
          other.options == this.options &&
          other.correctOptionIndex == this.correctOptionIndex &&
          other.explanation == this.explanation &&
          other.hint == this.hint &&
          other.type == this.type &&
          other.correctIndices == this.correctIndices);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<String> id;
  final Value<String> quizId;
  final Value<String> question;
  final Value<List<String>> options;
  final Value<int> correctOptionIndex;
  final Value<String> explanation;
  final Value<String?> hint;
  final Value<String> type;
  final Value<List<int>> correctIndices;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.quizId = const Value.absent(),
    this.question = const Value.absent(),
    this.options = const Value.absent(),
    this.correctOptionIndex = const Value.absent(),
    this.explanation = const Value.absent(),
    this.hint = const Value.absent(),
    this.type = const Value.absent(),
    this.correctIndices = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required String quizId,
    required String question,
    required List<String> options,
    required int correctOptionIndex,
    required String explanation,
    this.hint = const Value.absent(),
    this.type = const Value.absent(),
    this.correctIndices = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quizId = Value(quizId),
       question = Value(question),
       options = Value(options),
       correctOptionIndex = Value(correctOptionIndex),
       explanation = Value(explanation);
  static Insertable<Question> custom({
    Expression<String>? id,
    Expression<String>? quizId,
    Expression<String>? question,
    Expression<String>? options,
    Expression<int>? correctOptionIndex,
    Expression<String>? explanation,
    Expression<String>? hint,
    Expression<String>? type,
    Expression<String>? correctIndices,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quizId != null) 'quiz_id': quizId,
      if (question != null) 'question': question,
      if (options != null) 'options': options,
      if (correctOptionIndex != null)
        'correct_option_index': correctOptionIndex,
      if (explanation != null) 'explanation': explanation,
      if (hint != null) 'hint': hint,
      if (type != null) 'type': type,
      if (correctIndices != null) 'correct_indices': correctIndices,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? quizId,
    Value<String>? question,
    Value<List<String>>? options,
    Value<int>? correctOptionIndex,
    Value<String>? explanation,
    Value<String?>? hint,
    Value<String>? type,
    Value<List<int>>? correctIndices,
    Value<int>? rowid,
  }) {
    return QuestionsCompanion(
      id: id ?? this.id,
      quizId: quizId ?? this.quizId,
      question: question ?? this.question,
      options: options ?? this.options,
      correctOptionIndex: correctOptionIndex ?? this.correctOptionIndex,
      explanation: explanation ?? this.explanation,
      hint: hint ?? this.hint,
      type: type ?? this.type,
      correctIndices: correctIndices ?? this.correctIndices,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (question.present) {
      map['question'] = Variable<String>(question.value);
    }
    if (options.present) {
      map['options'] = Variable<String>(
        $QuestionsTable.$converteroptions.toSql(options.value),
      );
    }
    if (correctOptionIndex.present) {
      map['correct_option_index'] = Variable<int>(correctOptionIndex.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (hint.present) {
      map['hint'] = Variable<String>(hint.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (correctIndices.present) {
      map['correct_indices'] = Variable<String>(
        $QuestionsTable.$convertercorrectIndices.toSql(correctIndices.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('quizId: $quizId, ')
          ..write('question: $question, ')
          ..write('options: $options, ')
          ..write('correctOptionIndex: $correctOptionIndex, ')
          ..write('explanation: $explanation, ')
          ..write('hint: $hint, ')
          ..write('type: $type, ')
          ..write('correctIndices: $correctIndices, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizResultsTable extends QuizResults
    with TableInfo<$QuizResultsTable, QuizResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizResultsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
    'quiz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quizzes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentageMeta = const VerificationMeta(
    'percentage',
  );
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
    'percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<UserAnswer>, String>
  answers = GeneratedColumn<String>(
    'answers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<UserAnswer>>($QuizResultsTable.$converteranswers);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    quizId,
    score,
    totalQuestions,
    percentage,
    completedAt,
    answers,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('quiz_id')) {
      context.handle(
        _quizIdMeta,
        quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    } else if (isInserting) {
      context.missing(_scoreMeta);
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
        _percentageMeta,
        percentage.isAcceptableOrUnknown(data['percentage']!, _percentageMeta),
      );
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuizResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizResult(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      quizId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_id'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      percentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percentage'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
      answers: $QuizResultsTable.$converteranswers.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}answers'],
        )!,
      ),
    );
  }

  @override
  $QuizResultsTable createAlias(String alias) {
    return $QuizResultsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<UserAnswer>, String> $converteranswers =
      const UserAnswerListConverter();
}

class QuizResult extends DataClass implements Insertable<QuizResult> {
  final String id;
  final String userId;
  final String quizId;
  final int score;
  final int totalQuestions;
  final double percentage;
  final DateTime completedAt;
  final List<UserAnswer> answers;
  const QuizResult({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.completedAt,
    required this.answers,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['quiz_id'] = Variable<String>(quizId);
    map['score'] = Variable<int>(score);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['percentage'] = Variable<double>(percentage);
    map['completed_at'] = Variable<DateTime>(completedAt);
    {
      map['answers'] = Variable<String>(
        $QuizResultsTable.$converteranswers.toSql(answers),
      );
    }
    return map;
  }

  QuizResultsCompanion toCompanion(bool nullToAbsent) {
    return QuizResultsCompanion(
      id: Value(id),
      userId: Value(userId),
      quizId: Value(quizId),
      score: Value(score),
      totalQuestions: Value(totalQuestions),
      percentage: Value(percentage),
      completedAt: Value(completedAt),
      answers: Value(answers),
    );
  }

  factory QuizResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizResult(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      quizId: serializer.fromJson<String>(json['quizId']),
      score: serializer.fromJson<int>(json['score']),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      percentage: serializer.fromJson<double>(json['percentage']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      answers: serializer.fromJson<List<UserAnswer>>(json['answers']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'quizId': serializer.toJson<String>(quizId),
      'score': serializer.toJson<int>(score),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'percentage': serializer.toJson<double>(percentage),
      'completedAt': serializer.toJson<DateTime>(completedAt),
      'answers': serializer.toJson<List<UserAnswer>>(answers),
    };
  }

  QuizResult copyWith({
    String? id,
    String? userId,
    String? quizId,
    int? score,
    int? totalQuestions,
    double? percentage,
    DateTime? completedAt,
    List<UserAnswer>? answers,
  }) => QuizResult(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    quizId: quizId ?? this.quizId,
    score: score ?? this.score,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    percentage: percentage ?? this.percentage,
    completedAt: completedAt ?? this.completedAt,
    answers: answers ?? this.answers,
  );
  QuizResult copyWithCompanion(QuizResultsCompanion data) {
    return QuizResult(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      score: data.score.present ? data.score.value : this.score,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      percentage: data.percentage.present
          ? data.percentage.value
          : this.percentage,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      answers: data.answers.present ? data.answers.value : this.answers,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizResult(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('quizId: $quizId, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('percentage: $percentage, ')
          ..write('completedAt: $completedAt, ')
          ..write('answers: $answers')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    quizId,
    score,
    totalQuestions,
    percentage,
    completedAt,
    answers,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizResult &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.quizId == this.quizId &&
          other.score == this.score &&
          other.totalQuestions == this.totalQuestions &&
          other.percentage == this.percentage &&
          other.completedAt == this.completedAt &&
          other.answers == this.answers);
}

class QuizResultsCompanion extends UpdateCompanion<QuizResult> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> quizId;
  final Value<int> score;
  final Value<int> totalQuestions;
  final Value<double> percentage;
  final Value<DateTime> completedAt;
  final Value<List<UserAnswer>> answers;
  final Value<int> rowid;
  const QuizResultsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.quizId = const Value.absent(),
    this.score = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.percentage = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.answers = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizResultsCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    required String quizId,
    required int score,
    required int totalQuestions,
    required double percentage,
    required DateTime completedAt,
    required List<UserAnswer> answers,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       quizId = Value(quizId),
       score = Value(score),
       totalQuestions = Value(totalQuestions),
       percentage = Value(percentage),
       completedAt = Value(completedAt),
       answers = Value(answers);
  static Insertable<QuizResult> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? quizId,
    Expression<int>? score,
    Expression<int>? totalQuestions,
    Expression<double>? percentage,
    Expression<DateTime>? completedAt,
    Expression<String>? answers,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (quizId != null) 'quiz_id': quizId,
      if (score != null) 'score': score,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (percentage != null) 'percentage': percentage,
      if (completedAt != null) 'completed_at': completedAt,
      if (answers != null) 'answers': answers,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizResultsCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? quizId,
    Value<int>? score,
    Value<int>? totalQuestions,
    Value<double>? percentage,
    Value<DateTime>? completedAt,
    Value<List<UserAnswer>>? answers,
    Value<int>? rowid,
  }) {
    return QuizResultsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      quizId: quizId ?? this.quizId,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      percentage: percentage ?? this.percentage,
      completedAt: completedAt ?? this.completedAt,
      answers: answers ?? this.answers,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (answers.present) {
      map['answers'] = Variable<String>(
        $QuizResultsTable.$converteranswers.toSql(answers.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizResultsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('quizId: $quizId, ')
          ..write('score: $score, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('percentage: $percentage, ')
          ..write('completedAt: $completedAt, ')
          ..write('answers: $answers, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastTopicMeta = const VerificationMeta(
    'lastTopic',
  );
  @override
  late final GeneratedColumn<String> lastTopic = GeneratedColumn<String>(
    'last_topic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionCountMeta = const VerificationMeta(
    'questionCount',
  );
  @override
  late final GeneratedColumn<int> questionCount = GeneratedColumn<int>(
    'question_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timePerQuestionMeta = const VerificationMeta(
    'timePerQuestion',
  );
  @override
  late final GeneratedColumn<int> timePerQuestion = GeneratedColumn<int>(
    'time_per_question',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    lastTopic,
    difficulty,
    questionCount,
    timePerQuestion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('last_topic')) {
      context.handle(
        _lastTopicMeta,
        lastTopic.isAcceptableOrUnknown(data['last_topic']!, _lastTopicMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('question_count')) {
      context.handle(
        _questionCountMeta,
        questionCount.isAcceptableOrUnknown(
          data['question_count']!,
          _questionCountMeta,
        ),
      );
    }
    if (data.containsKey('time_per_question')) {
      context.handle(
        _timePerQuestionMeta,
        timePerQuestion.isAcceptableOrUnknown(
          data['time_per_question']!,
          _timePerQuestionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      lastTopic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_topic'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      ),
      questionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_count'],
      ),
      timePerQuestion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_per_question'],
      ),
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  final String userId;
  final String? lastTopic;
  final String? difficulty;
  final int? questionCount;
  final int? timePerQuestion;
  const UserPreference({
    required this.userId,
    this.lastTopic,
    this.difficulty,
    this.questionCount,
    this.timePerQuestion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || lastTopic != null) {
      map['last_topic'] = Variable<String>(lastTopic);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<String>(difficulty);
    }
    if (!nullToAbsent || questionCount != null) {
      map['question_count'] = Variable<int>(questionCount);
    }
    if (!nullToAbsent || timePerQuestion != null) {
      map['time_per_question'] = Variable<int>(timePerQuestion);
    }
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      userId: Value(userId),
      lastTopic: lastTopic == null && nullToAbsent
          ? const Value.absent()
          : Value(lastTopic),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      questionCount: questionCount == null && nullToAbsent
          ? const Value.absent()
          : Value(questionCount),
      timePerQuestion: timePerQuestion == null && nullToAbsent
          ? const Value.absent()
          : Value(timePerQuestion),
    );
  }

  factory UserPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      userId: serializer.fromJson<String>(json['userId']),
      lastTopic: serializer.fromJson<String?>(json['lastTopic']),
      difficulty: serializer.fromJson<String?>(json['difficulty']),
      questionCount: serializer.fromJson<int?>(json['questionCount']),
      timePerQuestion: serializer.fromJson<int?>(json['timePerQuestion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'lastTopic': serializer.toJson<String?>(lastTopic),
      'difficulty': serializer.toJson<String?>(difficulty),
      'questionCount': serializer.toJson<int?>(questionCount),
      'timePerQuestion': serializer.toJson<int?>(timePerQuestion),
    };
  }

  UserPreference copyWith({
    String? userId,
    Value<String?> lastTopic = const Value.absent(),
    Value<String?> difficulty = const Value.absent(),
    Value<int?> questionCount = const Value.absent(),
    Value<int?> timePerQuestion = const Value.absent(),
  }) => UserPreference(
    userId: userId ?? this.userId,
    lastTopic: lastTopic.present ? lastTopic.value : this.lastTopic,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    questionCount: questionCount.present
        ? questionCount.value
        : this.questionCount,
    timePerQuestion: timePerQuestion.present
        ? timePerQuestion.value
        : this.timePerQuestion,
  );
  UserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreference(
      userId: data.userId.present ? data.userId.value : this.userId,
      lastTopic: data.lastTopic.present ? data.lastTopic.value : this.lastTopic,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      questionCount: data.questionCount.present
          ? data.questionCount.value
          : this.questionCount,
      timePerQuestion: data.timePerQuestion.present
          ? data.timePerQuestion.value
          : this.timePerQuestion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('userId: $userId, ')
          ..write('lastTopic: $lastTopic, ')
          ..write('difficulty: $difficulty, ')
          ..write('questionCount: $questionCount, ')
          ..write('timePerQuestion: $timePerQuestion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    lastTopic,
    difficulty,
    questionCount,
    timePerQuestion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.userId == this.userId &&
          other.lastTopic == this.lastTopic &&
          other.difficulty == this.difficulty &&
          other.questionCount == this.questionCount &&
          other.timePerQuestion == this.timePerQuestion);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<String> userId;
  final Value<String?> lastTopic;
  final Value<String?> difficulty;
  final Value<int?> questionCount;
  final Value<int?> timePerQuestion;
  final Value<int> rowid;
  const UserPreferencesCompanion({
    this.userId = const Value.absent(),
    this.lastTopic = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.timePerQuestion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    required String userId,
    this.lastTopic = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.timePerQuestion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<UserPreference> custom({
    Expression<String>? userId,
    Expression<String>? lastTopic,
    Expression<String>? difficulty,
    Expression<int>? questionCount,
    Expression<int>? timePerQuestion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (lastTopic != null) 'last_topic': lastTopic,
      if (difficulty != null) 'difficulty': difficulty,
      if (questionCount != null) 'question_count': questionCount,
      if (timePerQuestion != null) 'time_per_question': timePerQuestion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserPreferencesCompanion copyWith({
    Value<String>? userId,
    Value<String?>? lastTopic,
    Value<String?>? difficulty,
    Value<int?>? questionCount,
    Value<int?>? timePerQuestion,
    Value<int>? rowid,
  }) {
    return UserPreferencesCompanion(
      userId: userId ?? this.userId,
      lastTopic: lastTopic ?? this.lastTopic,
      difficulty: difficulty ?? this.difficulty,
      questionCount: questionCount ?? this.questionCount,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (lastTopic.present) {
      map['last_topic'] = Variable<String>(lastTopic.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (questionCount.present) {
      map['question_count'] = Variable<int>(questionCount.value);
    }
    if (timePerQuestion.present) {
      map['time_per_question'] = Variable<int>(timePerQuestion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('userId: $userId, ')
          ..write('lastTopic: $lastTopic, ')
          ..write('difficulty: $difficulty, ')
          ..write('questionCount: $questionCount, ')
          ..write('timePerQuestion: $timePerQuestion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuizProgressTable extends QuizProgress
    with TableInfo<$QuizProgressTable, QuizProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuizProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quizIdMeta = const VerificationMeta('quizId');
  @override
  late final GeneratedColumn<String> quizId = GeneratedColumn<String>(
    'quiz_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quizzes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _currentQuestionIndexMeta =
      const VerificationMeta('currentQuestionIndex');
  @override
  late final GeneratedColumn<int> currentQuestionIndex = GeneratedColumn<int>(
    'current_question_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeLeftMeta = const VerificationMeta(
    'timeLeft',
  );
  @override
  late final GeneratedColumn<int> timeLeft = GeneratedColumn<int>(
    'time_left',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timePerQuestionMeta = const VerificationMeta(
    'timePerQuestion',
  );
  @override
  late final GeneratedColumn<int> timePerQuestion = GeneratedColumn<int>(
    'time_per_question',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<UserAnswer>, String>
  answers = GeneratedColumn<String>(
    'answers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<List<UserAnswer>>($QuizProgressTable.$converteranswers);
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    quizId,
    currentQuestionIndex,
    timeLeft,
    timePerQuestion,
    answers,
    startedAt,
    lastUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quiz_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuizProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('quiz_id')) {
      context.handle(
        _quizIdMeta,
        quizId.isAcceptableOrUnknown(data['quiz_id']!, _quizIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quizIdMeta);
    }
    if (data.containsKey('current_question_index')) {
      context.handle(
        _currentQuestionIndexMeta,
        currentQuestionIndex.isAcceptableOrUnknown(
          data['current_question_index']!,
          _currentQuestionIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentQuestionIndexMeta);
    }
    if (data.containsKey('time_left')) {
      context.handle(
        _timeLeftMeta,
        timeLeft.isAcceptableOrUnknown(data['time_left']!, _timeLeftMeta),
      );
    } else if (isInserting) {
      context.missing(_timeLeftMeta);
    }
    if (data.containsKey('time_per_question')) {
      context.handle(
        _timePerQuestionMeta,
        timePerQuestion.isAcceptableOrUnknown(
          data['time_per_question']!,
          _timePerQuestionMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, quizId};
  @override
  QuizProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuizProgressData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      quizId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiz_id'],
      )!,
      currentQuestionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_question_index'],
      )!,
      timeLeft: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_left'],
      )!,
      timePerQuestion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_per_question'],
      )!,
      answers: $QuizProgressTable.$converteranswers.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}answers'],
        )!,
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
    );
  }

  @override
  $QuizProgressTable createAlias(String alias) {
    return $QuizProgressTable(attachedDatabase, alias);
  }

  static TypeConverter<List<UserAnswer>, String> $converteranswers =
      const UserAnswerListConverter();
}

class QuizProgressData extends DataClass
    implements Insertable<QuizProgressData> {
  final String userId;
  final String quizId;
  final int currentQuestionIndex;
  final int timeLeft;
  final int timePerQuestion;
  final List<UserAnswer> answers;
  final DateTime startedAt;
  final DateTime lastUpdated;
  const QuizProgressData({
    required this.userId,
    required this.quizId,
    required this.currentQuestionIndex,
    required this.timeLeft,
    required this.timePerQuestion,
    required this.answers,
    required this.startedAt,
    required this.lastUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['quiz_id'] = Variable<String>(quizId);
    map['current_question_index'] = Variable<int>(currentQuestionIndex);
    map['time_left'] = Variable<int>(timeLeft);
    map['time_per_question'] = Variable<int>(timePerQuestion);
    {
      map['answers'] = Variable<String>(
        $QuizProgressTable.$converteranswers.toSql(answers),
      );
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    return map;
  }

  QuizProgressCompanion toCompanion(bool nullToAbsent) {
    return QuizProgressCompanion(
      userId: Value(userId),
      quizId: Value(quizId),
      currentQuestionIndex: Value(currentQuestionIndex),
      timeLeft: Value(timeLeft),
      timePerQuestion: Value(timePerQuestion),
      answers: Value(answers),
      startedAt: Value(startedAt),
      lastUpdated: Value(lastUpdated),
    );
  }

  factory QuizProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuizProgressData(
      userId: serializer.fromJson<String>(json['userId']),
      quizId: serializer.fromJson<String>(json['quizId']),
      currentQuestionIndex: serializer.fromJson<int>(
        json['currentQuestionIndex'],
      ),
      timeLeft: serializer.fromJson<int>(json['timeLeft']),
      timePerQuestion: serializer.fromJson<int>(json['timePerQuestion']),
      answers: serializer.fromJson<List<UserAnswer>>(json['answers']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'quizId': serializer.toJson<String>(quizId),
      'currentQuestionIndex': serializer.toJson<int>(currentQuestionIndex),
      'timeLeft': serializer.toJson<int>(timeLeft),
      'timePerQuestion': serializer.toJson<int>(timePerQuestion),
      'answers': serializer.toJson<List<UserAnswer>>(answers),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
    };
  }

  QuizProgressData copyWith({
    String? userId,
    String? quizId,
    int? currentQuestionIndex,
    int? timeLeft,
    int? timePerQuestion,
    List<UserAnswer>? answers,
    DateTime? startedAt,
    DateTime? lastUpdated,
  }) => QuizProgressData(
    userId: userId ?? this.userId,
    quizId: quizId ?? this.quizId,
    currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    timeLeft: timeLeft ?? this.timeLeft,
    timePerQuestion: timePerQuestion ?? this.timePerQuestion,
    answers: answers ?? this.answers,
    startedAt: startedAt ?? this.startedAt,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
  QuizProgressData copyWithCompanion(QuizProgressCompanion data) {
    return QuizProgressData(
      userId: data.userId.present ? data.userId.value : this.userId,
      quizId: data.quizId.present ? data.quizId.value : this.quizId,
      currentQuestionIndex: data.currentQuestionIndex.present
          ? data.currentQuestionIndex.value
          : this.currentQuestionIndex,
      timeLeft: data.timeLeft.present ? data.timeLeft.value : this.timeLeft,
      timePerQuestion: data.timePerQuestion.present
          ? data.timePerQuestion.value
          : this.timePerQuestion,
      answers: data.answers.present ? data.answers.value : this.answers,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuizProgressData(')
          ..write('userId: $userId, ')
          ..write('quizId: $quizId, ')
          ..write('currentQuestionIndex: $currentQuestionIndex, ')
          ..write('timeLeft: $timeLeft, ')
          ..write('timePerQuestion: $timePerQuestion, ')
          ..write('answers: $answers, ')
          ..write('startedAt: $startedAt, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    quizId,
    currentQuestionIndex,
    timeLeft,
    timePerQuestion,
    answers,
    startedAt,
    lastUpdated,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuizProgressData &&
          other.userId == this.userId &&
          other.quizId == this.quizId &&
          other.currentQuestionIndex == this.currentQuestionIndex &&
          other.timeLeft == this.timeLeft &&
          other.timePerQuestion == this.timePerQuestion &&
          other.answers == this.answers &&
          other.startedAt == this.startedAt &&
          other.lastUpdated == this.lastUpdated);
}

class QuizProgressCompanion extends UpdateCompanion<QuizProgressData> {
  final Value<String> userId;
  final Value<String> quizId;
  final Value<int> currentQuestionIndex;
  final Value<int> timeLeft;
  final Value<int> timePerQuestion;
  final Value<List<UserAnswer>> answers;
  final Value<DateTime> startedAt;
  final Value<DateTime> lastUpdated;
  final Value<int> rowid;
  const QuizProgressCompanion({
    this.userId = const Value.absent(),
    this.quizId = const Value.absent(),
    this.currentQuestionIndex = const Value.absent(),
    this.timeLeft = const Value.absent(),
    this.timePerQuestion = const Value.absent(),
    this.answers = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuizProgressCompanion.insert({
    required String userId,
    required String quizId,
    required int currentQuestionIndex,
    required int timeLeft,
    this.timePerQuestion = const Value.absent(),
    required List<UserAnswer> answers,
    required DateTime startedAt,
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       quizId = Value(quizId),
       currentQuestionIndex = Value(currentQuestionIndex),
       timeLeft = Value(timeLeft),
       answers = Value(answers),
       startedAt = Value(startedAt);
  static Insertable<QuizProgressData> custom({
    Expression<String>? userId,
    Expression<String>? quizId,
    Expression<int>? currentQuestionIndex,
    Expression<int>? timeLeft,
    Expression<int>? timePerQuestion,
    Expression<String>? answers,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (quizId != null) 'quiz_id': quizId,
      if (currentQuestionIndex != null)
        'current_question_index': currentQuestionIndex,
      if (timeLeft != null) 'time_left': timeLeft,
      if (timePerQuestion != null) 'time_per_question': timePerQuestion,
      if (answers != null) 'answers': answers,
      if (startedAt != null) 'started_at': startedAt,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuizProgressCompanion copyWith({
    Value<String>? userId,
    Value<String>? quizId,
    Value<int>? currentQuestionIndex,
    Value<int>? timeLeft,
    Value<int>? timePerQuestion,
    Value<List<UserAnswer>>? answers,
    Value<DateTime>? startedAt,
    Value<DateTime>? lastUpdated,
    Value<int>? rowid,
  }) {
    return QuizProgressCompanion(
      userId: userId ?? this.userId,
      quizId: quizId ?? this.quizId,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      timeLeft: timeLeft ?? this.timeLeft,
      timePerQuestion: timePerQuestion ?? this.timePerQuestion,
      answers: answers ?? this.answers,
      startedAt: startedAt ?? this.startedAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (quizId.present) {
      map['quiz_id'] = Variable<String>(quizId.value);
    }
    if (currentQuestionIndex.present) {
      map['current_question_index'] = Variable<int>(currentQuestionIndex.value);
    }
    if (timeLeft.present) {
      map['time_left'] = Variable<int>(timeLeft.value);
    }
    if (timePerQuestion.present) {
      map['time_per_question'] = Variable<int>(timePerQuestion.value);
    }
    if (answers.present) {
      map['answers'] = Variable<String>(
        $QuizProgressTable.$converteranswers.toSql(answers.value),
      );
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuizProgressCompanion(')
          ..write('userId: $userId, ')
          ..write('quizId: $quizId, ')
          ..write('currentQuestionIndex: $currentQuestionIndex, ')
          ..write('timeLeft: $timeLeft, ')
          ..write('timePerQuestion: $timePerQuestion, ')
          ..write('answers: $answers, ')
          ..write('startedAt: $startedAt, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuizzesTable quizzes = $QuizzesTable(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $QuizResultsTable quizResults = $QuizResultsTable(this);
  late final $UserPreferencesTable userPreferences = $UserPreferencesTable(
    this,
  );
  late final $QuizProgressTable quizProgress = $QuizProgressTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    quizzes,
    questions,
    quizResults,
    userPreferences,
    quizProgress,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quizzes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('questions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quizzes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'quizzes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('quiz_progress', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$QuizzesTableCreateCompanionBuilder =
    QuizzesCompanion Function({
      required String id,
      Value<String> userId,
      required String topic,
      Value<String> title,
      Value<String> category,
      Value<List<String>> topics,
      required String difficulty,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$QuizzesTableUpdateCompanionBuilder =
    QuizzesCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> topic,
      Value<String> title,
      Value<String> category,
      Value<List<String>> topics,
      Value<String> difficulty,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$QuizzesTableReferences
    extends BaseReferences<_$AppDatabase, $QuizzesTable, Quizze> {
  $$QuizzesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$QuestionsTable, List<Question>>
  _questionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.questions,
    aliasName: $_aliasNameGenerator(db.quizzes.id, db.questions.quizId),
  );

  $$QuestionsTableProcessedTableManager get questionsRefs {
    final manager = $$QuestionsTableTableManager(
      $_db,
      $_db.questions,
    ).filter((f) => f.quizId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_questionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizResultsTable, List<QuizResult>>
  _quizResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizResults,
    aliasName: $_aliasNameGenerator(db.quizzes.id, db.quizResults.quizId),
  );

  $$QuizResultsTableProcessedTableManager get quizResultsRefs {
    final manager = $$QuizResultsTableTableManager(
      $_db,
      $_db.quizResults,
    ).filter((f) => f.quizId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizResultsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$QuizProgressTable, List<QuizProgressData>>
  _quizProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.quizProgress,
    aliasName: $_aliasNameGenerator(db.quizzes.id, db.quizProgress.quizId),
  );

  $$QuizProgressTableProcessedTableManager get quizProgressRefs {
    final manager = $$QuizProgressTableTableManager(
      $_db,
      $_db.quizProgress,
    ).filter((f) => f.quizId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_quizProgressRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuizzesTableFilterComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get topics => $composableBuilder(
    column: $table.topics,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> questionsRefs(
    Expression<bool> Function($$QuestionsTableFilterComposer f) f,
  ) {
    final $$QuestionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableFilterComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizResultsRefs(
    Expression<bool> Function($$QuizResultsTableFilterComposer f) f,
  ) {
    final $$QuizResultsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizResults,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizResultsTableFilterComposer(
            $db: $db,
            $table: $db.quizResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> quizProgressRefs(
    Expression<bool> Function($$QuizProgressTableFilterComposer f) f,
  ) {
    final $$QuizProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizProgress,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizProgressTableFilterComposer(
            $db: $db,
            $table: $db.quizProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizzesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topic => $composableBuilder(
    column: $table.topic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get topics => $composableBuilder(
    column: $table.topics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuizzesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizzesTable> {
  $$QuizzesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get topic =>
      $composableBuilder(column: $table.topic, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get topics =>
      $composableBuilder(column: $table.topics, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> questionsRefs<T extends Object>(
    Expression<T> Function($$QuestionsTableAnnotationComposer a) f,
  ) {
    final $$QuestionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.questions,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuestionsTableAnnotationComposer(
            $db: $db,
            $table: $db.questions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizResultsRefs<T extends Object>(
    Expression<T> Function($$QuizResultsTableAnnotationComposer a) f,
  ) {
    final $$QuizResultsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizResults,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizResultsTableAnnotationComposer(
            $db: $db,
            $table: $db.quizResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> quizProgressRefs<T extends Object>(
    Expression<T> Function($$QuizProgressTableAnnotationComposer a) f,
  ) {
    final $$QuizProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.quizProgress,
      getReferencedColumn: (t) => t.quizId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.quizProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuizzesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizzesTable,
          Quizze,
          $$QuizzesTableFilterComposer,
          $$QuizzesTableOrderingComposer,
          $$QuizzesTableAnnotationComposer,
          $$QuizzesTableCreateCompanionBuilder,
          $$QuizzesTableUpdateCompanionBuilder,
          (Quizze, $$QuizzesTableReferences),
          Quizze,
          PrefetchHooks Function({
            bool questionsRefs,
            bool quizResultsRefs,
            bool quizProgressRefs,
          })
        > {
  $$QuizzesTableTableManager(_$AppDatabase db, $QuizzesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizzesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizzesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizzesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> topic = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<List<String>> topics = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizzesCompanion(
                id: id,
                userId: userId,
                topic: topic,
                title: title,
                category: category,
                topics: topics,
                difficulty: difficulty,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> userId = const Value.absent(),
                required String topic,
                Value<String> title = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<List<String>> topics = const Value.absent(),
                required String difficulty,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => QuizzesCompanion.insert(
                id: id,
                userId: userId,
                topic: topic,
                title: title,
                category: category,
                topics: topics,
                difficulty: difficulty,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizzesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                questionsRefs = false,
                quizResultsRefs = false,
                quizProgressRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (questionsRefs) db.questions,
                    if (quizResultsRefs) db.quizResults,
                    if (quizProgressRefs) db.quizProgress,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (questionsRefs)
                        await $_getPrefetchedData<
                          Quizze,
                          $QuizzesTable,
                          Question
                        >(
                          currentTable: table,
                          referencedTable: $$QuizzesTableReferences
                              ._questionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizzesTableReferences(
                                db,
                                table,
                                p0,
                              ).questionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quizId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizResultsRefs)
                        await $_getPrefetchedData<
                          Quizze,
                          $QuizzesTable,
                          QuizResult
                        >(
                          currentTable: table,
                          referencedTable: $$QuizzesTableReferences
                              ._quizResultsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizzesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quizId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (quizProgressRefs)
                        await $_getPrefetchedData<
                          Quizze,
                          $QuizzesTable,
                          QuizProgressData
                        >(
                          currentTable: table,
                          referencedTable: $$QuizzesTableReferences
                              ._quizProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$QuizzesTableReferences(
                                db,
                                table,
                                p0,
                              ).quizProgressRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.quizId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$QuizzesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizzesTable,
      Quizze,
      $$QuizzesTableFilterComposer,
      $$QuizzesTableOrderingComposer,
      $$QuizzesTableAnnotationComposer,
      $$QuizzesTableCreateCompanionBuilder,
      $$QuizzesTableUpdateCompanionBuilder,
      (Quizze, $$QuizzesTableReferences),
      Quizze,
      PrefetchHooks Function({
        bool questionsRefs,
        bool quizResultsRefs,
        bool quizProgressRefs,
      })
    >;
typedef $$QuestionsTableCreateCompanionBuilder =
    QuestionsCompanion Function({
      required String id,
      required String quizId,
      required String question,
      required List<String> options,
      required int correctOptionIndex,
      required String explanation,
      Value<String?> hint,
      Value<String> type,
      Value<List<int>> correctIndices,
      Value<int> rowid,
    });
typedef $$QuestionsTableUpdateCompanionBuilder =
    QuestionsCompanion Function({
      Value<String> id,
      Value<String> quizId,
      Value<String> question,
      Value<List<String>> options,
      Value<int> correctOptionIndex,
      Value<String> explanation,
      Value<String?> hint,
      Value<String> type,
      Value<List<int>> correctIndices,
      Value<int> rowid,
    });

final class $$QuestionsTableReferences
    extends BaseReferences<_$AppDatabase, $QuestionsTable, Question> {
  $$QuestionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QuizzesTable _quizIdTable(_$AppDatabase db) => db.quizzes.createAlias(
    $_aliasNameGenerator(db.questions.quizId, db.quizzes.id),
  );

  $$QuizzesTableProcessedTableManager get quizId {
    final $_column = $_itemColumn<String>('quiz_id')!;

    final manager = $$QuizzesTableTableManager(
      $_db,
      $_db.quizzes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quizIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get correctOptionIndex => $composableBuilder(
    column: $table.correctOptionIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hint => $composableBuilder(
    column: $table.hint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<int>, List<int>, String>
  get correctIndices => $composableBuilder(
    column: $table.correctIndices,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$QuizzesTableFilterComposer get quizId {
    final $$QuizzesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableFilterComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get question => $composableBuilder(
    column: $table.question,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get options => $composableBuilder(
    column: $table.options,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctOptionIndex => $composableBuilder(
    column: $table.correctOptionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hint => $composableBuilder(
    column: $table.hint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get correctIndices => $composableBuilder(
    column: $table.correctIndices,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizzesTableOrderingComposer get quizId {
    final $$QuizzesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableOrderingComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get question =>
      $composableBuilder(column: $table.question, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get options =>
      $composableBuilder(column: $table.options, builder: (column) => column);

  GeneratedColumn<int> get correctOptionIndex => $composableBuilder(
    column: $table.correctOptionIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hint =>
      $composableBuilder(column: $table.hint, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<int>, String> get correctIndices =>
      $composableBuilder(
        column: $table.correctIndices,
        builder: (column) => column,
      );

  $$QuizzesTableAnnotationComposer get quizId {
    final $$QuizzesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableAnnotationComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionsTable,
          Question,
          $$QuestionsTableFilterComposer,
          $$QuestionsTableOrderingComposer,
          $$QuestionsTableAnnotationComposer,
          $$QuestionsTableCreateCompanionBuilder,
          $$QuestionsTableUpdateCompanionBuilder,
          (Question, $$QuestionsTableReferences),
          Question,
          PrefetchHooks Function({bool quizId})
        > {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> quizId = const Value.absent(),
                Value<String> question = const Value.absent(),
                Value<List<String>> options = const Value.absent(),
                Value<int> correctOptionIndex = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<String?> hint = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<List<int>> correctIndices = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion(
                id: id,
                quizId: quizId,
                question: question,
                options: options,
                correctOptionIndex: correctOptionIndex,
                explanation: explanation,
                hint: hint,
                type: type,
                correctIndices: correctIndices,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String quizId,
                required String question,
                required List<String> options,
                required int correctOptionIndex,
                required String explanation,
                Value<String?> hint = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<List<int>> correctIndices = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuestionsCompanion.insert(
                id: id,
                quizId: quizId,
                question: question,
                options: options,
                correctOptionIndex: correctOptionIndex,
                explanation: explanation,
                hint: hint,
                type: type,
                correctIndices: correctIndices,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuestionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quizId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quizId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quizId,
                                referencedTable: $$QuestionsTableReferences
                                    ._quizIdTable(db),
                                referencedColumn: $$QuestionsTableReferences
                                    ._quizIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionsTable,
      Question,
      $$QuestionsTableFilterComposer,
      $$QuestionsTableOrderingComposer,
      $$QuestionsTableAnnotationComposer,
      $$QuestionsTableCreateCompanionBuilder,
      $$QuestionsTableUpdateCompanionBuilder,
      (Question, $$QuestionsTableReferences),
      Question,
      PrefetchHooks Function({bool quizId})
    >;
typedef $$QuizResultsTableCreateCompanionBuilder =
    QuizResultsCompanion Function({
      required String id,
      Value<String> userId,
      required String quizId,
      required int score,
      required int totalQuestions,
      required double percentage,
      required DateTime completedAt,
      required List<UserAnswer> answers,
      Value<int> rowid,
    });
typedef $$QuizResultsTableUpdateCompanionBuilder =
    QuizResultsCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> quizId,
      Value<int> score,
      Value<int> totalQuestions,
      Value<double> percentage,
      Value<DateTime> completedAt,
      Value<List<UserAnswer>> answers,
      Value<int> rowid,
    });

final class $$QuizResultsTableReferences
    extends BaseReferences<_$AppDatabase, $QuizResultsTable, QuizResult> {
  $$QuizResultsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QuizzesTable _quizIdTable(_$AppDatabase db) => db.quizzes.createAlias(
    $_aliasNameGenerator(db.quizResults.quizId, db.quizzes.id),
  );

  $$QuizzesTableProcessedTableManager get quizId {
    final $_column = $_itemColumn<String>('quiz_id')!;

    final manager = $$QuizzesTableTableManager(
      $_db,
      $_db.quizzes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quizIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizResultsTableFilterComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<UserAnswer>, List<UserAnswer>, String>
  get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$QuizzesTableFilterComposer get quizId {
    final $$QuizzesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableFilterComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizResultsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizzesTableOrderingComposer get quizId {
    final $$QuizzesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableOrderingComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizResultsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizResultsTable> {
  $$QuizResultsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<UserAnswer>, String> get answers =>
      $composableBuilder(column: $table.answers, builder: (column) => column);

  $$QuizzesTableAnnotationComposer get quizId {
    final $$QuizzesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableAnnotationComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizResultsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizResultsTable,
          QuizResult,
          $$QuizResultsTableFilterComposer,
          $$QuizResultsTableOrderingComposer,
          $$QuizResultsTableAnnotationComposer,
          $$QuizResultsTableCreateCompanionBuilder,
          $$QuizResultsTableUpdateCompanionBuilder,
          (QuizResult, $$QuizResultsTableReferences),
          QuizResult,
          PrefetchHooks Function({bool quizId})
        > {
  $$QuizResultsTableTableManager(_$AppDatabase db, $QuizResultsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizResultsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizResultsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizResultsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> quizId = const Value.absent(),
                Value<int> score = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<double> percentage = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
                Value<List<UserAnswer>> answers = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizResultsCompanion(
                id: id,
                userId: userId,
                quizId: quizId,
                score: score,
                totalQuestions: totalQuestions,
                percentage: percentage,
                completedAt: completedAt,
                answers: answers,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> userId = const Value.absent(),
                required String quizId,
                required int score,
                required int totalQuestions,
                required double percentage,
                required DateTime completedAt,
                required List<UserAnswer> answers,
                Value<int> rowid = const Value.absent(),
              }) => QuizResultsCompanion.insert(
                id: id,
                userId: userId,
                quizId: quizId,
                score: score,
                totalQuestions: totalQuestions,
                percentage: percentage,
                completedAt: completedAt,
                answers: answers,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizResultsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quizId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quizId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quizId,
                                referencedTable: $$QuizResultsTableReferences
                                    ._quizIdTable(db),
                                referencedColumn: $$QuizResultsTableReferences
                                    ._quizIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizResultsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizResultsTable,
      QuizResult,
      $$QuizResultsTableFilterComposer,
      $$QuizResultsTableOrderingComposer,
      $$QuizResultsTableAnnotationComposer,
      $$QuizResultsTableCreateCompanionBuilder,
      $$QuizResultsTableUpdateCompanionBuilder,
      (QuizResult, $$QuizResultsTableReferences),
      QuizResult,
      PrefetchHooks Function({bool quizId})
    >;
typedef $$UserPreferencesTableCreateCompanionBuilder =
    UserPreferencesCompanion Function({
      required String userId,
      Value<String?> lastTopic,
      Value<String?> difficulty,
      Value<int?> questionCount,
      Value<int?> timePerQuestion,
      Value<int> rowid,
    });
typedef $$UserPreferencesTableUpdateCompanionBuilder =
    UserPreferencesCompanion Function({
      Value<String> userId,
      Value<String?> lastTopic,
      Value<String?> difficulty,
      Value<int?> questionCount,
      Value<int?> timePerQuestion,
      Value<int> rowid,
    });

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastTopic => $composableBuilder(
    column: $table.lastTopic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastTopic => $composableBuilder(
    column: $table.lastTopic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get lastTopic =>
      $composableBuilder(column: $table.lastTopic, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => column,
  );
}

class $$UserPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTable,
          UserPreference,
          $$UserPreferencesTableFilterComposer,
          $$UserPreferencesTableOrderingComposer,
          $$UserPreferencesTableAnnotationComposer,
          $$UserPreferencesTableCreateCompanionBuilder,
          $$UserPreferencesTableUpdateCompanionBuilder,
          (
            UserPreference,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTable,
              UserPreference
            >,
          ),
          UserPreference,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String?> lastTopic = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<int?> questionCount = const Value.absent(),
                Value<int?> timePerQuestion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesCompanion(
                userId: userId,
                lastTopic: lastTopic,
                difficulty: difficulty,
                questionCount: questionCount,
                timePerQuestion: timePerQuestion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<String?> lastTopic = const Value.absent(),
                Value<String?> difficulty = const Value.absent(),
                Value<int?> questionCount = const Value.absent(),
                Value<int?> timePerQuestion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserPreferencesCompanion.insert(
                userId: userId,
                lastTopic: lastTopic,
                difficulty: difficulty,
                questionCount: questionCount,
                timePerQuestion: timePerQuestion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTable,
      UserPreference,
      $$UserPreferencesTableFilterComposer,
      $$UserPreferencesTableOrderingComposer,
      $$UserPreferencesTableAnnotationComposer,
      $$UserPreferencesTableCreateCompanionBuilder,
      $$UserPreferencesTableUpdateCompanionBuilder,
      (
        UserPreference,
        BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>,
      ),
      UserPreference,
      PrefetchHooks Function()
    >;
typedef $$QuizProgressTableCreateCompanionBuilder =
    QuizProgressCompanion Function({
      required String userId,
      required String quizId,
      required int currentQuestionIndex,
      required int timeLeft,
      Value<int> timePerQuestion,
      required List<UserAnswer> answers,
      required DateTime startedAt,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });
typedef $$QuizProgressTableUpdateCompanionBuilder =
    QuizProgressCompanion Function({
      Value<String> userId,
      Value<String> quizId,
      Value<int> currentQuestionIndex,
      Value<int> timeLeft,
      Value<int> timePerQuestion,
      Value<List<UserAnswer>> answers,
      Value<DateTime> startedAt,
      Value<DateTime> lastUpdated,
      Value<int> rowid,
    });

final class $$QuizProgressTableReferences
    extends
        BaseReferences<_$AppDatabase, $QuizProgressTable, QuizProgressData> {
  $$QuizProgressTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QuizzesTable _quizIdTable(_$AppDatabase db) => db.quizzes.createAlias(
    $_aliasNameGenerator(db.quizProgress.quizId, db.quizzes.id),
  );

  $$QuizzesTableProcessedTableManager get quizId {
    final $_column = $_itemColumn<String>('quiz_id')!;

    final manager = $$QuizzesTableTableManager(
      $_db,
      $_db.quizzes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quizIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$QuizProgressTableFilterComposer
    extends Composer<_$AppDatabase, $QuizProgressTable> {
  $$QuizProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeLeft => $composableBuilder(
    column: $table.timeLeft,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<UserAnswer>, List<UserAnswer>, String>
  get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  $$QuizzesTableFilterComposer get quizId {
    final $$QuizzesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableFilterComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $QuizProgressTable> {
  $$QuizProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeLeft => $composableBuilder(
    column: $table.timeLeft,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuizzesTableOrderingComposer get quizId {
    final $$QuizzesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableOrderingComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuizProgressTable> {
  $$QuizProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeLeft =>
      $composableBuilder(column: $table.timeLeft, builder: (column) => column);

  GeneratedColumn<int> get timePerQuestion => $composableBuilder(
    column: $table.timePerQuestion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<UserAnswer>, String> get answers =>
      $composableBuilder(column: $table.answers, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  $$QuizzesTableAnnotationComposer get quizId {
    final $$QuizzesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quizId,
      referencedTable: $db.quizzes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuizzesTableAnnotationComposer(
            $db: $db,
            $table: $db.quizzes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$QuizProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuizProgressTable,
          QuizProgressData,
          $$QuizProgressTableFilterComposer,
          $$QuizProgressTableOrderingComposer,
          $$QuizProgressTableAnnotationComposer,
          $$QuizProgressTableCreateCompanionBuilder,
          $$QuizProgressTableUpdateCompanionBuilder,
          (QuizProgressData, $$QuizProgressTableReferences),
          QuizProgressData,
          PrefetchHooks Function({bool quizId})
        > {
  $$QuizProgressTableTableManager(_$AppDatabase db, $QuizProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuizProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuizProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuizProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> quizId = const Value.absent(),
                Value<int> currentQuestionIndex = const Value.absent(),
                Value<int> timeLeft = const Value.absent(),
                Value<int> timePerQuestion = const Value.absent(),
                Value<List<UserAnswer>> answers = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizProgressCompanion(
                userId: userId,
                quizId: quizId,
                currentQuestionIndex: currentQuestionIndex,
                timeLeft: timeLeft,
                timePerQuestion: timePerQuestion,
                answers: answers,
                startedAt: startedAt,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String quizId,
                required int currentQuestionIndex,
                required int timeLeft,
                Value<int> timePerQuestion = const Value.absent(),
                required List<UserAnswer> answers,
                required DateTime startedAt,
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => QuizProgressCompanion.insert(
                userId: userId,
                quizId: quizId,
                currentQuestionIndex: currentQuestionIndex,
                timeLeft: timeLeft,
                timePerQuestion: timePerQuestion,
                answers: answers,
                startedAt: startedAt,
                lastUpdated: lastUpdated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuizProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quizId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quizId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quizId,
                                referencedTable: $$QuizProgressTableReferences
                                    ._quizIdTable(db),
                                referencedColumn: $$QuizProgressTableReferences
                                    ._quizIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$QuizProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuizProgressTable,
      QuizProgressData,
      $$QuizProgressTableFilterComposer,
      $$QuizProgressTableOrderingComposer,
      $$QuizProgressTableAnnotationComposer,
      $$QuizProgressTableCreateCompanionBuilder,
      $$QuizProgressTableUpdateCompanionBuilder,
      (QuizProgressData, $$QuizProgressTableReferences),
      QuizProgressData,
      PrefetchHooks Function({bool quizId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuizzesTableTableManager get quizzes =>
      $$QuizzesTableTableManager(_db, _db.quizzes);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$QuizResultsTableTableManager get quizResults =>
      $$QuizResultsTableTableManager(_db, _db.quizResults);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$QuizProgressTableTableManager get quizProgress =>
      $$QuizProgressTableTableManager(_db, _db.quizProgress);
}
