import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';

part 'todo.g.dart';

/// TodoResponse model.
@freezed
abstract class TodoResponse with _$TodoResponse {
  const factory TodoResponse({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String title,
    required String body,
    required DateTime deadline,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'completed_at') DateTime? completedAt,
    @JsonKey(name: 'is_completed') required bool isCompleted,
  }) = _TodoResponse;

  factory TodoResponse.fromJson(Map<String, Object?> json) =>
      _$TodoResponseFromJson(json);
}
