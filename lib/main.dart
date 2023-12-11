import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'MyApp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Necessary initialization for package:media_kit.
  MediaKit.ensureInitialized();
  runApp(const MyApp());
}
