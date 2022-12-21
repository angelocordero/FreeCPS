// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scripture_reference_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ScriptureReference {
  String? get translation => throw _privateConstructorUsedError;
  String? get translationName => throw _privateConstructorUsedError;
  String? get book => throw _privateConstructorUsedError;
  int? get chapter => throw _privateConstructorUsedError;
  String? get verse => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScriptureReferenceCopyWith<ScriptureReference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScriptureReferenceCopyWith<$Res> {
  factory $ScriptureReferenceCopyWith(
          ScriptureReference value, $Res Function(ScriptureReference) then) =
      _$ScriptureReferenceCopyWithImpl<$Res, ScriptureReference>;
  @useResult
  $Res call(
      {String? translation,
      String? translationName,
      String? book,
      int? chapter,
      String? verse});
}

/// @nodoc
class _$ScriptureReferenceCopyWithImpl<$Res, $Val extends ScriptureReference>
    implements $ScriptureReferenceCopyWith<$Res> {
  _$ScriptureReferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? translation = freezed,
    Object? translationName = freezed,
    Object? book = freezed,
    Object? chapter = freezed,
    Object? verse = freezed,
  }) {
    return _then(_value.copyWith(
      translation: freezed == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String?,
      translationName: freezed == translationName
          ? _value.translationName
          : translationName // ignore: cast_nullable_to_non_nullable
              as String?,
      book: freezed == book
          ? _value.book
          : book // ignore: cast_nullable_to_non_nullable
              as String?,
      chapter: freezed == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int?,
      verse: freezed == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ScriptureReferenceCopyWith<$Res>
    implements $ScriptureReferenceCopyWith<$Res> {
  factory _$$_ScriptureReferenceCopyWith(_$_ScriptureReference value,
          $Res Function(_$_ScriptureReference) then) =
      __$$_ScriptureReferenceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? translation,
      String? translationName,
      String? book,
      int? chapter,
      String? verse});
}

/// @nodoc
class __$$_ScriptureReferenceCopyWithImpl<$Res>
    extends _$ScriptureReferenceCopyWithImpl<$Res, _$_ScriptureReference>
    implements _$$_ScriptureReferenceCopyWith<$Res> {
  __$$_ScriptureReferenceCopyWithImpl(
      _$_ScriptureReference _value, $Res Function(_$_ScriptureReference) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? translation = freezed,
    Object? translationName = freezed,
    Object? book = freezed,
    Object? chapter = freezed,
    Object? verse = freezed,
  }) {
    return _then(_$_ScriptureReference(
      translation: freezed == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as String?,
      translationName: freezed == translationName
          ? _value.translationName
          : translationName // ignore: cast_nullable_to_non_nullable
              as String?,
      book: freezed == book
          ? _value.book
          : book // ignore: cast_nullable_to_non_nullable
              as String?,
      chapter: freezed == chapter
          ? _value.chapter
          : chapter // ignore: cast_nullable_to_non_nullable
              as int?,
      verse: freezed == verse
          ? _value.verse
          : verse // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ScriptureReference implements _ScriptureReference {
  const _$_ScriptureReference(
      {this.translation,
      this.translationName,
      this.book,
      this.chapter,
      this.verse});

  @override
  final String? translation;
  @override
  final String? translationName;
  @override
  final String? book;
  @override
  final int? chapter;
  @override
  final String? verse;

  @override
  String toString() {
    return 'ScriptureReference(translation: $translation, translationName: $translationName, book: $book, chapter: $chapter, verse: $verse)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ScriptureReference &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.translationName, translationName) ||
                other.translationName == translationName) &&
            (identical(other.book, book) || other.book == book) &&
            (identical(other.chapter, chapter) || other.chapter == chapter) &&
            (identical(other.verse, verse) || other.verse == verse));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, translation, translationName, book, chapter, verse);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ScriptureReferenceCopyWith<_$_ScriptureReference> get copyWith =>
      __$$_ScriptureReferenceCopyWithImpl<_$_ScriptureReference>(
          this, _$identity);
}

abstract class _ScriptureReference implements ScriptureReference {
  const factory _ScriptureReference(
      {final String? translation,
      final String? translationName,
      final String? book,
      final int? chapter,
      final String? verse}) = _$_ScriptureReference;

  @override
  String? get translation;
  @override
  String? get translationName;
  @override
  String? get book;
  @override
  int? get chapter;
  @override
  String? get verse;
  @override
  @JsonKey(ignore: true)
  _$$_ScriptureReferenceCopyWith<_$_ScriptureReference> get copyWith =>
      throw _privateConstructorUsedError;
}
