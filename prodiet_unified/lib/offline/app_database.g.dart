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
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
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
        isSynced,
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
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
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
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
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
  final bool isSynced;
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
      required this.isSynced,
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
    map['is_synced'] = Variable<bool>(isSynced);
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
      isSynced: Value(isSynced),
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
      isSynced: serializer.fromJson<bool>(json['isSynced']),
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
      'isSynced': serializer.toJson<bool>(isSynced),
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
          bool? isSynced,
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
        isSynced: isSynced ?? this.isSynced,
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
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
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
          ..write('isSynced: $isSynced, ')
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
      isSynced,
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
          other.isSynced == this.isSynced &&
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
  final Value<bool> isSynced;
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
    this.isSynced = const Value.absent(),
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
    this.isSynced = const Value.absent(),
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
    Expression<bool>? isSynced,
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
      if (isSynced != null) 'is_synced': isSynced,
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
      Value<bool>? isSynced,
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
      isSynced: isSynced ?? this.isSynced,
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
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
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
          ..write('isSynced: $isSynced, ')
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
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
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
        isSynced
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
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
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
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
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
  final bool isSynced;
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
      required this.isSynced});
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
    map['is_synced'] = Variable<bool>(isSynced);
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
      isSynced: Value(isSynced),
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
      isSynced: serializer.fromJson<bool>(json['isSynced']),
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
      'isSynced': serializer.toJson<bool>(isSynced),
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
          bool? isSynced}) =>
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
        isSynced: isSynced ?? this.isSynced,
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
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
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
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, ingredientName, quantity, unit,
      reorderThreshold, shelfLifeDays, category, lastRestocked, isSynced);
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
          other.isSynced == this.isSynced);
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
  final Value<bool> isSynced;
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
    this.isSynced = const Value.absent(),
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
    this.isSynced = const Value.absent(),
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
    Expression<bool>? isSynced,
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
      if (isSynced != null) 'is_synced': isSynced,
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
      Value<bool>? isSynced,
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
      isSynced: isSynced ?? this.isSynced,
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
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
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
          ..write('isSynced: $isSynced, ')
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
  static const VerificationMeta _loggedAtMeta =
      const VerificationMeta('loggedAt');
  @override
  late final GeneratedColumn<String> loggedAt = GeneratedColumn<String>(
      'logged_at', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, userId, amountMl, loggedAt, isSynced];
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
    if (data.containsKey('logged_at')) {
      context.handle(_loggedAtMeta,
          loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta));
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
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
      loggedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}logged_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
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
  final String loggedAt;
  final bool isSynced;
  const LocalWaterLog(
      {required this.id,
      required this.userId,
      required this.amountMl,
      required this.loggedAt,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['amount_ml'] = Variable<int>(amountMl);
    map['logged_at'] = Variable<String>(loggedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  LocalWaterLogsCompanion toCompanion(bool nullToAbsent) {
    return LocalWaterLogsCompanion(
      id: Value(id),
      userId: Value(userId),
      amountMl: Value(amountMl),
      loggedAt: Value(loggedAt),
      isSynced: Value(isSynced),
    );
  }

  factory LocalWaterLog.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWaterLog(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      amountMl: serializer.fromJson<int>(json['amountMl']),
      loggedAt: serializer.fromJson<String>(json['loggedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'amountMl': serializer.toJson<int>(amountMl),
      'loggedAt': serializer.toJson<String>(loggedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  LocalWaterLog copyWith(
          {String? id,
          String? userId,
          int? amountMl,
          String? loggedAt,
          bool? isSynced}) =>
      LocalWaterLog(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        amountMl: amountMl ?? this.amountMl,
        loggedAt: loggedAt ?? this.loggedAt,
        isSynced: isSynced ?? this.isSynced,
      );
  LocalWaterLog copyWithCompanion(LocalWaterLogsCompanion data) {
    return LocalWaterLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amountMl: data.amountMl.present ? data.amountMl.value : this.amountMl,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWaterLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amountMl: $amountMl, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, amountMl, loggedAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalWaterLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amountMl == this.amountMl &&
          other.loggedAt == this.loggedAt &&
          other.isSynced == this.isSynced);
}

class LocalWaterLogsCompanion extends UpdateCompanion<LocalWaterLog> {
  final Value<String> id;
  final Value<String> userId;
  final Value<int> amountMl;
  final Value<String> loggedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const LocalWaterLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amountMl = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWaterLogsCompanion.insert({
    required String id,
    required String userId,
    required int amountMl,
    required String loggedAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        userId = Value(userId),
        amountMl = Value(amountMl),
        loggedAt = Value(loggedAt);
  static Insertable<LocalWaterLog> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<int>? amountMl,
    Expression<String>? loggedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amountMl != null) 'amount_ml': amountMl,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWaterLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? userId,
      Value<int>? amountMl,
      Value<String>? loggedAt,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return LocalWaterLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amountMl: amountMl ?? this.amountMl,
      loggedAt: loggedAt ?? this.loggedAt,
      isSynced: isSynced ?? this.isSynced,
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
    if (loggedAt.present) {
      map['logged_at'] = Variable<String>(loggedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
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
          ..write('loggedAt: $loggedAt, ')
          ..write('isSynced: $isSynced, ')
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
  late final MealDao mealDao = MealDao(this as AppDatabase);
  late final InventoryDao inventoryDao = InventoryDao(this as AppDatabase);
  late final WaterDao waterDao = WaterDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [localMeals, localInventory, localWaterLogs];
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
  Value<bool> isSynced,
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
  Value<bool> isSynced,
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

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

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
            Value<bool> isSynced = const Value.absent(),
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
            isSynced: isSynced,
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
            Value<bool> isSynced = const Value.absent(),
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
            isSynced: isSynced,
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
  Value<bool> isSynced,
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
  Value<bool> isSynced,
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

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
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
            Value<bool> isSynced = const Value.absent(),
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
            isSynced: isSynced,
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
            Value<bool> isSynced = const Value.absent(),
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
            isSynced: isSynced,
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
  required String loggedAt,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$LocalWaterLogsTableUpdateCompanionBuilder = LocalWaterLogsCompanion
    Function({
  Value<String> id,
  Value<String> userId,
  Value<int> amountMl,
  Value<String> loggedAt,
  Value<bool> isSynced,
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

  ColumnFilters<String> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get loggedAt => $composableBuilder(
      column: $table.loggedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
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
            Value<String> loggedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalWaterLogsCompanion(
            id: id,
            userId: userId,
            amountMl: amountMl,
            loggedAt: loggedAt,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String userId,
            required int amountMl,
            required String loggedAt,
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LocalWaterLogsCompanion.insert(
            id: id,
            userId: userId,
            amountMl: amountMl,
            loggedAt: loggedAt,
            isSynced: isSynced,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocalMealsTableTableManager get localMeals =>
      $$LocalMealsTableTableManager(_db, _db.localMeals);
  $$LocalInventoryTableTableManager get localInventory =>
      $$LocalInventoryTableTableManager(_db, _db.localInventory);
  $$LocalWaterLogsTableTableManager get localWaterLogs =>
      $$LocalWaterLogsTableTableManager(_db, _db.localWaterLogs);
}
