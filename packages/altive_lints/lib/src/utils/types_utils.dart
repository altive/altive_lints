import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

/// Whether the given [type] is a widget type or its subclass.
bool hasWidgetType(DartType type) =>
    (isWidgetOrSubclass(type) ||
        _isIterable(type) ||
        _isList(type) ||
        _isFuture(type)) &&
    !(_isMultiProvider(type) ||
        _isSubclassOfInheritedProvider(type) ||
        _isIterableInheritedProvider(type) ||
        _isListInheritedProvider(type) ||
        _isFutureInheritedProvider(type));

/// Whether the given [type] is an iterable type or its supertype.
bool isIterable(DartType? type) =>
    _checkSelfOrSupertypes(type, (t) => t?.isDartCoreIterable ?? false);

/// Whether the given [type] is a nullable type.
bool isNullableType(DartType? type) =>
    type?.nullabilitySuffix == NullabilitySuffix.question;

/// Whether the given [type] is a widget or its subclass.
bool isWidgetOrSubclass(DartType? type) =>
    _isWidget(type) || _isSubclassOfWidget(type);

/// Whether the given [type] is a render object or its subclass.
bool isRenderObjectOrSubclass(DartType? type) =>
    _isRenderObject(type) || _isSubclassOfRenderObject(type);

/// Whether the given [type] is a render object widget or its subclass.
bool isRenderObjectWidgetOrSubclass(DartType? type) =>
    _isRenderObjectWidget(type) || _isSubclassOfRenderObjectWidget(type);

/// Whether the given [type] is a render object element or its subclass.
bool isRenderObjectElementOrSubclass(DartType? type) =>
    _isRenderObjectElement(type) || _isSubclassOfRenderObjectElement(type);

/// Whether the given [type] is a widget state or its subclass.
bool isWidgetStateOrSubclass(DartType? type) =>
    _isWidgetState(type) || _isSubclassOfWidgetState(type);

/// Whether the given [type] is a subclass of Listenable.
bool isSubclassOfListenable(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isListenable);

/// Whether the given [type] is a ListView widget.
bool isListViewWidget(DartType? type) => type?.getDisplayString() == 'ListView';

/// Whether the given [type] is a SingleChildScrollView widget.
bool isSingleChildScrollViewWidget(DartType? type) =>
    type?.getDisplayString() == 'SingleChildScrollView';

/// Whether the given [type] is a Column widget.
bool isColumnWidget(DartType? type) => type?.getDisplayString() == 'Column';

/// Whether the given [type] is a Row widget.
bool isRowWidget(DartType? type) => type?.getDisplayString() == 'Row';

/// Whether the given [type] is a Padding widget.
bool isPaddingWidget(DartType? type) => type?.getDisplayString() == 'Padding';

/// Whether the given [type] is a BuildContext.
bool isBuildContext(DartType? type) =>
    type?.getDisplayString() == 'BuildContext';

/// Whether the given [type] is a GameWidget.
bool isGameWidget(DartType? type) => type?.getDisplayString() == 'GameWidget';

/// Whether the given [type] matches [predicate] or its super-type.
bool _checkSelfOrSupertypes(
  DartType? type,
  bool Function(DartType?) predicate,
) =>
    predicate(type) ||
    (type is InterfaceType && type.allSupertypes.any(predicate));

bool _isWidget(DartType? type) => type?.getDisplayString() == 'Widget';

bool _isSubclassOfWidget(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isWidget);

// ignore: deprecated_member_use
bool _isWidgetState(DartType? type) => type?.element2?.displayName == 'State';

bool _isSubclassOfWidgetState(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isWidgetState);

bool _isIterable(DartType type) =>
    type.isDartCoreIterable &&
    type is InterfaceType &&
    isWidgetOrSubclass(type.typeArguments.firstOrNull);

bool _isList(DartType type) =>
    type.isDartCoreList &&
    type is InterfaceType &&
    isWidgetOrSubclass(type.typeArguments.firstOrNull);

bool _isFuture(DartType type) =>
    type.isDartAsyncFuture &&
    type is InterfaceType &&
    isWidgetOrSubclass(type.typeArguments.firstOrNull);

bool _isListenable(DartType type) => type.getDisplayString() == 'Listenable';

bool _isRenderObject(DartType? type) =>
    type?.getDisplayString() == 'RenderObject';

bool _isSubclassOfRenderObject(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isRenderObject);

bool _isRenderObjectWidget(DartType? type) =>
    type?.getDisplayString() == 'RenderObjectWidget';

bool _isSubclassOfRenderObjectWidget(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isRenderObjectWidget);

bool _isRenderObjectElement(DartType? type) =>
    type?.getDisplayString() == 'RenderObjectElement';

bool _isSubclassOfRenderObjectElement(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isRenderObjectElement);

bool _isMultiProvider(DartType? type) =>
    type?.getDisplayString() == 'MultiProvider';

bool _isSubclassOfInheritedProvider(DartType? type) =>
    type is InterfaceType && type.allSupertypes.any(_isInheritedProvider);

bool _isInheritedProvider(DartType? type) =>
    type != null && type.getDisplayString().startsWith('InheritedProvider<');

bool _isIterableInheritedProvider(DartType type) =>
    type.isDartCoreIterable &&
    type is InterfaceType &&
    _isSubclassOfInheritedProvider(type.typeArguments.firstOrNull);

bool _isListInheritedProvider(DartType type) =>
    type.isDartCoreList &&
    type is InterfaceType &&
    _isSubclassOfInheritedProvider(type.typeArguments.firstOrNull);

bool _isFutureInheritedProvider(DartType type) =>
    type.isDartAsyncFuture &&
    type is InterfaceType &&
    _isSubclassOfInheritedProvider(type.typeArguments.firstOrNull);

/// Whether the given [type] is a Iterable type or its subclass.
bool isIterableOrSubclass(DartType? type) =>
    _checkSelfOrSupertypes(type, (t) => t?.isDartCoreIterable ?? false);

/// Whether the given [type] is a List type or its subclass.
bool isListOrSubclass(DartType? type) =>
    _checkSelfOrSupertypes(type, (t) => t?.isDartCoreList ?? false);
