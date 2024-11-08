import 'package:get_it/get_it.dart';
import 'package:realtime_innovations/data/local/app_database.dart';

import 'features/employee/blocs/bloc.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final appDatabase = await AppDatabase.create();
  locator.registerSingleton<AppDatabase>(appDatabase);

  locator.registerFactory(() => EmployeeCubit());
}