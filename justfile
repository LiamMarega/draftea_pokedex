# Run commands
run-dev:
    flutter run -t lib/main_development.dart --flavor development

run-stg:
    flutter run -t lib/main_staging.dart --flavor staging

run-prod:
    flutter run -t lib/main_production.dart --flavor production

# Build mobile (production)
build-mobile:
    read -p "Have you updated the pubspec version? (any key to continue)"
    echo
    just clean
    just codegen-build
    just i10n
    flutter build appbundle --split-debug-info=./ -t lib/main_production.dart --flavor production
    flutter build ipa -t lib/main_production.dart --flavor production

build-apk:
    flutter build apk --release --obfuscate --split-debug-info=./ -t lib/main_production.dart --flavor production

build-apk-stg:
    flutter build apk --release --obfuscate --split-debug-info=./ -t lib/main_staging.dart --flavor staging

build-apk-dev:
    flutter build apk --release --obfuscate --split-debug-info=./ -t lib/main_development.dart --flavor development

# Clean dependencies
clean:
    flutter clean
    flutter pub get

# Generated and wacth code with build runner
codegen-watch:
    flutter pub run build_runner watch

# Delete conflicting and generated code with build runner 
codegen-build-delete:
    dart run build_runner build --delete-conflicting-outputs

codegen-build:
    dart run build_runner build

# Delete conflicting and generated code with build runner 
codegen-build-tests:
    flutter pub run build_runner build -c test 

# Generate i10n
i10n:
    flutter pub run easy_localization:generate -S assets/translations -f keys -O lib/common/ui -o locale_keys.g.dart

