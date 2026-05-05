import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode { light, dark, amoled }

final themeModeProvider = StateProvider<AppThemeMode>((ref) => AppThemeMode.amoled);

