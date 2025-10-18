// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../repositories/speech_to_text_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SpeechToTextRepository)
const speechToTextRepositoryProvider = SpeechToTextRepositoryProvider._();

final class SpeechToTextRepositoryProvider
    extends
        $NotifierProvider<SpeechToTextRepository, SpeechToTextRepositoryImpl> {
  const SpeechToTextRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechToTextRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechToTextRepositoryHash();

  @$internal
  @override
  SpeechToTextRepository create() => SpeechToTextRepository();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeechToTextRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SpeechToTextRepositoryImpl>(value),
    );
  }
}

String _$speechToTextRepositoryHash() =>
    r'a95312a5cd2e63c7d5ed1f38429429c30df88aad';

abstract class _$SpeechToTextRepository
    extends $Notifier<SpeechToTextRepositoryImpl> {
  SpeechToTextRepositoryImpl build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<SpeechToTextRepositoryImpl, SpeechToTextRepositoryImpl>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                SpeechToTextRepositoryImpl,
                SpeechToTextRepositoryImpl
              >,
              SpeechToTextRepositoryImpl,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
