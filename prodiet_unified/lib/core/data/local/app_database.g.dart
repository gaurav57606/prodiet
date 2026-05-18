// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LocalMealsTable extends LocalMeals
    with TableInfo<$LocalMealsTable, LocalMeal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'meal_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('scheduled'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ingredientsJsonMeta =
      const VerificationMeta('ingredientsJson');
  @override
  late final GeneratedColumn<String> ingredientsJson = GeneratedColumn<String>(
      'ingredients_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nutritionalValuesJsonMeta =
      const VerificationMeta('nutritionalValuesJson');
  @override
  late final GeneratedColumn<String> nutritionalValuesJson =
      GeneratedColumn<String>('nutritional_values_json', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _scheduledTimeMeta =
      const VerificationMeta('scheduledTime');
  @override
  late final GeneratedColumn<String> scheduledTime = GeneratedColumn<String>(
      'scheduled_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _clientUpdatedAtMeta =
      const VerificationMeta('clientUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>('client_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
      'created_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        name,
        mealType,
        status,
        date,
        ingredientsJson,
        nutritionalValuesJson,
        scheduledTime,
        isDirty,
        updatedAt,
        clientUpdatedAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_meals';
  @override
  VerificationContext validateIntegrity(Insertable<LocalMeal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('ingredients_json')) {
      context.handle(
          _ingredientsJsonMeta,
          ingredientsJson.isAcceptableOrUnknown(
              data['ingredients_json']!, _ingredientsJsonMeta));
    }
    if (data.containsKey('nutritional_values_json')) {
      context.handle(
          _nutritionalValuesJsonMeta,
          nutritionalValuesJson.isAcceptableOrUnknown(
              data['nutritional_values_json']!, _nutritionalValuesJsonMeta));
    }
    if (data.containsKey('scheduled_time')) {
      context.handle(
          _scheduledTimeMeta,
          scheduledTime.isAcceptableOrUnknown(
              data['scheduled_time']!, _scheduledTimeMeta));
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
          _clientUpdatedAtMeta,
          clientUpdatedAt.isAcceptableOrUnknown(
              data['client_updated_at']!, _clientUpdatedAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalMeal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMeal(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}meal_type'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      ingredientsJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ingredients_json']),
      nutritionalValuesJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}nutritional_values_json']),
      scheduledTime: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scheduled_time']),
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}client_updated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $LocalMealsTable createAlias(String alias) {
    return $LocalMealsTable(attachedDatabase, alias);
  }
}

class LocalMeal extends DataClass implements Insertable<LocalMeal> {
  final String id;
  final String userId;
  final String name;
  final String mealType;
  final String status;
  final String date;
  final String? ingredientsJson;
  final String? nutritionalValuesJson;
  final String? scheduledTime;
  final bool isDirty;
  final DateTime? updatedAt;
  final DateTime clientUpdatedAt;
  final String createdAt;
  const LocalMeal(
      {required this.id,
      required this.userId,
      required this.name,
      required this.mealType,
      required this.status,
      required this.date,
      this.ingredientsJson,
      this.nutritionalValuesJson,
      this.scheduledTime,
      required this.isDirty,
      this.updatedAt,
      required this.clientUpdatedAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['meal_type'] = Variable<String>(mealType);
    map['status'] = Variable<String>(status);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || ingredientsJson != null) {
      map['ingredients_json'] = Variable<String>(ingredientsJson);
    }
    if (!nullToAbsent || nutritionalValuesJson != null) {
      map['nutritional_values_json'] = Variable<String>(nutritionalValuesJson);
    }
    if (!nullToAbsent || scheduledTime != null) {
      map['scheduled_time'] = Variable<String>(scheduledTime);
    }
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  LocalMealsCompanion toCompanion(bool nullToAbsent) {
    return LocalMealsCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      mealType: Value(mealType),
      status: Value(status),
      date: Value(date),
      ingredientsJson: ingredientsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientsJson),
      nutritionalValuesJson: nutritionalValuesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(nutritionalValuesJson),
      scheduledTime: scheduledTime == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledTime),
      isDirty: Value(isDirty),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      clientUpdatedAt: Value(clientUpdatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory LocalMeal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMeal(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      mealType: serializer.fromJson<String>(json['mealType']),
      status: serializer.fromJson<String>(json['status']),
      date: serializer.fromJson<String>(json['date']),
      ingredientsJson: serializer.fromJson<String?>(json['ingredientsJson']),
      nutritionalValuesJson:
          serializer.fromJson<String?>(json['nutritionalValuesJson']),
      scheduledTime: serializer.fromJson<String?>(json['scheduledTime']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'mealType': serializer.toJson<String>(mealType),
      'status': serializer.toJson<String>(status),
      'date': serializer.toJson<String>(date),
      'ingredientsJson': serializer.toJson<String?>(ingredientsJson),
      'nutritionalValuesJson':
          serializer.toJson<String?>(nutritionalValuesJson),
      'scheduledTime': serializer.toJson<String?>(scheduledTime),
      'isDirty': serializer.toJson<bool>(isDirty),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  LocalMeal copyWith(
          {String? id,
          String? userId,
          String? name,
          String? mealType,
          String? status,
          String? date,
          Value<String?> ingredientsJson = const Value.absent(),
          Value<String?> nutritionalValuesJson = const Value.absent(),
          Value<String?> scheduledTime = const Value.absent(),
          bool? isDirty,
          Value<DateTime?> updatedAt = const Value.absent(),
          DateTime? clientUpdatedAt,
          String? createdAt}) =>
      LocalMeal(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        mealType: mealType ?? this.mealType,
        status: status ?? this.status,
        date: date ?? this.date,
        ingredientsJson: ingredientsJson.present
            ? ingredientsJson.value
            : this.ingredientsJson,
        nutritionalValuesJson: nutritionalValuesJson.present
            ? nutritionalValuesJson.value
            : this.nutritionalValuesJson,
        scheduledTime:
            scheduledTime.present ? scheduledTime.value : this.scheduledTime,
        isDirty: isDirty ?? this.isDirty,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
        createdAt: createdAt ?? this.createdAt,
      );
  LocalMeal copyWithCompanion(LocalMealsCompanion data) {
    return LocalMeal(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      status: data.status.present ? data.status.value : this.status,
      date: data.date.present ? data.date.value : this.date,
      ingredientsJson: data.ingredientsJson.present
          ? data.ingredientsJson.value
          : this.ingredientsJson,
      nutritionalValuesJson: data.nutritionalValuesJson.present
          ? data.nutritionalValuesJson.value
          : this.nutritionalValuesJson,
      scheduledTime: data.scheduledTime.present
          ? data.scheduledTime.value
          : this.scheduledTime,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMeal(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('mealType: $mealType, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('nutritionalValuesJson: $nutritionalValuesJson, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('isDirty: $isDirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      name,
      mealType,
      status,
      date,
      ingredientsJson,
      nutritionalValuesJson,
      scheduledTime,
      isDirty,
      updatedAt,
      clientUpdatedAt,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMeal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.mealType == this.mealType &&
          other.status == this.status &&
          other.date == this.date &&
          other.ingredientsJson == this.ingredientsJson &&
          other.nutritionalValuesJson == this.nutritionalValuesJson &&
          other.scheduledTime == this.scheduledTime &&
          other.isDirty == this.isDirty &&
          other.updatedAt == this.updatedAt &&
          other.clientUpdatedAt == this.clientUpdatedAt &&
          other.createdAt == this.createdAt);
}

class LocalMealsCompanion extends UpdateCompanion<LocalMeal> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> mealType;
  final Value<String> status;
  final Value<String> date;
  final Value<String?> ingredientsJson;
  final Value<String?> nutritionalValuesJson;
  final Value<String?> scheduledTime;
  final Value<bool> isDirty;
  final Value<DateTime?> updatedAt;
  final Value<DateTime> clientUpdatedAt;
  final Value<String> createdAt;
  final Value<int> rowid;
  const LocalMealsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.mealType = const Value.absent(),
    this.status = const Value.absent(),
    this.date = const Value.absent(),
    this.ingredientsJson = const Value.absent(),
    this.nutritionalValuesJson = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalMealsCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String mealType,
    this.status = const Value.absent(),
    required String date,
    this.ingredientsJson = const Value.absent(),
    this.nutritionalValuesJson = const Value.absent(),
    this.scheduledTime = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        name = Value(name),
        mealType = Value(mealType),
        date = Value(date),
        createdAt = Value(createdAt);
  static Insertable<LocalMeal> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? mealType,
    Expression<String>? status,
    Expression<String>? date,
    Expression<String>? ingredientsJson,
    Expression<String>? nutritionalValuesJson,
    Expression<String>? scheduledTime,
    Expression<bool>? isDirty,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? clientUpdatedAt,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (mealType != null) 'meal_type': mealType,
      if (status != null) 'status': status,
      if (date != null) 'date': date,
      if (ingredientsJson != null) 'ingredients_json': ingredientsJson,
      if (nutritionalValuesJson != null)
        'nutritional_values_json': nutritionalValuesJson,
      if (scheduledTime != null) 'scheduled_time': scheduledTime,
      if (isDirty != null) 'is_dirty': isDirty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalMealsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? name,
      Value<String>? mealType,
      Value<String>? status,
      Value<String>? date,
      Value<String?>? ingredientsJson,
      Value<String?>? nutritionalValuesJson,
      Value<String?>? scheduledTime,
      Value<bool>? isDirty,
      Value<DateTime?>? updatedAt,
      Value<DateTime>? clientUpdatedAt,
      Value<String>? createdAt,
      Value<int>? rowid}) {
    return LocalMealsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      status: status ?? this.status,
      date: date ?? this.date,
      ingredientsJson: ingredientsJson ?? this.ingredientsJson,
      nutritionalValuesJson:
          nutritionalValuesJson ?? this.nutritionalValuesJson,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isDirty: isDirty ?? this.isDirty,
      updatedAt: updatedAt ?? this.updatedAt,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (ingredientsJson.present) {
      map['ingredients_json'] = Variable<String>(ingredientsJson.value);
    }
    if (nutritionalValuesJson.present) {
      map['nutritional_values_json'] =
          Variable<String>(nutritionalValuesJson.value);
    }
    if (scheduledTime.present) {
      map['scheduled_time'] = Variable<String>(scheduledTime.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMealsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('mealType: $mealType, ')
          ..write('status: $status, ')
          ..write('date: $date, ')
          ..write('ingredientsJson: $ingredientsJson, ')
          ..write('nutritionalValuesJson: $nutritionalValuesJson, ')
          ..write('scheduledTime: $scheduledTime, ')
          ..write('isDirty: $isDirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalInventoryTable extends LocalInventory
    with TableInfo<$LocalInventoryTable, LocalInventoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalInventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ingredientNameMeta =
      const VerificationMeta('ingredientName');
  @override
  late final GeneratedColumn<String> ingredientName = GeneratedColumn<String>(
      'ingredient_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _reorderThresholdMeta =
      const VerificationMeta('reorderThreshold');
  @override
  late final GeneratedColumn<double> reorderThreshold = GeneratedColumn<double>(
      'reorder_threshold', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _shelfLifeDaysMeta =
      const VerificationMeta('shelfLifeDays');
  @override
  late final GeneratedColumn<int> shelfLifeDays = GeneratedColumn<int>(
      'shelf_life_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastRestockedMeta =
      const VerificationMeta('lastRestocked');
  @override
  late final GeneratedColumn<String> lastRestocked = GeneratedColumn<String>(
      'last_restocked', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _clientUpdatedAtMeta =
      const VerificationMeta('clientUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>('client_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        ingredientName,
        quantity,
        unit,
        reorderThreshold,
        shelfLifeDays,
        category,
        lastRestocked,
        isDirty,
        updatedAt,
        clientUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_inventory';
  @override
  VerificationContext validateIntegrity(Insertable<LocalInventoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('ingredient_name')) {
      context.handle(
          _ingredientNameMeta,
          ingredientName.isAcceptableOrUnknown(
              data['ingredient_name']!, _ingredientNameMeta));
    } else if (isInserting) {
      context.missing(_ingredientNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('reorder_threshold')) {
      context.handle(
          _reorderThresholdMeta,
          reorderThreshold.isAcceptableOrUnknown(
              data['reorder_threshold']!, _reorderThresholdMeta));
    }
    if (data.containsKey('shelf_life_days')) {
      context.handle(
          _shelfLifeDaysMeta,
          shelfLifeDays.isAcceptableOrUnknown(
              data['shelf_life_days']!, _shelfLifeDaysMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('last_restocked')) {
      context.handle(
          _lastRestockedMeta,
          lastRestocked.isAcceptableOrUnknown(
              data['last_restocked']!, _lastRestockedMeta));
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
          _clientUpdatedAtMeta,
          clientUpdatedAt.isAcceptableOrUnknown(
              data['client_updated_at']!, _clientUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalInventoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalInventoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      ingredientName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ingredient_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      reorderThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}reorder_threshold']),
      shelfLifeDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}shelf_life_days']),
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category']),
      lastRestocked: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_restocked']),
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}client_updated_at'])!,
    );
  }

  @override
  $LocalInventoryTable createAlias(String alias) {
    return $LocalInventoryTable(attachedDatabase, alias);
  }
}

class LocalInventoryData extends DataClass
    implements Insertable<LocalInventoryData> {
  final String id;
  final String userId;
  final String ingredientName;
  final double quantity;
  final String unit;
  final double? reorderThreshold;
  final int? shelfLifeDays;
  final String? category;
  final String? lastRestocked;
  final bool isDirty;
  final DateTime? updatedAt;
  final DateTime clientUpdatedAt;
  const LocalInventoryData(
      {required this.id,
      required this.userId,
      required this.ingredientName,
      required this.quantity,
      required this.unit,
      this.reorderThreshold,
      this.shelfLifeDays,
      this.category,
      this.lastRestocked,
      required this.isDirty,
      this.updatedAt,
      required this.clientUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['ingredient_name'] = Variable<String>(ingredientName);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || reorderThreshold != null) {
      map['reorder_threshold'] = Variable<double>(reorderThreshold);
    }
    if (!nullToAbsent || shelfLifeDays != null) {
      map['shelf_life_days'] = Variable<int>(shelfLifeDays);
    }
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || lastRestocked != null) {
      map['last_restocked'] = Variable<String>(lastRestocked);
    }
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    return map;
  }

  LocalInventoryCompanion toCompanion(bool nullToAbsent) {
    return LocalInventoryCompanion(
      id: Value(id),
      userId: Value(userId),
      ingredientName: Value(ingredientName),
      quantity: Value(quantity),
      unit: Value(unit),
      reorderThreshold: reorderThreshold == null && nullToAbsent
          ? const Value.absent()
          : Value(reorderThreshold),
      shelfLifeDays: shelfLifeDays == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLifeDays),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      lastRestocked: lastRestocked == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRestocked),
      isDirty: Value(isDirty),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      clientUpdatedAt: Value(clientUpdatedAt),
    );
  }

  factory LocalInventoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalInventoryData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      ingredientName: serializer.fromJson<String>(json['ingredientName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      reorderThreshold: serializer.fromJson<double?>(json['reorderThreshold']),
      shelfLifeDays: serializer.fromJson<int?>(json['shelfLifeDays']),
      category: serializer.fromJson<String?>(json['category']),
      lastRestocked: serializer.fromJson<String?>(json['lastRestocked']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'ingredientName': serializer.toJson<String>(ingredientName),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'reorderThreshold': serializer.toJson<double?>(reorderThreshold),
      'shelfLifeDays': serializer.toJson<int?>(shelfLifeDays),
      'category': serializer.toJson<String?>(category),
      'lastRestocked': serializer.toJson<String?>(lastRestocked),
      'isDirty': serializer.toJson<bool>(isDirty),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
    };
  }

  LocalInventoryData copyWith(
          {String? id,
          String? userId,
          String? ingredientName,
          double? quantity,
          String? unit,
          Value<double?> reorderThreshold = const Value.absent(),
          Value<int?> shelfLifeDays = const Value.absent(),
          Value<String?> category = const Value.absent(),
          Value<String?> lastRestocked = const Value.absent(),
          bool? isDirty,
          Value<DateTime?> updatedAt = const Value.absent(),
          DateTime? clientUpdatedAt}) =>
      LocalInventoryData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        ingredientName: ingredientName ?? this.ingredientName,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        reorderThreshold: reorderThreshold.present
            ? reorderThreshold.value
            : this.reorderThreshold,
        shelfLifeDays:
            shelfLifeDays.present ? shelfLifeDays.value : this.shelfLifeDays,
        category: category.present ? category.value : this.category,
        lastRestocked:
            lastRestocked.present ? lastRestocked.value : this.lastRestocked,
        isDirty: isDirty ?? this.isDirty,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      );
  LocalInventoryData copyWithCompanion(LocalInventoryCompanion data) {
    return LocalInventoryData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      ingredientName: data.ingredientName.present
          ? data.ingredientName.value
          : this.ingredientName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      reorderThreshold: data.reorderThreshold.present
          ? data.reorderThreshold.value
          : this.reorderThreshold,
      shelfLifeDays: data.shelfLifeDays.present
          ? data.shelfLifeDays.value
          : this.shelfLifeDays,
      category: data.category.present ? data.category.value : this.category,
      lastRestocked: data.lastRestocked.present
          ? data.lastRestocked.value
          : this.lastRestocked,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalInventoryData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('ingredientName: $ingredientName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('reorderThreshold: $reorderThreshold, ')
          ..write('shelfLifeDays: $shelfLifeDays, ')
          ..write('category: $category, ')
          ..write('lastRestocked: $lastRestocked, ')
          ..write('isDirty: $isDirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      userId,
      ingredientName,
      quantity,
      unit,
      reorderThreshold,
      shelfLifeDays,
      category,
      lastRestocked,
      isDirty,
      updatedAt,
      clientUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalInventoryData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.ingredientName == this.ingredientName &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.reorderThreshold == this.reorderThreshold &&
          other.shelfLifeDays == this.shelfLifeDays &&
          other.category == this.category &&
          other.lastRestocked == this.lastRestocked &&
          other.isDirty == this.isDirty &&
          other.updatedAt == this.updatedAt &&
          other.clientUpdatedAt == this.clientUpdatedAt);
}

class LocalInventoryCompanion extends UpdateCompanion<LocalInventoryData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> ingredientName;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<double?> reorderThreshold;
  final Value<int?> shelfLifeDays;
  final Value<String?> category;
  final Value<String?> lastRestocked;
  final Value<bool> isDirty;
  final Value<DateTime?> updatedAt;
  final Value<DateTime> clientUpdatedAt;
  final Value<int> rowid;
  const LocalInventoryCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.ingredientName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.reorderThreshold = const Value.absent(),
    this.shelfLifeDays = const Value.absent(),
    this.category = const Value.absent(),
    this.lastRestocked = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalInventoryCompanion.insert({
    required String id,
    required String userId,
    required String ingredientName,
    required double quantity,
    required String unit,
    this.reorderThreshold = const Value.absent(),
    this.shelfLifeDays = const Value.absent(),
    this.category = const Value.absent(),
    this.lastRestocked = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        ingredientName = Value(ingredientName),
        quantity = Value(quantity),
        unit = Value(unit);
  static Insertable<LocalInventoryData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? ingredientName,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<double>? reorderThreshold,
    Expression<int>? shelfLifeDays,
    Expression<String>? category,
    Expression<String>? lastRestocked,
    Expression<bool>? isDirty,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? clientUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (ingredientName != null) 'ingredient_name': ingredientName,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (reorderThreshold != null) 'reorder_threshold': reorderThreshold,
      if (shelfLifeDays != null) 'shelf_life_days': shelfLifeDays,
      if (category != null) 'category': category,
      if (lastRestocked != null) 'last_restocked': lastRestocked,
      if (isDirty != null) 'is_dirty': isDirty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalInventoryCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? ingredientName,
      Value<double>? quantity,
      Value<String>? unit,
      Value<double?>? reorderThreshold,
      Value<int?>? shelfLifeDays,
      Value<String?>? category,
      Value<String?>? lastRestocked,
      Value<bool>? isDirty,
      Value<DateTime?>? updatedAt,
      Value<DateTime>? clientUpdatedAt,
      Value<int>? rowid}) {
    return LocalInventoryCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ingredientName: ingredientName ?? this.ingredientName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      reorderThreshold: reorderThreshold ?? this.reorderThreshold,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      category: category ?? this.category,
      lastRestocked: lastRestocked ?? this.lastRestocked,
      isDirty: isDirty ?? this.isDirty,
      updatedAt: updatedAt ?? this.updatedAt,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
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
    if (ingredientName.present) {
      map['ingredient_name'] = Variable<String>(ingredientName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (reorderThreshold.present) {
      map['reorder_threshold'] = Variable<double>(reorderThreshold.value);
    }
    if (shelfLifeDays.present) {
      map['shelf_life_days'] = Variable<int>(shelfLifeDays.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (lastRestocked.present) {
      map['last_restocked'] = Variable<String>(lastRestocked.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalInventoryCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('ingredientName: $ingredientName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('reorderThreshold: $reorderThreshold, ')
          ..write('shelfLifeDays: $shelfLifeDays, ')
          ..write('category: $category, ')
          ..write('lastRestocked: $lastRestocked, ')
          ..write('isDirty: $isDirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWaterLogsTable extends LocalWaterLogs
    with TableInfo<$LocalWaterLogsTable, LocalWaterLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWaterLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMlMeta =
      const VerificationMeta('amountMl');
  @override
  late final GeneratedColumn<int> amountMl = GeneratedColumn<int>(
      'amount_ml', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
      'date', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _loggedAtMeta =
      const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
      'logged_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _clientUpdatedAtMeta =
      const VerificationMeta('clientUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>('client_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        amountMl,
        date,
        loggedAt,
        isDirty,
        updatedAt,
        clientUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_water_logs';
  @override
  VerificationContext validateIntegrity(Insertable<LocalWaterLog> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('amount_ml')) {
      context.handle(_amountMlMeta,
          amountMl.isAcceptableOrUnknown(data['amount_ml']!, _amountMlMeta));
    } else if (isInserting) {
      context.missing(_amountMlMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(_loggedAtMeta,
          loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta));
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
          _clientUpdatedAtMeta,
          clientUpdatedAt.isAcceptableOrUnknown(
              data['client_updated_at']!, _clientUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWaterLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWaterLog(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      amountMl: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}amount_ml'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      loggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logged_at'])!,
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}client_updated_at'])!,
    );
  }

  @override
  $LocalWaterLogsTable createAlias(String alias) {
    return $LocalWaterLogsTable(attachedDatabase, alias);
  }
}

class LocalWaterLog extends DataClass implements Insertable<LocalWaterLog> {
  final String id;
  final String userId;
  final int amountMl;
  final String date;
  final String loggedAt;
  final bool isDirty;
  final DateTime? updatedAt;
  final DateTime clientUpdatedAt;
  const LocalWaterLog(
      {required this.id,
      required this.userId,
      required this.amountMl,
      required this.date,
      required this.loggedAt,
      required this.isDirty,
      this.updatedAt,
      required this.clientUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['amount_ml'] = Variable<int>(amountMl);
    map['date'] = Variable<String>(date);
    map['logged_at'] = Variable<String>(loggedAt);
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    return map;
  }

  LocalWaterLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalWaterLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      amountMl: Value(amountMl),
      date: Value(date),
      loggedAt: Value(loggedAt),
      isDirty: Value(isDirty),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      clientUpdatedAt: Value(clientUpdatedAt),
    );
  }

  factory LocalWaterLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWaterLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      amountMl: serializer.fromJson<int>(json['amountMl']),
      date: serializer.fromJson<String>(json['date']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'amountMl': serializer.toJson<int>(amountMl),
      'date': serializer.toJson<String>(date),
      'loggedAt': serializer.toJson<String>(loggedAt),
      'isDirty': serializer.toJson<bool>(isDirty),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
    };
  }

  LocalWaterLog copyWith(
          {String? id,
          String? userId,
          int? amountMl,
          String? date,
          String? loggedAt,
          bool? isDirty,
          Value<DateTime?> updatedAt = const Value.absent(),
          DateTime? clientUpdatedAt}) =>
      LocalWaterLog(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        amountMl: amountMl ?? this.amountMl,
        date: date ?? this.date,
        loggedAt: loggedAt ?? this.loggedAt,
        isDirty: isDirty ?? this.isDirty,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      );
  LocalWaterLog copyWithCompanion(LocalWaterLogsCompanion data) {
    return LocalWaterLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      date: data.date.present ? data.date.value : this.date,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWaterLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amountMl: $amountMl, ')
          ..write('date: $date, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('isDirty: $isDirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, amountMl, date, loggedAt, isDirty,
      updatedAt, clientUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWaterLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amountMl == this.amountMl &&
          other.date == this.date &&
          other.loggedAt == this.loggedAt &&
          other.isDirty == this.isDirty &&
          other.updatedAt == this.updatedAt &&
          other.clientUpdatedAt == this.clientUpdatedAt);
}

class LocalWaterLogsCompanion extends UpdateCompanion<LocalWaterLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> amountMl;
  final Value<String> date;
  final Value<String> loggedAt;
  final Value<bool> isDirty;
  final Value<DateTime?> updatedAt;
  final Value<DateTime> clientUpdatedAt;
  final Value<int> rowid;
  const LocalWaterLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.date = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWaterLogsCompanion.insert({
    required String id,
    required String userId,
    required int amountMl,
    required String date,
    required String loggedAt,
    this.isDirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        amountMl = Value(amountMl),
        date = Value(date),
        loggedAt = Value(loggedAt);
  static Insertable<LocalWaterLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? amountMl,
    Expression<String>? date,
    Expression<String>? loggedAt,
    Expression<bool>? isDirty,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? clientUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amountMl != null) 'amount_ml': amountMl,
      if (date != null) 'date': date,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (isDirty != null) 'is_dirty': isDirty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWaterLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? amountMl,
      Value<String>? date,
      Value<String>? loggedAt,
      Value<bool>? isDirty,
      Value<DateTime?>? updatedAt,
      Value<DateTime>? clientUpdatedAt,
      Value<int>? rowid}) {
    return LocalWaterLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amountMl: amountMl ?? this.amountMl,
      date: date ?? this.date,
      loggedAt: loggedAt ?? this.loggedAt,
      isDirty: isDirty ?? this.isDirty,
      updatedAt: updatedAt ?? this.updatedAt,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
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
    if (amountMl.present) {
      map['amount_ml'] = Variable<int>(amountMl.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWaterLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amountMl: $amountMl, ')
          ..write('date: $date, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('isDirty: $isDirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSyncQueueTable extends LocalSyncQueue
    with TableInfo<$LocalSyncQueueTable, LocalSyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetTableMeta =
      const VerificationMeta('targetTable');
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
      'target_table', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastErrorMeta =
      const VerificationMeta('lastError');
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
      'last_error', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _nextRetryAtMeta =
      const VerificationMeta('nextRetryAt');
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
      'next_retry_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        operation,
        targetTable,
        recordId,
        payloadJson,
        priority,
        retryCount,
        lastError,
        createdAt,
        nextRetryAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<LocalSyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('target_table')) {
      context.handle(
          _targetTableMeta,
          targetTable.isAcceptableOrUnknown(
              data['target_table']!, _targetTableMeta));
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('last_error')) {
      context.handle(_lastErrorMeta,
          lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
          _nextRetryAtMeta,
          nextRetryAt.isAcceptableOrUnknown(
              data['next_retry_at']!, _nextRetryAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalSyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      targetTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_table'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      lastError: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_error']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      nextRetryAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}next_retry_at']),
    );
  }

  @override
  $LocalSyncQueueTable createAlias(String alias) {
    return $LocalSyncQueueTable(attachedDatabase, alias);
  }
}

class LocalSyncQueueData extends DataClass
    implements Insertable<LocalSyncQueueData> {
  final int id;

  /// Type of operation: 'insert', 'update', 'delete'
  final String operation;

  /// Target table: 'meals', 'inventory', 'water'
  final String targetTable;

  /// The local ID of the record being synced
  final String recordId;

  /// JSON payload of the changes/record
  final String payloadJson;

  /// High priority tasks (like direct user actions) are processed first
  final int priority;

  /// Number of times this task has failed
  final int retryCount;

  /// Last error message if failed
  final String? lastError;
  final DateTime createdAt;

  /// When this task should be retried (for exponential backoff)
  final DateTime? nextRetryAt;
  const LocalSyncQueueData(
      {required this.id,
      required this.operation,
      required this.targetTable,
      required this.recordId,
      required this.payloadJson,
      required this.priority,
      required this.retryCount,
      this.lastError,
      required this.createdAt,
      this.nextRetryAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation'] = Variable<String>(operation);
    map['target_table'] = Variable<String>(targetTable);
    map['record_id'] = Variable<String>(recordId);
    map['payload_json'] = Variable<String>(payloadJson);
    map['priority'] = Variable<int>(priority);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    return map;
  }

  LocalSyncQueueCompanion toCompanion(bool nullToAbsent) {
    return LocalSyncQueueCompanion(
      id: Value(id),
      operation: Value(operation),
      targetTable: Value(targetTable),
      recordId: Value(recordId),
      payloadJson: Value(payloadJson),
      priority: Value(priority),
      retryCount: Value(retryCount),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
    );
  }

  factory LocalSyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      operation: serializer.fromJson<String>(json['operation']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      priority: serializer.fromJson<int>(json['priority']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operation': serializer.toJson<String>(operation),
      'targetTable': serializer.toJson<String>(targetTable),
      'recordId': serializer.toJson<String>(recordId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'priority': serializer.toJson<int>(priority),
      'retryCount': serializer.toJson<int>(retryCount),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
    };
  }

  LocalSyncQueueData copyWith(
          {int? id,
          String? operation,
          String? targetTable,
          String? recordId,
          String? payloadJson,
          int? priority,
          int? retryCount,
          Value<String?> lastError = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> nextRetryAt = const Value.absent()}) =>
      LocalSyncQueueData(
        id: id ?? this.id,
        operation: operation ?? this.operation,
        targetTable: targetTable ?? this.targetTable,
        recordId: recordId ?? this.recordId,
        payloadJson: payloadJson ?? this.payloadJson,
        priority: priority ?? this.priority,
        retryCount: retryCount ?? this.retryCount,
        lastError: lastError.present ? lastError.value : this.lastError,
        createdAt: createdAt ?? this.createdAt,
        nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
      );
  LocalSyncQueueData copyWithCompanion(LocalSyncQueueCompanion data) {
    return LocalSyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      operation: data.operation.present ? data.operation.value : this.operation,
      targetTable:
          data.targetTable.present ? data.targetTable.value : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      priority: data.priority.present ? data.priority.value : this.priority,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      nextRetryAt:
          data.nextRetryAt.present ? data.nextRetryAt.value : this.nextRetryAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSyncQueueData(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('priority: $priority, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, operation, targetTable, recordId,
      payloadJson, priority, retryCount, lastError, createdAt, nextRetryAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSyncQueueData &&
          other.id == this.id &&
          other.operation == this.operation &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.payloadJson == this.payloadJson &&
          other.priority == this.priority &&
          other.retryCount == this.retryCount &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt &&
          other.nextRetryAt == this.nextRetryAt);
}

class LocalSyncQueueCompanion extends UpdateCompanion<LocalSyncQueueData> {
  final Value<int> id;
  final Value<String> operation;
  final Value<String> targetTable;
  final Value<String> recordId;
  final Value<String> payloadJson;
  final Value<int> priority;
  final Value<int> retryCount;
  final Value<String?> lastError;
  final Value<DateTime> createdAt;
  final Value<DateTime?> nextRetryAt;
  const LocalSyncQueueCompanion({
    this.id = const Value.absent(),
    this.operation = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.priority = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
  });
  LocalSyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String operation,
    required String targetTable,
    required String recordId,
    required String payloadJson,
    this.priority = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
  })  : operation = Value(operation),
        targetTable = Value(targetTable),
        recordId = Value(recordId),
        payloadJson = Value(payloadJson);
  static Insertable<LocalSyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? operation,
    Expression<String>? targetTable,
    Expression<String>? recordId,
    Expression<String>? payloadJson,
    Expression<int>? priority,
    Expression<int>? retryCount,
    Expression<String>? lastError,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? nextRetryAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operation != null) 'operation': operation,
      if (targetTable != null) 'target_table': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (priority != null) 'priority': priority,
      if (retryCount != null) 'retry_count': retryCount,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
    });
  }

  LocalSyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? operation,
      Value<String>? targetTable,
      Value<String>? recordId,
      Value<String>? payloadJson,
      Value<int>? priority,
      Value<int>? retryCount,
      Value<String?>? lastError,
      Value<DateTime>? createdAt,
      Value<DateTime?>? nextRetryAt}) {
    return LocalSyncQueueCompanion(
      id: id ?? this.id,
      operation: operation ?? this.operation,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      payloadJson: payloadJson ?? this.payloadJson,
      priority: priority ?? this.priority,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operation: $operation, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('priority: $priority, ')
          ..write('retryCount: $retryCount, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('nextRetryAt: $nextRetryAt')
          ..write(')'))
        .toString();
  }
}

class $LocalShoppingListTable extends LocalShoppingList
    with TableInfo<$LocalShoppingListTable, LocalShoppingListData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalShoppingListTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ingredientNameMeta =
      const VerificationMeta('ingredientName');
  @override
  late final GeneratedColumn<String> ingredientName = GeneratedColumn<String>(
      'ingredient_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isPurchasedMeta =
      const VerificationMeta('isPurchased');
  @override
  late final GeneratedColumn<bool> isPurchased = GeneratedColumn<bool>(
      'is_purchased', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_purchased" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('manual'));
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _clientUpdatedAtMeta =
      const VerificationMeta('clientUpdatedAt');
  @override
  late final GeneratedColumn<DateTime> clientUpdatedAt =
      GeneratedColumn<DateTime>('client_updated_at', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        userId,
        ingredientName,
        quantity,
        unit,
        isPurchased,
        source,
        isDirty,
        updatedAt,
        clientUpdatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_shopping_list';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalShoppingListData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('ingredient_name')) {
      context.handle(
          _ingredientNameMeta,
          ingredientName.isAcceptableOrUnknown(
              data['ingredient_name']!, _ingredientNameMeta));
    } else if (isInserting) {
      context.missing(_ingredientNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('is_purchased')) {
      context.handle(
          _isPurchasedMeta,
          isPurchased.isAcceptableOrUnknown(
              data['is_purchased']!, _isPurchasedMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('client_updated_at')) {
      context.handle(
          _clientUpdatedAtMeta,
          clientUpdatedAt.isAcceptableOrUnknown(
              data['client_updated_at']!, _clientUpdatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalShoppingListData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalShoppingListData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      ingredientName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}ingredient_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      isPurchased: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_purchased'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
      clientUpdatedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}client_updated_at'])!,
    );
  }

  @override
  $LocalShoppingListTable createAlias(String alias) {
    return $LocalShoppingListTable(attachedDatabase, alias);
  }
}

class LocalShoppingListData extends DataClass
    implements Insertable<LocalShoppingListData> {
  final String id;
  final String userId;
  final String ingredientName;
  final double quantity;
  final String unit;
  final bool isPurchased;
  final String source;
  final bool isDirty;
  final DateTime? updatedAt;
  final DateTime clientUpdatedAt;
  const LocalShoppingListData(
      {required this.id,
      required this.userId,
      required this.ingredientName,
      required this.quantity,
      required this.unit,
      required this.isPurchased,
      required this.source,
      required this.isDirty,
      this.updatedAt,
      required this.clientUpdatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['ingredient_name'] = Variable<String>(ingredientName);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['is_purchased'] = Variable<bool>(isPurchased);
    map['source'] = Variable<String>(source);
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt);
    return map;
  }

  LocalShoppingListCompanion toCompanion(bool nullToAbsent) {
    return LocalShoppingListCompanion(
      id: Value(id),
      userId: Value(userId),
      ingredientName: Value(ingredientName),
      quantity: Value(quantity),
      unit: Value(unit),
      isPurchased: Value(isPurchased),
      source: Value(source),
      isDirty: Value(isDirty),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      clientUpdatedAt: Value(clientUpdatedAt),
    );
  }

  factory LocalShoppingListData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalShoppingListData(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      ingredientName: serializer.fromJson<String>(json['ingredientName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      isPurchased: serializer.fromJson<bool>(json['isPurchased']),
      source: serializer.fromJson<String>(json['source']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      clientUpdatedAt: serializer.fromJson<DateTime>(json['clientUpdatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'ingredientName': serializer.toJson<String>(ingredientName),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'isPurchased': serializer.toJson<bool>(isPurchased),
      'source': serializer.toJson<String>(source),
      'isDirty': serializer.toJson<bool>(isDirty),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'clientUpdatedAt': serializer.toJson<DateTime>(clientUpdatedAt),
    };
  }

  LocalShoppingListData copyWith(
          {String? id,
          String? userId,
          String? ingredientName,
          double? quantity,
          String? unit,
          bool? isPurchased,
          String? source,
          bool? isDirty,
          Value<DateTime?> updatedAt = const Value.absent(),
          DateTime? clientUpdatedAt}) =>
      LocalShoppingListData(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        ingredientName: ingredientName ?? this.ingredientName,
        quantity: quantity ?? this.quantity,
        unit: unit ?? this.unit,
        isPurchased: isPurchased ?? this.isPurchased,
        source: source ?? this.source,
        isDirty: isDirty ?? this.isDirty,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
        clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
      );
  LocalShoppingListData copyWithCompanion(LocalShoppingListCompanion data) {
    return LocalShoppingListData(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      ingredientName: data.ingredientName.present
          ? data.ingredientName.value
          : this.ingredientName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      isPurchased:
          data.isPurchased.present ? data.isPurchased.value : this.isPurchased,
      source: data.source.present ? data.source.value : this.source,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      clientUpdatedAt: data.clientUpdatedAt.present
          ? data.clientUpdatedAt.value
          : this.clientUpdatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalShoppingListData(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('ingredientName: $ingredientName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('source: $source, ')
          ..write('isDirty: $isDirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, ingredientName, quantity, unit,
      isPurchased, source, isDirty, updatedAt, clientUpdatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalShoppingListData &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.ingredientName == this.ingredientName &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.isPurchased == this.isPurchased &&
          other.source == this.source &&
          other.isDirty == this.isDirty &&
          other.updatedAt == this.updatedAt &&
          other.clientUpdatedAt == this.clientUpdatedAt);
}

class LocalShoppingListCompanion
    extends UpdateCompanion<LocalShoppingListData> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> ingredientName;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<bool> isPurchased;
  final Value<String> source;
  final Value<bool> isDirty;
  final Value<DateTime?> updatedAt;
  final Value<DateTime> clientUpdatedAt;
  final Value<int> rowid;
  const LocalShoppingListCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.ingredientName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.isPurchased = const Value.absent(),
    this.source = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalShoppingListCompanion.insert({
    required String id,
    required String userId,
    required String ingredientName,
    required double quantity,
    required String unit,
    this.isPurchased = const Value.absent(),
    this.source = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.clientUpdatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        ingredientName = Value(ingredientName),
        quantity = Value(quantity),
        unit = Value(unit);
  static Insertable<LocalShoppingListData> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? ingredientName,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<bool>? isPurchased,
    Expression<String>? source,
    Expression<bool>? isDirty,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? clientUpdatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (ingredientName != null) 'ingredient_name': ingredientName,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (isPurchased != null) 'is_purchased': isPurchased,
      if (source != null) 'source': source,
      if (isDirty != null) 'is_dirty': isDirty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (clientUpdatedAt != null) 'client_updated_at': clientUpdatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalShoppingListCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<String>? ingredientName,
      Value<double>? quantity,
      Value<String>? unit,
      Value<bool>? isPurchased,
      Value<String>? source,
      Value<bool>? isDirty,
      Value<DateTime?>? updatedAt,
      Value<DateTime>? clientUpdatedAt,
      Value<int>? rowid}) {
    return LocalShoppingListCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      ingredientName: ingredientName ?? this.ingredientName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isPurchased: isPurchased ?? this.isPurchased,
      source: source ?? this.source,
      isDirty: isDirty ?? this.isDirty,
      updatedAt: updatedAt ?? this.updatedAt,
      clientUpdatedAt: clientUpdatedAt ?? this.clientUpdatedAt,
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
    if (ingredientName.present) {
      map['ingredient_name'] = Variable<String>(ingredientName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (isPurchased.present) {
      map['is_purchased'] = Variable<bool>(isPurchased.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (clientUpdatedAt.present) {
      map['client_updated_at'] = Variable<DateTime>(clientUpdatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalShoppingListCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('ingredientName: $ingredientName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('isPurchased: $isPurchased, ')
          ..write('source: $source, ')
          ..write('isDirty: $isDirty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('clientUpdatedAt: $clientUpdatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocalMealsTable localMeals = $LocalMealsTable(this);
  late final $LocalInventoryTable localInventory = $LocalInventoryTable(this);
  late final $LocalWaterLogsTable localWaterLogs = $LocalWaterLogsTable(this);
  late final $LocalSyncQueueTable localSyncQueue = $LocalSyncQueueTable(this);
  late final $LocalShoppingListTable localShoppingList =
      $LocalShoppingListTable(this);
  late final MealDao mealDao = MealDao(this as AppDatabase);
  late final InventoryDao inventoryDao = InventoryDao(this as AppDatabase);
  late final WaterDao waterDao = WaterDao(this as AppDatabase);
  late final ShoppingDao shoppingDao = ShoppingDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        localMeals,
        localInventory,
        localWaterLogs,
        localSyncQueue,
        localShoppingList
      ];
}

typedef $$LocalMealsTableCreateCompanionBuilder = LocalMealsCompanion Function({
  required String id,
  required String userId,
  required String name,
  required String mealType,
  Value<String> status,
  required String date,
  Value<String?> ingredientsJson,
  Value<String?> nutritionalValuesJson,
  Value<String?> scheduledTime,
  Value<bool> isDirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> clientUpdatedAt,
  required String createdAt,
  Value<int> rowid,
});
typedef $$LocalMealsTableUpdateCompanionBuilder = LocalMealsCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> name,
  Value<String> mealType,
  Value<String> status,
  Value<String> date,
  Value<String?> ingredientsJson,
  Value<String?> nutritionalValuesJson,
  Value<String?> scheduledTime,
  Value<bool> isDirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> clientUpdatedAt,
  Value<String> createdAt,
  Value<int> rowid,
});

class $$LocalMealsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMealsTable> {
  $$LocalMealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingredientsJson => $composableBuilder(
      column: $table.ingredientsJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nutritionalValuesJson => $composableBuilder(
      column: $table.nutritionalValuesJson,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$LocalMealsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMealsTable> {
  $$LocalMealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingredientsJson => $composableBuilder(
      column: $table.ingredientsJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nutritionalValuesJson => $composableBuilder(
      column: $table.nutritionalValuesJson,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalMealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMealsTable> {
  $$LocalMealsTableAnnotationComposer({
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get ingredientsJson => $composableBuilder(
      column: $table.ingredientsJson, builder: (column) => column);

  GeneratedColumn<String> get nutritionalValuesJson => $composableBuilder(
      column: $table.nutritionalValuesJson, builder: (column) => column);

  GeneratedColumn<String> get scheduledTime => $composableBuilder(
      column: $table.scheduledTime, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalMealsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalMealsTable,
    LocalMeal,
    $$LocalMealsTableFilterComposer,
    $$LocalMealsTableOrderingComposer,
    $$LocalMealsTableAnnotationComposer,
    $$LocalMealsTableCreateCompanionBuilder,
    $$LocalMealsTableUpdateCompanionBuilder,
    (LocalMeal, BaseReferences<_$AppDatabase, $LocalMealsTable, LocalMeal>),
    LocalMeal,
    PrefetchHooks Function()> {
  $$LocalMealsTableTableManager(_$AppDatabase db, $LocalMealsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalMealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalMealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalMealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String?> ingredientsJson = const Value.absent(),
            Value<String?> nutritionalValuesJson = const Value.absent(),
            Value<String?> scheduledTime = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> clientUpdatedAt = const Value.absent(),
            Value<String> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalMealsCompanion(
            id: id,
            userId: userId,
            name: name,
            mealType: mealType,
            status: status,
            date: date,
            ingredientsJson: ingredientsJson,
            nutritionalValuesJson: nutritionalValuesJson,
            scheduledTime: scheduledTime,
            isDirty: isDirty,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String name,
            required String mealType,
            Value<String> status = const Value.absent(),
            required String date,
            Value<String?> ingredientsJson = const Value.absent(),
            Value<String?> nutritionalValuesJson = const Value.absent(),
            Value<String?> scheduledTime = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> clientUpdatedAt = const Value.absent(),
            required String createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalMealsCompanion.insert(
            id: id,
            userId: userId,
            name: name,
            mealType: mealType,
            status: status,
            date: date,
            ingredientsJson: ingredientsJson,
            nutritionalValuesJson: nutritionalValuesJson,
            scheduledTime: scheduledTime,
            isDirty: isDirty,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalMealsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalMealsTable,
    LocalMeal,
    $$LocalMealsTableFilterComposer,
    $$LocalMealsTableOrderingComposer,
    $$LocalMealsTableAnnotationComposer,
    $$LocalMealsTableCreateCompanionBuilder,
    $$LocalMealsTableUpdateCompanionBuilder,
    (LocalMeal, BaseReferences<_$AppDatabase, $LocalMealsTable, LocalMeal>),
    LocalMeal,
    PrefetchHooks Function()>;
typedef $$LocalInventoryTableCreateCompanionBuilder = LocalInventoryCompanion
    Function({
  required String id,
  required String userId,
  required String ingredientName,
  required double quantity,
  required String unit,
  Value<double?> reorderThreshold,
  Value<int?> shelfLifeDays,
  Value<String?> category,
  Value<String?> lastRestocked,
  Value<bool> isDirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> clientUpdatedAt,
  Value<int> rowid,
});
typedef $$LocalInventoryTableUpdateCompanionBuilder = LocalInventoryCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<String> ingredientName,
  Value<double> quantity,
  Value<String> unit,
  Value<double?> reorderThreshold,
  Value<int?> shelfLifeDays,
  Value<String?> category,
  Value<String?> lastRestocked,
  Value<bool> isDirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> clientUpdatedAt,
  Value<int> rowid,
});

class $$LocalInventoryTableFilterComposer
    extends Composer<_$AppDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get reorderThreshold => $composableBuilder(
      column: $table.reorderThreshold,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get shelfLifeDays => $composableBuilder(
      column: $table.shelfLifeDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastRestocked => $composableBuilder(
      column: $table.lastRestocked, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$LocalInventoryTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get reorderThreshold => $composableBuilder(
      column: $table.reorderThreshold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get shelfLifeDays => $composableBuilder(
      column: $table.shelfLifeDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastRestocked => $composableBuilder(
      column: $table.lastRestocked,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$LocalInventoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalInventoryTable> {
  $$LocalInventoryTableAnnotationComposer({
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

  GeneratedColumn<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get reorderThreshold => $composableBuilder(
      column: $table.reorderThreshold, builder: (column) => column);

  GeneratedColumn<int> get shelfLifeDays => $composableBuilder(
      column: $table.shelfLifeDays, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get lastRestocked => $composableBuilder(
      column: $table.lastRestocked, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt, builder: (column) => column);
}

class $$LocalInventoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalInventoryTable,
    LocalInventoryData,
    $$LocalInventoryTableFilterComposer,
    $$LocalInventoryTableOrderingComposer,
    $$LocalInventoryTableAnnotationComposer,
    $$LocalInventoryTableCreateCompanionBuilder,
    $$LocalInventoryTableUpdateCompanionBuilder,
    (
      LocalInventoryData,
      BaseReferences<_$AppDatabase, $LocalInventoryTable, LocalInventoryData>
    ),
    LocalInventoryData,
    PrefetchHooks Function()> {
  $$LocalInventoryTableTableManager(
      _$AppDatabase db, $LocalInventoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalInventoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalInventoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalInventoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> ingredientName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double?> reorderThreshold = const Value.absent(),
            Value<int?> shelfLifeDays = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> lastRestocked = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> clientUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalInventoryCompanion(
            id: id,
            userId: userId,
            ingredientName: ingredientName,
            quantity: quantity,
            unit: unit,
            reorderThreshold: reorderThreshold,
            shelfLifeDays: shelfLifeDays,
            category: category,
            lastRestocked: lastRestocked,
            isDirty: isDirty,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String ingredientName,
            required double quantity,
            required String unit,
            Value<double?> reorderThreshold = const Value.absent(),
            Value<int?> shelfLifeDays = const Value.absent(),
            Value<String?> category = const Value.absent(),
            Value<String?> lastRestocked = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> clientUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalInventoryCompanion.insert(
            id: id,
            userId: userId,
            ingredientName: ingredientName,
            quantity: quantity,
            unit: unit,
            reorderThreshold: reorderThreshold,
            shelfLifeDays: shelfLifeDays,
            category: category,
            lastRestocked: lastRestocked,
            isDirty: isDirty,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalInventoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalInventoryTable,
    LocalInventoryData,
    $$LocalInventoryTableFilterComposer,
    $$LocalInventoryTableOrderingComposer,
    $$LocalInventoryTableAnnotationComposer,
    $$LocalInventoryTableCreateCompanionBuilder,
    $$LocalInventoryTableUpdateCompanionBuilder,
    (
      LocalInventoryData,
      BaseReferences<_$AppDatabase, $LocalInventoryTable, LocalInventoryData>
    ),
    LocalInventoryData,
    PrefetchHooks Function()>;
typedef $$LocalWaterLogsTableCreateCompanionBuilder = LocalWaterLogsCompanion
    Function({
  required String id,
  required String userId,
  required int amountMl,
  required String date,
  required String loggedAt,
  Value<bool> isDirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> clientUpdatedAt,
  Value<int> rowid,
});
typedef $$LocalWaterLogsTableUpdateCompanionBuilder = LocalWaterLogsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<int> amountMl,
  Value<String> date,
  Value<String> loggedAt,
  Value<bool> isDirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> clientUpdatedAt,
  Value<int> rowid,
});

class $$LocalWaterLogsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalWaterLogsTable> {
  $$LocalWaterLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amountMl => $composableBuilder(
      column: $table.amountMl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$LocalWaterLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalWaterLogsTable> {
  $$LocalWaterLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amountMl => $composableBuilder(
      column: $table.amountMl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$LocalWaterLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalWaterLogsTable> {
  $$LocalWaterLogsTableAnnotationComposer({
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

  GeneratedColumn<int> get amountMl =>
      $composableBuilder(column: $table.amountMl, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt, builder: (column) => column);
}

class $$LocalWaterLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalWaterLogsTable,
    LocalWaterLog,
    $$LocalWaterLogsTableFilterComposer,
    $$LocalWaterLogsTableOrderingComposer,
    $$LocalWaterLogsTableAnnotationComposer,
    $$LocalWaterLogsTableCreateCompanionBuilder,
    $$LocalWaterLogsTableUpdateCompanionBuilder,
    (
      LocalWaterLog,
      BaseReferences<_$AppDatabase, $LocalWaterLogsTable, LocalWaterLog>
    ),
    LocalWaterLog,
    PrefetchHooks Function()> {
  $$LocalWaterLogsTableTableManager(
      _$AppDatabase db, $LocalWaterLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalWaterLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalWaterLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalWaterLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> amountMl = const Value.absent(),
            Value<String> date = const Value.absent(),
            Value<String> loggedAt = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> clientUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalWaterLogsCompanion(
            id: id,
            userId: userId,
            amountMl: amountMl,
            date: date,
            loggedAt: loggedAt,
            isDirty: isDirty,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required int amountMl,
            required String date,
            required String loggedAt,
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> clientUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalWaterLogsCompanion.insert(
            id: id,
            userId: userId,
            amountMl: amountMl,
            date: date,
            loggedAt: loggedAt,
            isDirty: isDirty,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalWaterLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalWaterLogsTable,
    LocalWaterLog,
    $$LocalWaterLogsTableFilterComposer,
    $$LocalWaterLogsTableOrderingComposer,
    $$LocalWaterLogsTableAnnotationComposer,
    $$LocalWaterLogsTableCreateCompanionBuilder,
    $$LocalWaterLogsTableUpdateCompanionBuilder,
    (
      LocalWaterLog,
      BaseReferences<_$AppDatabase, $LocalWaterLogsTable, LocalWaterLog>
    ),
    LocalWaterLog,
    PrefetchHooks Function()>;
typedef $$LocalSyncQueueTableCreateCompanionBuilder = LocalSyncQueueCompanion
    Function({
  Value<int> id,
  required String operation,
  required String targetTable,
  required String recordId,
  required String payloadJson,
  Value<int> priority,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime?> nextRetryAt,
});
typedef $$LocalSyncQueueTableUpdateCompanionBuilder = LocalSyncQueueCompanion
    Function({
  Value<int> id,
  Value<String> operation,
  Value<String> targetTable,
  Value<String> recordId,
  Value<String> payloadJson,
  Value<int> priority,
  Value<int> retryCount,
  Value<String?> lastError,
  Value<DateTime> createdAt,
  Value<DateTime?> nextRetryAt,
});

class $$LocalSyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => ColumnFilters(column));
}

class $$LocalSyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operation => $composableBuilder(
      column: $table.operation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastError => $composableBuilder(
      column: $table.lastError, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => ColumnOrderings(column));
}

class $$LocalSyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSyncQueueTable> {
  $$LocalSyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
      column: $table.targetTable, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
      column: $table.nextRetryAt, builder: (column) => column);
}

class $$LocalSyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalSyncQueueTable,
    LocalSyncQueueData,
    $$LocalSyncQueueTableFilterComposer,
    $$LocalSyncQueueTableOrderingComposer,
    $$LocalSyncQueueTableAnnotationComposer,
    $$LocalSyncQueueTableCreateCompanionBuilder,
    $$LocalSyncQueueTableUpdateCompanionBuilder,
    (
      LocalSyncQueueData,
      BaseReferences<_$AppDatabase, $LocalSyncQueueTable, LocalSyncQueueData>
    ),
    LocalSyncQueueData,
    PrefetchHooks Function()> {
  $$LocalSyncQueueTableTableManager(
      _$AppDatabase db, $LocalSyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<String> targetTable = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> nextRetryAt = const Value.absent(),
          }) =>
              LocalSyncQueueCompanion(
            id: id,
            operation: operation,
            targetTable: targetTable,
            recordId: recordId,
            payloadJson: payloadJson,
            priority: priority,
            retryCount: retryCount,
            lastError: lastError,
            createdAt: createdAt,
            nextRetryAt: nextRetryAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String operation,
            required String targetTable,
            required String recordId,
            required String payloadJson,
            Value<int> priority = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<String?> lastError = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> nextRetryAt = const Value.absent(),
          }) =>
              LocalSyncQueueCompanion.insert(
            id: id,
            operation: operation,
            targetTable: targetTable,
            recordId: recordId,
            payloadJson: payloadJson,
            priority: priority,
            retryCount: retryCount,
            lastError: lastError,
            createdAt: createdAt,
            nextRetryAt: nextRetryAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalSyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalSyncQueueTable,
    LocalSyncQueueData,
    $$LocalSyncQueueTableFilterComposer,
    $$LocalSyncQueueTableOrderingComposer,
    $$LocalSyncQueueTableAnnotationComposer,
    $$LocalSyncQueueTableCreateCompanionBuilder,
    $$LocalSyncQueueTableUpdateCompanionBuilder,
    (
      LocalSyncQueueData,
      BaseReferences<_$AppDatabase, $LocalSyncQueueTable, LocalSyncQueueData>
    ),
    LocalSyncQueueData,
    PrefetchHooks Function()>;
typedef $$LocalShoppingListTableCreateCompanionBuilder
    = LocalShoppingListCompanion Function({
  required String id,
  required String userId,
  required String ingredientName,
  required double quantity,
  required String unit,
  Value<bool> isPurchased,
  Value<String> source,
  Value<bool> isDirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> clientUpdatedAt,
  Value<int> rowid,
});
typedef $$LocalShoppingListTableUpdateCompanionBuilder
    = LocalShoppingListCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> ingredientName,
  Value<double> quantity,
  Value<String> unit,
  Value<bool> isPurchased,
  Value<String> source,
  Value<bool> isDirty,
  Value<DateTime?> updatedAt,
  Value<DateTime> clientUpdatedAt,
  Value<int> rowid,
});

class $$LocalShoppingListTableFilterComposer
    extends Composer<_$AppDatabase, $LocalShoppingListTable> {
  $$LocalShoppingListTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPurchased => $composableBuilder(
      column: $table.isPurchased, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnFilters(column));
}

class $$LocalShoppingListTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalShoppingListTable> {
  $$LocalShoppingListTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPurchased => $composableBuilder(
      column: $table.isPurchased, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt,
      builder: (column) => ColumnOrderings(column));
}

class $$LocalShoppingListTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalShoppingListTable> {
  $$LocalShoppingListTableAnnotationComposer({
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

  GeneratedColumn<String> get ingredientName => $composableBuilder(
      column: $table.ingredientName, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get isPurchased => $composableBuilder(
      column: $table.isPurchased, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get clientUpdatedAt => $composableBuilder(
      column: $table.clientUpdatedAt, builder: (column) => column);
}

class $$LocalShoppingListTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LocalShoppingListTable,
    LocalShoppingListData,
    $$LocalShoppingListTableFilterComposer,
    $$LocalShoppingListTableOrderingComposer,
    $$LocalShoppingListTableAnnotationComposer,
    $$LocalShoppingListTableCreateCompanionBuilder,
    $$LocalShoppingListTableUpdateCompanionBuilder,
    (
      LocalShoppingListData,
      BaseReferences<_$AppDatabase, $LocalShoppingListTable,
          LocalShoppingListData>
    ),
    LocalShoppingListData,
    PrefetchHooks Function()> {
  $$LocalShoppingListTableTableManager(
      _$AppDatabase db, $LocalShoppingListTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalShoppingListTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalShoppingListTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalShoppingListTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<String> ingredientName = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<bool> isPurchased = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> clientUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalShoppingListCompanion(
            id: id,
            userId: userId,
            ingredientName: ingredientName,
            quantity: quantity,
            unit: unit,
            isPurchased: isPurchased,
            source: source,
            isDirty: isDirty,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required String ingredientName,
            required double quantity,
            required String unit,
            Value<bool> isPurchased = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<DateTime> clientUpdatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalShoppingListCompanion.insert(
            id: id,
            userId: userId,
            ingredientName: ingredientName,
            quantity: quantity,
            unit: unit,
            isPurchased: isPurchased,
            source: source,
            isDirty: isDirty,
            updatedAt: updatedAt,
            clientUpdatedAt: clientUpdatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LocalShoppingListTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LocalShoppingListTable,
    LocalShoppingListData,
    $$LocalShoppingListTableFilterComposer,
    $$LocalShoppingListTableOrderingComposer,
    $$LocalShoppingListTableAnnotationComposer,
    $$LocalShoppingListTableCreateCompanionBuilder,
    $$LocalShoppingListTableUpdateCompanionBuilder,
    (
      LocalShoppingListData,
      BaseReferences<_$AppDatabase, $LocalShoppingListTable,
          LocalShoppingListData>
    ),
    LocalShoppingListData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalMealsTableTableManager get localMeals =>
      $$LocalMealsTableTableManager(_db, _db.localMeals);
  $$LocalInventoryTableTableManager get localInventory =>
      $$LocalInventoryTableTableManager(_db, _db.localInventory);
  $$LocalWaterLogsTableTableManager get localWaterLogs =>
      $$LocalWaterLogsTableTableManager(_db, _db.localWaterLogs);
  $$LocalSyncQueueTableTableManager get localSyncQueue =>
      $$LocalSyncQueueTableTableManager(_db, _db.localSyncQueue);
  $$LocalShoppingListTableTableManager get localShoppingList =>
      $$LocalShoppingListTableTableManager(_db, _db.localShoppingList);
}
