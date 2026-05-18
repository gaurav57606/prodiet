import 'dart:convert';
import 'dart:io';

void main() async {
  print('====================================================');
  print('PRODIET UNIFIED - RELEASE FLAVOR & ENV VALIDATOR');
  print('====================================================');

  bool hasCriticalError = false;

  // 1. Validate .env.json configuration
  final envFile = File('.env.json');
  if (!envFile.existsSync()) {
    print('❌ [CRITICAL] .env.json file is missing in project root!');
    hasCriticalError = true;
  } else {
    try {
      final content = envFile.readAsStringSync();
      final Map<String, dynamic> json = jsonDecode(content);

      print('✅ .env.json syntax is valid JSON.');

      // Check for required keys
      final requiredKeys = [
        'SUPABASE_URL',
        'SUPABASE_ANON_KEY',
        'GEMINI_API_KEY',
        'OPEN_FOOD_FACTS_BASE_URL'
      ];

      for (final key in requiredKeys) {
        if (!json.containsKey(key)) {
          print('❌ [CRITICAL] Required env key "$key" is missing!');
          hasCriticalError = true;
        } else {
          final String value = json[key]?.toString() ?? '';
          if (value.isEmpty) {
            print('❌ [CRITICAL] Env key "$key" is empty!');
            hasCriticalError = true;
          } else if (value.contains('YOUR_') || value.contains('your-')) {
            print('⚠️  [WARNING] Env key "$key" contains placeholder value: "$value"');
          } else {
            print('✅ Env key "$key" looks good.');
          }
        }
      }
    } catch (e) {
      print('❌ [CRITICAL] Failed to parse .env.json: $e');
      hasCriticalError = true;
    }
  }

  // 2. Validate pubspec.yaml configuration
  final pubspecFile = File('pubspec.yaml');
  if (!pubspecFile.existsSync()) {
    print('❌ [CRITICAL] pubspec.yaml is missing in project root!');
    hasCriticalError = true;
  } else {
    print('✅ pubspec.yaml exists.');
    final content = pubspecFile.readAsStringSync();

    // Verify critical configurations
    if (!content.contains('uses-material-design: true')) {
      print('❌ [CRITICAL] pubspec.yaml does not enable material design!');
      hasCriticalError = true;
    } else {
      print('✅ uses-material-design is enabled.');
    }

    // Verify assets folders exist on disk
    final assetFolderRegExp = RegExp(r'-\s+(assets\/[a-zA-Z0-9_\-\/]+)');
    final matches = assetFolderRegExp.allMatches(content);
    for (final match in matches) {
      final folderPath = match.group(1);
      if (folderPath != null && !folderPath.contains('.json')) {
        final dir = Directory(folderPath);
        if (!dir.existsSync()) {
          print('⚠️  [WARNING] Configured asset directory "$folderPath" does not exist on disk.');
        } else {
          print('✅ Configured asset directory "$folderPath" is present.');
        }
      }
    }
  }

  // 3. Android build file checking (Flavors, build tools)
  final androidBuildFile = File('android/app/build.gradle');
  if (androidBuildFile.existsSync()) {
    print('✅ android/app/build.gradle exists.');
    final gradleContent = androidBuildFile.readAsStringSync();
    if (gradleContent.contains('flavorDimensions')) {
      print('ℹ️  Android project contains flavor configuration.');
    } else {
      print('ℹ️  Android project uses standard default flavor.');
    }
  } else {
    print('⚠️  android/app/build.gradle not found (Web-only or non-Android environment).');
  }

  print('====================================================');
  if (hasCriticalError) {
    print('❌ VALIDATION FAILED with critical configuration errors!');
    exit(1);
  } else {
    print('🎉 VALIDATION SUCCESSFUL! The environment is ready for release.');
    exit(0);
  }
}
