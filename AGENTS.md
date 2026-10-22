# Project Guidelines

## Project structure

- This is a Flutter chat app targeting Dart SDK `^3.8.1`; organize new code by feature under `lib/features/`.
- Within a feature, keep Firebase models, data sources, and repository implementations in `data/`; entities, abstract repositories, and use cases in `domain/`; and Cubits, pages, and feature widgets in `presentation/`.
- Place shared UI, Firebase platform options, and utilities in `lib/core/`.
- Keep presentation code dependent on use cases/repository abstractions, not Firebase SDK APIs.

## Dart and Flutter conventions

- Follow `analysis_options.yaml` and the `flutter_lints` rules.
- Use `dart format` for changed Dart files and prefer package imports such as `package:chatapp/...` for project code.
- Use Cubits for presentation state and keep Firebase Auth/Firestore operations in data sources.
- Handle asynchronous loading and errors explicitly; do not silently swallow Firebase or user-input failures.
- When adding or moving assets, update the asset declarations in `pubspec.yaml`.

## Validation

- Run `flutter analyze` after Dart changes.
- Run `flutter test` when tests are affected, and add or update focused tests for changed behavior.
