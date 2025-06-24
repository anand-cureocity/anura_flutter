// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anura_scanned_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnuraScannedDataImpl _$$AnuraScannedDataImplFromJson(
        Map<String, dynamic> json) =>
    _$AnuraScannedDataImpl(
      channels: (json['channels'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Channel.fromJson(e as Map<String, dynamic>)),
      ),
      error: json['error'] == null
          ? null
          : AnuraError.fromJson(json['error'] as Map<String, dynamic>),
      measurementDataId: json['measurementDataId'] as String?,
      measurementId: json['measurementId'] as String?,
      multiplier: (json['multiplier'] as num?)?.toInt(),
      statusId: json['statusId'] as String?,
    );

Map<String, dynamic> _$$AnuraScannedDataImplToJson(
        _$AnuraScannedDataImpl instance) =>
    <String, dynamic>{
      'channels': instance.channels,
      'error': instance.error,
      'measurementDataId': instance.measurementDataId,
      'measurementId': instance.measurementId,
      'multiplier': instance.multiplier,
      'statusId': instance.statusId,
    };

_$ChannelImpl _$$ChannelImplFromJson(Map<String, dynamic> json) =>
    _$ChannelImpl(
      dataList: (json['dataList'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      notes: (json['notes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$NoteEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$$ChannelImplToJson(_$ChannelImpl instance) =>
    <String, dynamic>{
      'dataList': instance.dataList,
      'notes': instance.notes?.map((e) => _$NoteEnumMap[e]!).toList(),
    };

const _$NoteEnumMap = {
  Note.NOTE_DEGRADED_ACCURACY: 'NOTE_DEGRADED_ACCURACY',
  Note.NOTE_MISSING_MEDICAL_INFO: 'NOTE_MISSING_MEDICAL_INFO',
};

_$AnuraErrorImpl _$$AnuraErrorImplFromJson(Map<String, dynamic> json) =>
    _$AnuraErrorImpl(
      code: json['code'] as String?,
      errors: json['errors'] == null
          ? null
          : Errors.fromJson(json['errors'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AnuraErrorImplToJson(_$AnuraErrorImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'errors': instance.errors,
    };

_$ErrorsImpl _$$ErrorsImplFromJson(Map<String, dynamic> json) => _$ErrorsImpl();

Map<String, dynamic> _$$ErrorsImplToJson(_$ErrorsImpl instance) =>
    <String, dynamic>{};
