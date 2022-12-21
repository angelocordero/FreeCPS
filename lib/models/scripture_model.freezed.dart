// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scripture_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Scripture {
  ScriptureReference get scriptureRef => throw _privateConstructorUsedError;
  List<Verse>? get verses => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScriptureCopyWith<Scripture> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScriptureCopyWith<$Res> {
  factory $ScriptureCopyWith(Scripture value, $Res Function(Scripture) then) =
      _$ScriptureCopyWithImpl<$Res, Scripture>;
  @useResult
  $Res call({ScriptureReference scriptureRef, List<Verse>? verses});

  $ScriptureReferenceCopyWith<$Res> get scriptureRef;
}

/// @nodoc
class _$ScriptureCopyWithImpl<$Res, $Val extends Scripture>
    implements $ScriptureCopyWith<$Res> {
  _$ScriptureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scriptureRef = null,
    Object? verses = freezed,
  }) {
    return _then(_value.copyWith(
      scriptureRef: null == scriptureRef
          ? _value.scriptureRef
          : scriptureRef // ignore: cast_nullable_to_non_nullable
              as ScriptureReference,
      verses: freezed == verses
          ? _value.verses
          : verses // ignore: cast_nullable_to_non_nullable
              as List<Verse>?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ScriptureReferenceCopyWith<$Res> get scriptureRef {
    return $ScriptureReferenceCopyWith<$Res>(_value.scriptureRef, (value) {
      return _then(_value.copyWith(scriptureRef: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ScriptureCopyWith<$Res> implements $ScriptureCopyWith<$Res> {
  factory _$$_ScriptureCopyWith(
          _$_Scripture value, $Res Function(_$_Scripture) then) =
      __$$_ScriptureCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ScriptureReference scriptureRef, List<Verse>? verses});

  @override
  $ScriptureReferenceCopyWith<$Res> get scriptureRef;
}

/// @nodoc
class __$$_ScriptureCopyWithImpl<$Res>
    extends _$ScriptureCopyWithImpl<$Res, _$_Scripture>
    implements _$$_ScriptureCopyWith<$Res> {
  __$$_ScriptureCopyWithImpl(
      _$_Scripture _value, $Res Function(_$_Scripture) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scriptureRef = null,
    Object? verses = freezed,
  }) {
    return _then(_$_Scripture(
      scriptureRef: null == scriptureRef
          ? _value.scriptureRef
          : scriptureRef // ignore: cast_nullable_to_non_nullable
              as ScriptureReference,
      verses: freezed == verses
          ? _value._verses
          : verses // ignore: cast_nullable_to_non_nullable
              as List<Verse>?,
    ));
  }
}

/// @nodoc

class _$_Scripture implements _Scripture {
  const _$_Scripture({required this.scriptureRef, final List<Verse>? verses})
      : _verses = verses;

  @override
  final ScriptureReference scriptureRef;
  final List<Verse>? _verses;
  @override
  List<Verse>? get verses {
    final value = _verses;
    if (value == null) return null;
    if (_verses is EqualUnmodifiableListView) return _verses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Scripture(scriptureRef: $scriptureRef, verses: $verses)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Scripture &&
            (identical(other.scriptureRef, scriptureRef) ||
                other.scriptureRef == scriptureRef) &&
            const DeepCollectionEquality().equals(other._verses, _verses));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, scriptureRef, const DeepCollectionEquality().hash(_verses));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ScriptureCopyWith<_$_Scripture> get copyWith =>
      __$$_ScriptureCopyWithImpl<_$_Scripture>(this, _$identity);
}

abstract class _Scripture implements Scripture {
  const factory _Scripture(
      {required final ScriptureReference scriptureRef,
      final List<Verse>? verses}) = _$_Scripture;

  @override
  ScriptureReference get scriptureRef;
  @override
  List<Verse>? get verses;
  @override
  @JsonKey(ignore: true)
  _$$_ScriptureCopyWith<_$_Scripture> get copyWith =>
      throw _privateConstructorUsedError;
}
