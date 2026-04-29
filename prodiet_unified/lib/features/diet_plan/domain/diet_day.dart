import 'package:freezed_annotation/freezed_annotation.dart';

part 'diet_day.freezed.dart';
part 'diet_day.g.dart';

@freezed
class DietDay with _$DietDay {
  const factory DietDay({
    required int dayNumber,
    required String breakfast,
    required String lunch,
    required String dinner,
    required String snacks,
  }) = _DietDay;

  factory DietDay.fromJson(Map<String, dynamic> json) => _$DietDayFromJson(json);
}
