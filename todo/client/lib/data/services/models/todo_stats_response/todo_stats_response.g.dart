// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoStatsResponse _$TodoStatsResponseFromJson(Map<String, dynamic> json) =>
    _TodoStatsResponse(
      complete: (json['complete'] as num).toInt(),
      inProgress: (json['in_progress'] as num).toInt(),
    );

Map<String, dynamic> _$TodoStatsResponseToJson(_TodoStatsResponse instance) =>
    <String, dynamic>{
      'complete': instance.complete,
      'in_progress': instance.inProgress,
    };
