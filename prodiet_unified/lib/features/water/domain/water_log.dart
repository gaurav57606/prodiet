import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_log.freezed.dart';
part 'water_log.g.dart';

@freezed
class WaterLog with _$WaterLog {
  const factory WaterLog({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'amount_ml') required int amountMl,
    @JsonKey(name: 'logged_at') required DateTime loggedAt,
    required DateTime date,
  }) = _WaterLog;

  factory WaterLog.fromJson(Map<String, dynamic> json) => _$WaterLogFromJson(json);
}
