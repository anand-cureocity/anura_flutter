import 'package:freezed_annotation/freezed_annotation.dart';

part 'anura_scanned_data.freezed.dart';
part 'anura_scanned_data.g.dart';

@Freezed()
class AnuraScannedData with _$AnuraScannedData {
  const factory AnuraScannedData({
    Map<String, Channel>? channels,
    AnuraError? error,
    String? measurementDataId,
    String? measurementId,
    int? multiplier,
    String? statusId,
  }) = _AnuraScannedData;


  factory AnuraScannedData.fromJson(Map<String, dynamic> json) {
    return _$AnuraScannedDataFromJson(json);
  }
}

@Freezed()
class Channel with _$Channel {
  const factory Channel({
    List<int>? dataList,
    List<Note>? notes,
  }) = _Channel;

  factory Channel.fromJson(Map<String, dynamic> json) =>
      _$ChannelFromJson(json);
}

@JsonEnum()
enum Note {
  @JsonValue("NOTE_DEGRADED_ACCURACY")
  NOTE_DEGRADED_ACCURACY,

  @JsonValue("NOTE_MISSING_MEDICAL_INFO")
  NOTE_MISSING_MEDICAL_INFO,
}

@Freezed()
class AnuraError with _$AnuraError {
  const factory AnuraError({
    String? code,
    Errors? errors,
  }) = _AnuraError;

  factory AnuraError.fromJson(Map<String, dynamic> json) =>
      _$AnuraErrorFromJson(json);
}

@Freezed()
class Errors with _$Errors {
  const factory Errors() = _Errors;

  factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);
}
