import 'package:freezed_annotation/freezed_annotation.dart';

part 'weight_entry.freezed.dart';
part 'weight_entry.g.dart';

@freezed
class WeightEntry with _$WeightEntry {
  const factory WeightEntry({
    required String id,
    required String userId,
    required double weightKg,
    required DateTime loggedAt,
  }) = _WeightEntry;

  factory WeightEntry.fromJson(Map<String, dynamic> json) =>
      _$WeightEntryFromJson(json);
}
