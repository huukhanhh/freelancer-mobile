import 'package:flutter/widgets.dart';
import 'package:workly/app/app_dependencies.dart';
import 'package:workly/app/workly_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(WorklyApp(dependencies: AppDependencies.mock()));
}
