// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anura_scanned_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AnuraScannedData _$AnuraScannedDataFromJson(Map<String, dynamic> json) {
  return _AnuraScannedData.fromJson(json);
}

/// @nodoc
mixin _$AnuraScannedData {
  Map<String, Channel>? get channels => throw _privateConstructorUsedError;
  AnuraError? get error => throw _privateConstructorUsedError;
  String? get measurementDataId => throw _privateConstructorUsedError;
  String? get measurementId => throw _privateConstructorUsedError;
  int? get multiplier => throw _privateConstructorUsedError;
  String? get statusId => throw _privateConstructorUsedError;

  /// Serializes this AnuraScannedData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnuraScannedData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnuraScannedDataCopyWith<AnuraScannedData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnuraScannedDataCopyWith<$Res> {
  factory $AnuraScannedDataCopyWith(
          AnuraScannedData value, $Res Function(AnuraScannedData) then) =
      _$AnuraScannedDataCopyWithImpl<$Res, AnuraScannedData>;
  @useResult
  $Res call(
      {Map<String, Channel>? channels,
      AnuraError? error,
      String? measurementDataId,
      String? measurementId,
      int? multiplier,
      String? statusId});

  $AnuraErrorCopyWith<$Res>? get error;
}

/// @nodoc
class _$AnuraScannedDataCopyWithImpl<$Res, $Val extends AnuraScannedData>
    implements $AnuraScannedDataCopyWith<$Res> {
  _$AnuraScannedDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnuraScannedData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = freezed,
    Object? error = freezed,
    Object? measurementDataId = freezed,
    Object? measurementId = freezed,
    Object? multiplier = freezed,
    Object? statusId = freezed,
  }) {
    return _then(_value.copyWith(
      channels: freezed == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as Map<String, Channel>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AnuraError?,
      measurementDataId: freezed == measurementDataId
          ? _value.measurementDataId
          : measurementDataId // ignore: cast_nullable_to_non_nullable
              as String?,
      measurementId: freezed == measurementId
          ? _value.measurementId
          : measurementId // ignore: cast_nullable_to_non_nullable
              as String?,
      multiplier: freezed == multiplier
          ? _value.multiplier
          : multiplier // ignore: cast_nullable_to_non_nullable
              as int?,
      statusId: freezed == statusId
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of AnuraScannedData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AnuraErrorCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $AnuraErrorCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnuraScannedDataImplCopyWith<$Res>
    implements $AnuraScannedDataCopyWith<$Res> {
  factory _$$AnuraScannedDataImplCopyWith(_$AnuraScannedDataImpl value,
          $Res Function(_$AnuraScannedDataImpl) then) =
      __$$AnuraScannedDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, Channel>? channels,
      AnuraError? error,
      String? measurementDataId,
      String? measurementId,
      int? multiplier,
      String? statusId});

  @override
  $AnuraErrorCopyWith<$Res>? get error;
}

/// @nodoc
class __$$AnuraScannedDataImplCopyWithImpl<$Res>
    extends _$AnuraScannedDataCopyWithImpl<$Res, _$AnuraScannedDataImpl>
    implements _$$AnuraScannedDataImplCopyWith<$Res> {
  __$$AnuraScannedDataImplCopyWithImpl(_$AnuraScannedDataImpl _value,
      $Res Function(_$AnuraScannedDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnuraScannedData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = freezed,
    Object? error = freezed,
    Object? measurementDataId = freezed,
    Object? measurementId = freezed,
    Object? multiplier = freezed,
    Object? statusId = freezed,
  }) {
    return _then(_$AnuraScannedDataImpl(
      channels: freezed == channels
          ? _value._channels
          : channels // ignore: cast_nullable_to_non_nullable
              as Map<String, Channel>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as AnuraError?,
      measurementDataId: freezed == measurementDataId
          ? _value.measurementDataId
          : measurementDataId // ignore: cast_nullable_to_non_nullable
              as String?,
      measurementId: freezed == measurementId
          ? _value.measurementId
          : measurementId // ignore: cast_nullable_to_non_nullable
              as String?,
      multiplier: freezed == multiplier
          ? _value.multiplier
          : multiplier // ignore: cast_nullable_to_non_nullable
              as int?,
      statusId: freezed == statusId
          ? _value.statusId
          : statusId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnuraScannedDataImpl implements _AnuraScannedData {
  const _$AnuraScannedDataImpl(
      {final Map<String, Channel>? channels,
      this.error,
      this.measurementDataId,
      this.measurementId,
      this.multiplier,
      this.statusId})
      : _channels = channels;

  factory _$AnuraScannedDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnuraScannedDataImplFromJson(json);

  final Map<String, Channel>? _channels;
  @override
  Map<String, Channel>? get channels {
    final value = _channels;
    if (value == null) return null;
    if (_channels is EqualUnmodifiableMapView) return _channels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final AnuraError? error;
  @override
  final String? measurementDataId;
  @override
  final String? measurementId;
  @override
  final int? multiplier;
  @override
  final String? statusId;

  @override
  String toString() {
    return 'AnuraScannedData(channels: $channels, error: $error, measurementDataId: $measurementDataId, measurementId: $measurementId, multiplier: $multiplier, statusId: $statusId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnuraScannedDataImpl &&
            const DeepCollectionEquality().equals(other._channels, _channels) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.measurementDataId, measurementDataId) ||
                other.measurementDataId == measurementDataId) &&
            (identical(other.measurementId, measurementId) ||
                other.measurementId == measurementId) &&
            (identical(other.multiplier, multiplier) ||
                other.multiplier == multiplier) &&
            (identical(other.statusId, statusId) ||
                other.statusId == statusId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_channels),
      error,
      measurementDataId,
      measurementId,
      multiplier,
      statusId);

  /// Create a copy of AnuraScannedData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnuraScannedDataImplCopyWith<_$AnuraScannedDataImpl> get copyWith =>
      __$$AnuraScannedDataImplCopyWithImpl<_$AnuraScannedDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnuraScannedDataImplToJson(
      this,
    );
  }
}

abstract class _AnuraScannedData implements AnuraScannedData {
  const factory _AnuraScannedData(
      {final Map<String, Channel>? channels,
      final AnuraError? error,
      final String? measurementDataId,
      final String? measurementId,
      final int? multiplier,
      final String? statusId}) = _$AnuraScannedDataImpl;

  factory _AnuraScannedData.fromJson(Map<String, dynamic> json) =
      _$AnuraScannedDataImpl.fromJson;

  @override
  Map<String, Channel>? get channels;
  @override
  AnuraError? get error;
  @override
  String? get measurementDataId;
  @override
  String? get measurementId;
  @override
  int? get multiplier;
  @override
  String? get statusId;

  /// Create a copy of AnuraScannedData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnuraScannedDataImplCopyWith<_$AnuraScannedDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Channel _$ChannelFromJson(Map<String, dynamic> json) {
  return _Channel.fromJson(json);
}

/// @nodoc
mixin _$Channel {
  List<int>? get dataList => throw _privateConstructorUsedError;
  List<Note>? get notes => throw _privateConstructorUsedError;

  /// Serializes this Channel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Channel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChannelCopyWith<Channel> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelCopyWith<$Res> {
  factory $ChannelCopyWith(Channel value, $Res Function(Channel) then) =
      _$ChannelCopyWithImpl<$Res, Channel>;
  @useResult
  $Res call({List<int>? dataList, List<Note>? notes});
}

/// @nodoc
class _$ChannelCopyWithImpl<$Res, $Val extends Channel>
    implements $ChannelCopyWith<$Res> {
  _$ChannelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Channel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataList = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      dataList: freezed == dataList
          ? _value.dataList
          : dataList // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChannelImplCopyWith<$Res> implements $ChannelCopyWith<$Res> {
  factory _$$ChannelImplCopyWith(
          _$ChannelImpl value, $Res Function(_$ChannelImpl) then) =
      __$$ChannelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<int>? dataList, List<Note>? notes});
}

/// @nodoc
class __$$ChannelImplCopyWithImpl<$Res>
    extends _$ChannelCopyWithImpl<$Res, _$ChannelImpl>
    implements _$$ChannelImplCopyWith<$Res> {
  __$$ChannelImplCopyWithImpl(
      _$ChannelImpl _value, $Res Function(_$ChannelImpl) _then)
      : super(_value, _then);

  /// Create a copy of Channel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataList = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$ChannelImpl(
      dataList: freezed == dataList
          ? _value._dataList
          : dataList // ignore: cast_nullable_to_non_nullable
              as List<int>?,
      notes: freezed == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<Note>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChannelImpl implements _Channel {
  const _$ChannelImpl({final List<int>? dataList, final List<Note>? notes})
      : _dataList = dataList,
        _notes = notes;

  factory _$ChannelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChannelImplFromJson(json);

  final List<int>? _dataList;
  @override
  List<int>? get dataList {
    final value = _dataList;
    if (value == null) return null;
    if (_dataList is EqualUnmodifiableListView) return _dataList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Note>? _notes;
  @override
  List<Note>? get notes {
    final value = _notes;
    if (value == null) return null;
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Channel(dataList: $dataList, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelImpl &&
            const DeepCollectionEquality().equals(other._dataList, _dataList) &&
            const DeepCollectionEquality().equals(other._notes, _notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_dataList),
      const DeepCollectionEquality().hash(_notes));

  /// Create a copy of Channel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelImplCopyWith<_$ChannelImpl> get copyWith =>
      __$$ChannelImplCopyWithImpl<_$ChannelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChannelImplToJson(
      this,
    );
  }
}

abstract class _Channel implements Channel {
  const factory _Channel({final List<int>? dataList, final List<Note>? notes}) =
      _$ChannelImpl;

  factory _Channel.fromJson(Map<String, dynamic> json) = _$ChannelImpl.fromJson;

  @override
  List<int>? get dataList;
  @override
  List<Note>? get notes;

  /// Create a copy of Channel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChannelImplCopyWith<_$ChannelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnuraError _$AnuraErrorFromJson(Map<String, dynamic> json) {
  return _AnuraError.fromJson(json);
}

/// @nodoc
mixin _$AnuraError {
  String? get code => throw _privateConstructorUsedError;
  Errors? get errors => throw _privateConstructorUsedError;

  /// Serializes this AnuraError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnuraError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnuraErrorCopyWith<AnuraError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnuraErrorCopyWith<$Res> {
  factory $AnuraErrorCopyWith(
          AnuraError value, $Res Function(AnuraError) then) =
      _$AnuraErrorCopyWithImpl<$Res, AnuraError>;
  @useResult
  $Res call({String? code, Errors? errors});

  $ErrorsCopyWith<$Res>? get errors;
}

/// @nodoc
class _$AnuraErrorCopyWithImpl<$Res, $Val extends AnuraError>
    implements $AnuraErrorCopyWith<$Res> {
  _$AnuraErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnuraError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? errors = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Errors?,
    ) as $Val);
  }

  /// Create a copy of AnuraError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ErrorsCopyWith<$Res>? get errors {
    if (_value.errors == null) {
      return null;
    }

    return $ErrorsCopyWith<$Res>(_value.errors!, (value) {
      return _then(_value.copyWith(errors: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AnuraErrorImplCopyWith<$Res>
    implements $AnuraErrorCopyWith<$Res> {
  factory _$$AnuraErrorImplCopyWith(
          _$AnuraErrorImpl value, $Res Function(_$AnuraErrorImpl) then) =
      __$$AnuraErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? code, Errors? errors});

  @override
  $ErrorsCopyWith<$Res>? get errors;
}

/// @nodoc
class __$$AnuraErrorImplCopyWithImpl<$Res>
    extends _$AnuraErrorCopyWithImpl<$Res, _$AnuraErrorImpl>
    implements _$$AnuraErrorImplCopyWith<$Res> {
  __$$AnuraErrorImplCopyWithImpl(
      _$AnuraErrorImpl _value, $Res Function(_$AnuraErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnuraError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? errors = freezed,
  }) {
    return _then(_$AnuraErrorImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      errors: freezed == errors
          ? _value.errors
          : errors // ignore: cast_nullable_to_non_nullable
              as Errors?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnuraErrorImpl implements _AnuraError {
  const _$AnuraErrorImpl({this.code, this.errors});

  factory _$AnuraErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnuraErrorImplFromJson(json);

  @override
  final String? code;
  @override
  final Errors? errors;

  @override
  String toString() {
    return 'AnuraError(code: $code, errors: $errors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnuraErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.errors, errors) || other.errors == errors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, errors);

  /// Create a copy of AnuraError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnuraErrorImplCopyWith<_$AnuraErrorImpl> get copyWith =>
      __$$AnuraErrorImplCopyWithImpl<_$AnuraErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnuraErrorImplToJson(
      this,
    );
  }
}

abstract class _AnuraError implements AnuraError {
  const factory _AnuraError({final String? code, final Errors? errors}) =
      _$AnuraErrorImpl;

  factory _AnuraError.fromJson(Map<String, dynamic> json) =
      _$AnuraErrorImpl.fromJson;

  @override
  String? get code;
  @override
  Errors? get errors;

  /// Create a copy of AnuraError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnuraErrorImplCopyWith<_$AnuraErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Errors _$ErrorsFromJson(Map<String, dynamic> json) {
  return _Errors.fromJson(json);
}

/// @nodoc
mixin _$Errors {
  /// Serializes this Errors to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorsCopyWith<$Res> {
  factory $ErrorsCopyWith(Errors value, $Res Function(Errors) then) =
      _$ErrorsCopyWithImpl<$Res, Errors>;
}

/// @nodoc
class _$ErrorsCopyWithImpl<$Res, $Val extends Errors>
    implements $ErrorsCopyWith<$Res> {
  _$ErrorsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Errors
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ErrorsImplCopyWith<$Res> {
  factory _$$ErrorsImplCopyWith(
          _$ErrorsImpl value, $Res Function(_$ErrorsImpl) then) =
      __$$ErrorsImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ErrorsImplCopyWithImpl<$Res>
    extends _$ErrorsCopyWithImpl<$Res, _$ErrorsImpl>
    implements _$$ErrorsImplCopyWith<$Res> {
  __$$ErrorsImplCopyWithImpl(
      _$ErrorsImpl _value, $Res Function(_$ErrorsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Errors
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$ErrorsImpl implements _Errors {
  const _$ErrorsImpl();

  factory _$ErrorsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorsImplFromJson(json);

  @override
  String toString() {
    return 'Errors()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ErrorsImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorsImplToJson(
      this,
    );
  }
}

abstract class _Errors implements Errors {
  const factory _Errors() = _$ErrorsImpl;

  factory _Errors.fromJson(Map<String, dynamic> json) = _$ErrorsImpl.fromJson;
}
