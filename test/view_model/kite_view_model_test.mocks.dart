// Mocks generated by Mockito 5.4.5 from annotations
// in kite/test/view_model/kite_view_model_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:flutter/foundation.dart' as _i3;
import 'package:kite/data/kite_service.dart' as _i2;
import 'package:kite/data/models/category.dart' as _i5;
import 'package:kite/data/models/content.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeDateTime_0 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_0(Object parent, Invocation parentInvocation) : super(parent, parentInvocation);
}

/// A class which mocks [KiteService].
///
/// See the documentation for Mockito's code generation for more information.
class MockKiteService extends _i1.Mock implements _i2.KiteService {
  @override
  _i3.ValueGetter<DateTime> get currentTime =>
      (super.noSuchMethod(
            Invocation.getter(#currentTime),
            returnValue: () => _FakeDateTime_0(this, Invocation.getter(#currentTime)),
            returnValueForMissingStub: () => _FakeDateTime_0(this, Invocation.getter(#currentTime)),
          )
          as _i3.ValueGetter<DateTime>);

  @override
  set currentTime(_i3.ValueGetter<DateTime>? _currentTime) => super.noSuchMethod(
    Invocation.setter(#currentTime, _currentTime),
    returnValueForMissingStub: null,
  );

  @override
  _i4.Future<List<_i5.Category>?> getCategories() =>
      (super.noSuchMethod(
            Invocation.method(#getCategories, []),
            returnValue: _i4.Future<List<_i5.Category>?>.value(),
            returnValueForMissingStub: _i4.Future<List<_i5.Category>?>.value(),
          )
          as _i4.Future<List<_i5.Category>?>);

  @override
  _i4.Future<List<_i6.Content>?> getCategoryContentFor(
    _i5.Category? category,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getCategoryContentFor, [category]),
            returnValue: _i4.Future<List<_i6.Content>?>.value(),
            returnValueForMissingStub: _i4.Future<List<_i6.Content>?>.value(),
          )
          as _i4.Future<List<_i6.Content>?>);
}
