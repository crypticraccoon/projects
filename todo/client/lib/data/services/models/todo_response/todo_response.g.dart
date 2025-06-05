// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoResponse _$TodoResponseFromJson(Map<String, dynamic> json) =>
    _TodoResponse(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      deadline: DateTime.parse(json['deadline'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      completedAt:
          json['completed_at'] == null
              ? null
              : DateTime.parse(json['completed_at'] as String),
      isCompleted: json['is_completed'] as bool,
    );

Map<String, dynamic> _$TodoResponseToJson(_TodoResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'deadline': instance.deadline.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'is_completed': instance.isCompleted,
    };
