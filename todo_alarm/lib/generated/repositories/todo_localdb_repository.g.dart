// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../repositories/todo_localdb_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TodoLocalDbRepository)
const todoLocalDbRepositoryProvider = TodoLocalDbRepositoryProvider._();

final class TodoLocalDbRepositoryProvider
    extends
        $NotifierProvider<TodoLocalDbRepository, TodoLocalDbRepositoryImpl> {
  const TodoLocalDbRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoLocalDbRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoLocalDbRepositoryHash();

  @$internal
  @override
  TodoLocalDbRepository create() => TodoLocalDbRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoLocalDbRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoLocalDbRepositoryImpl>(value),
    );
  }
}

String _$todoLocalDbRepositoryHash() =>
    r'0a9cae2f22bf38e849904666746fc6569d3146c8';

abstract class _$TodoLocalDbRepository
    extends $Notifier<TodoLocalDbRepositoryImpl> {
  TodoLocalDbRepositoryImpl build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<TodoLocalDbRepositoryImpl, TodoLocalDbRepositoryImpl>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TodoLocalDbRepositoryImpl, TodoLocalDbRepositoryImpl>,
              TodoLocalDbRepositoryImpl,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
