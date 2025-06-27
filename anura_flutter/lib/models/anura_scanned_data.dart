class AnuraScannedData {
  final ErrorInfo error;
  final String measurementId;
  final String measurementDataId;
  final double multiplier;
  final String statusId;
  final Map<String, ChannelData> channels;

  AnuraScannedData({
    required this.error,
    required this.measurementId,
    required this.measurementDataId,
    required this.multiplier,
    required this.statusId,
    required this.channels,
  });

  factory AnuraScannedData.fromJson(Map<String, dynamic> json) {
    // Handle case differences in field names
    final errorJson = ((json['error'] ?? json['Error']) as Map?)?.map(
          (key, value) => MapEntry(key.toString(), value),
        ) ??
        {};
    final measurementId = json['measurementID'] ?? json['MeasurementID'];
    final measurementDataId =
        json['measurementDataID'] ?? json['MeasurementDataID'];
    final multiplier = json['multiplier'] ?? json['Multiplier'];
    final statusId = json['statusID'] ?? json['StatusID'];
    final channelsJson = json['channels'] ?? json['Channels'];

    return AnuraScannedData(
      error: ErrorInfo.fromJson(errorJson),
      measurementId: measurementId.toString(),
      measurementDataId: measurementDataId.toString(),
      multiplier:
          multiplier is int ? multiplier.toDouble() : multiplier as double,
      statusId: statusId.toString(),
      channels: (channelsJson as Map).map(
        (key, value) => MapEntry(
          key.toString(),
          ChannelData.fromJson(
            value as Map<String, dynamic>,
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "error": error.toJson(),
      "measurementID": measurementId,
      "measurementDataID": measurementDataId,
      "multiplier": multiplier.toInt(), // Original JSON has it as int
      "statusID": statusId,
      "channels": channels.map((key, value) => MapEntry(key, value.toJson())),
    };
  }

  @override
  String toString() {
    return 'AnuraScannedData(\n'
        '  error: $error,\n'
        '  measurementId: $measurementId,\n'
        '  measurementDataId: $measurementDataId,\n'
        '  multiplier: $multiplier,\n'
        '  statusId: $statusId,\n'
        '  channels: $channels\n'
        ')';
  }
}

class ErrorInfo {
  final String code;
  final Map<String, dynamic>? errors;

  ErrorInfo({
    required this.code,
    this.errors,
  });

  factory ErrorInfo.fromJson(Map<String, dynamic> json) {
    return ErrorInfo(
      code: (json['code'] ?? json['Code']).toString(),
      errors: (json['Errors'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), value),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "code": code,
    };
    if (errors != null) {
      json["errors"] = errors;
    }
    return json;
  }

  @override
  String toString() {
    return 'ErrorInfo(code: $code, errors: $errors)';
  }
}

class ChannelData {
  final List<double> data;
  final List<String>? notes;
  final String? channel; // Only present in iOS

  ChannelData({
    required this.data,
    this.notes,
    this.channel,
  });

  factory ChannelData.fromJson(Map<String, dynamic> json) {
    // Handle different data field names
    final dataList = json['dataList'] ?? json['Data'] ?? <dynamic>[];
    final notes = json['notes'] ?? json['Notes'];
    final channel = json['Channel'];

    return ChannelData(
      data: List<double>.from(
        (dataList as List).map((x) => x is int ? x.toDouble() : x),
      ),
      notes: notes != null ? List<String>.from(notes as List) : null,
      channel: channel?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      "data": data.map((e) => e.toInt()).toList(), // Original JSON has ints
    };
    if (notes != null) {
      json["notes"] = notes;
    }
    if (channel != null) {
      json["Channel"] = channel;
    }
    return json;
  }

  @override
  String toString() {
    return 'ChannelData(data: $data, notes: $notes, channel: $channel)';
  }
}
