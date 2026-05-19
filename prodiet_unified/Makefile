ENV_FILE = .env.json

run:
	flutter run --dart-define-from-file=$(ENV_FILE)

run-profile:
	flutter run --profile --dart-define-from-file=$(ENV_FILE)

build-debug:
	flutter build apk --dart-define-from-file=$(ENV_FILE)

build-release:
	flutter build apk --release --dart-define-from-file=$(ENV_FILE)

build-aab:
	flutter build appbundle --release --dart-define-from-file=$(ENV_FILE)

build-ios:
	flutter build ios --release --dart-define-from-file=$(ENV_FILE)

analyze:
	flutter analyze lib/

clean:
	flutter clean && flutter pub get
